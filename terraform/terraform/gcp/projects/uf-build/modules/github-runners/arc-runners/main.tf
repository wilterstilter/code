# --- DATA SOURCES ---
data "google_container_cluster" "primary" {
  project  = var.project_id
  name     = var.cluster_name
  location = var.location
}

# --- GCP CREDENTIALS ---
data "google_client_config" "default" {}



# --- GOOGLE SECRET MANAGER ---
# Fetch the service account key for pulling images from GAR
data "google_secret_manager_secret_version" "jenkins_sa_key" {
  project = var.gar_project_id
  secret  = "sa-jenkins-nonprod-key"
}



# --- KUBERNETES AND WORKLOAD IDENTITY SETUP ---
data "kubernetes_namespace" "arc_namespace" {
  metadata {
    name = local.arc_namespace
  }
  depends_on = [
    data.google_container_cluster.primary
  ]
}

# --- LOCAL NAMESPACES AND RESOURCES ---
locals {
  arc_namespace   = var.arc_namespace
  controller_name = var.controller_name
  # Use GitHub PAT from variable (passed from GitHub secrets via environment variable)
  github_pat_value = var.github_pat
  # Use custom image from GAR (built via GitHub Actions) or fallback image
  final_runner_image = var.enable_custom_image ? "${var.gar_location}-docker.pkg.dev/${var.gar_project_id}/${var.gar_repository}/${var.custom_image_name}:${var.image_tag}" : var.fallback_runner_image
}

# --- GSA AND KSA ---
resource "google_service_account" "runner_controller" {
  project      = var.project_id
  account_id   = "${local.controller_name}-sa"
  display_name = var.display_name
}

# --- WORKLOAD IDENTITY BINDING ---
resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.runner_controller.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${local.arc_namespace}/${local.controller_name}]"
  ]
}

# --- GITHUB ACTIONS WORKLOAD IDENTITY FEDERATION ---
# Create a Workload Identity Pool for GitHub Actions
resource "google_iam_workload_identity_pool" "github_actions" {
  project                   = var.project_id
  workload_identity_pool_id = "github-actions"
  display_name              = "GitHub Actions"
  description               = "Workload Identity Pool for GitHub Actions"
}

# Create a Workload Identity Provider for GitHub
resource "google_iam_workload_identity_pool_provider" "github" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions.workload_identity_pool_id
  workload_identity_pool_provider_id = "github"
  display_name                       = "GitHub"
  description                        = "GitHub Actions OIDC provider"

  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }

  attribute_condition = "assertion.repository_owner=='uber-freight-internal'"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# Create a service account for GitHub Actions to use for building and pushing images
resource "google_service_account" "github_actions_builder" {
  project      = var.project_id
  account_id   = "github-actions-builder"
  display_name = "GitHub Actions Builder"
  description  = "Service account for GitHub Actions to build and push container images"
}

# Grant the GitHub Actions service account permission to push to Artifact Registry
resource "google_artifact_registry_repository_iam_member" "github_actions_writer" {
  project    = var.gar_project_id
  location   = var.gar_location
  repository = var.gar_repository
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.github_actions_builder.email}"
}

# Allow GitHub Actions from your repository to impersonate the service account
resource "google_service_account_iam_binding" "github_actions_workload_identity" {
  service_account_id = google_service_account.github_actions_builder.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_actions.name}/attribute.repository/${var.github_repository_full != "" ? var.github_repository_full : var.github_repository}"
  ]
}

resource "kubernetes_service_account" "runner_controller" {
  metadata {
    name      = local.controller_name
    namespace = local.arc_namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.runner_controller.email
    }
  }
  depends_on = [data.kubernetes_namespace.arc_namespace]
}

# --- KUBERNETES SECRET FOR GITHUB PAT ---
resource "kubernetes_secret" "github_pat_secret" {
  metadata {
    name      = var.pat_name
    namespace = local.arc_namespace
  }
  data = {
    # The key within the secret must be 'github_token'
    "github_token" = local.github_pat_value
  }
  type = "Opaque"

  depends_on = [data.kubernetes_namespace.arc_namespace]
}

# --- KUBERNETES SECRET FOR IMAGE PULLING ---
resource "kubernetes_secret" "docker_registry_auth" {
  metadata {
    name      = "gar-pull-secret"
    namespace = local.arc_namespace
  }
  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.gar_location}-docker.pkg.dev" = {
          auth = base64encode("_json_key:${data.google_secret_manager_secret_version.jenkins_sa_key.secret_data}")
        }
      }
    })
  }

  depends_on = [data.kubernetes_namespace.arc_namespace]
}

# --- ACTIONS RUNNER CONTROLLER (ARC) HELM DEPLOYMENT ---

# 1. Deploy the ARC Controller (Operator)
resource "helm_release" "arc_controller" {
  name             = local.controller_name
  repository       = var.gcr_repo
  chart            = var.gcr_controller_chart
  namespace        = local.arc_namespace
  create_namespace = false

  values = [
    yamlencode({
      manager = {
        serviceAccount = {
          name = kubernetes_service_account.runner_controller.metadata[0].name
        }
        replicaCount = var.replicaCount
      }
    })
  ]

  depends_on = [
    kubernetes_service_account.runner_controller,
  ]
}

# 2. Deploy the Runner Scale Sets (Light and Heavy workloads)
resource "helm_release" "arc_runner_sets" {
  for_each = var.runner_sets

  name             = each.value.runner_set_name
  repository       = var.gcr_repo
  chart            = var.gcr_runner_chart
  namespace        = local.arc_namespace
  create_namespace = false
  force_update     = true # Force update when values change

  values = [
    yamlencode({
      githubConfigSecret = kubernetes_secret.github_pat_secret.metadata[0].name
      githubConfigUrl    = "https://github.com/${var.github_repository}"
      minRunners         = each.value.min_runners
      maxRunners         = each.value.max_runners
      runnerGroup        = each.value.runner_group
      template = {
        spec = {
          securityContext = {
            fsGroup = 1000 # This makes all volume files accessible to group 1000
          }
          serviceAccountName = kubernetes_service_account.runner_controller.metadata[0].name
          imagePullSecrets = [{
            name = kubernetes_secret.docker_registry_auth.metadata[0].name
          }]
          volumes = [{
            name     = "buildkit-socket"
            emptyDir = {}
          }]
          containers = [
            # 1. The Main Actions Runner Container
            {
              name  = each.value.pod_name
              image = local.final_runner_image
              env = [
                {
                  name  = "BUILDKIT_HOST"
                  value = "unix:///run/buildkit/buildkitd.sock"
                }
              ]
              volumeMounts = [{
                name      = "buildkit-socket"
                mountPath = "/run/buildkit"
              }]
              resources = {
                # These values should be monitored and tuned based on actual build usage
                limits = {
                  cpu                 = each.value.pod_cpu_limit
                  memory              = each.value.pod_memory_limit
                  "ephemeral-storage" = each.value.pod_ephemeral_storage_limit
                }
                requests = {
                  cpu                 = each.value.pod_cpu_request
                  memory              = each.value.pod_memory_request
                  "ephemeral-storage" = each.value.pod_ephemeral_storage_request
                }
              }
            },
            # 2. The BuildKit Sidecar Container
            {
              name  = "buildkitd"
              image = var.buildkit_pod_image
              command = [
                "rootlesskit",
                "buildkitd",
                "--addr", "unix:///run/buildkit/buildkitd.sock",
                "--oci-worker-no-process-sandbox"
              ]
              env = [
                {
                  name  = "BUILDKIT_GARBAGE_COLLECTION_INTERVAL"
                  value = "300" # Run GC every 5 minutes
                },
                {
                  name  = "BUILDKIT_GARBAGE_COLLECTION_KEEP_STORAGE"
                  value = each.key == "light" ? "1000" : "2000" # 1GB for light, 2GB for heavy (in MB)
                },
                {
                  name  = "BUILDKIT_PRUNE_KEEP_DURATION"
                  value = "24h" # Keep build cache for 24 hours
                },
                {
                  name = "BUILDKIT_PRUNE_KEEP_STORAGE"
                  # Adjust based on runner type
                  value = each.key == "light" ? "1GB" : "2GB"
                }
              ]
              volumeMounts = [{
                name      = "buildkit-socket"
                mountPath = "/run/buildkit"
              }]
              securityContext = {
                seccompProfile = {
                  type = "Unconfined"
                }
                appArmorProfile = {
                  type = "Unconfined"
                }
                runAsUser    = 1000
                runAsGroup   = 1000
                runAsNonRoot = true
              }
              resources = {
                limits = {
                  cpu                 = each.value.buildkit_cpu_limit
                  memory              = each.value.buildkit_memory_limit
                  "ephemeral-storage" = each.value.buildkit_ephemeral_storage_limit
                }
                requests = {
                  cpu                 = each.value.buildkit_cpu_request
                  memory              = each.value.buildkit_memory_request
                  "ephemeral-storage" = each.value.buildkit_ephemeral_storage_request
                }
              }
            }
          ]
        }
      }
    })
  ]

  depends_on = [
    helm_release.arc_controller,
    kubernetes_secret.github_pat_secret,
    kubernetes_secret.docker_registry_auth
  ]
}
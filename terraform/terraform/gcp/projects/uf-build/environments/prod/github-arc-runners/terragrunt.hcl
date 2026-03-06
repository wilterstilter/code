include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "${dirname(find_in_parent_folders())}//projects/uf-build/modules/github-runners/arc-runners"
}

locals {
  # --- General & GKE Config ---
  project_id    = "uf-compute-d"
  cluster_name  = "gke-dev"
  location      = "us-south1"
  arc_namespace = "github-runners"

  # --- Container Registry Config ---
  gar_location          = "us"
  gar_repository        = "uf-internal"
  custom_image_name     = "arc-custom-runner"
  enable_custom_image   = false
  image_tag             = "latest"                                                            # Use "latest" for auto-builds, or specific version for rollbacks
  fallback_runner_image = "us-docker.pkg.dev/uf-build-p/uf-internal/arc-custom-runner:latest" # Using the already built custom image

  # --- GitHub & ARC Config ---
  github_repository    = "uber-freight-internal"
  github_repository_full = "uber-freight-internal/code"
  controller_name      = "arc-controller"
  display_name         = "Actions Runner Controller GSA"
  pat_secret_name      = "arc-pat-secret"

  # --- Helm Chart Config ---
  arc_helm_repo        = "oci://ghcr.io/actions/actions-runner-controller-charts"
  arc_controller_chart = "gha-runner-scale-set-controller"
  arc_runner_set_chart = "gha-runner-scale-set"

  # --- Controller Configuration ---
  controller_replicas = 2

  # --- Multi-Runner Set Configuration (Only have one runner set for now) ---
  runner_sets = {
    heavy = {
      runner_set_name = "arc-runner-set"
      pod_name        = "runner"
      min_runners     = 2
      max_runners     = 15
      runner_group    = "gke-runners"
      # Heavy runner resources
      pod_cpu_limit                 = "4"
      pod_memory_limit              = "16Gi"
      pod_cpu_request               = "4"
      pod_memory_request            = "8Gi"
      pod_ephemeral_storage_limit   = "10Gi"
      pod_ephemeral_storage_request = "9Gi"
      # BuildKit sidecar resources for heavy workloads
      buildkit_cpu_limit                 = "1"
      buildkit_memory_limit              = "4Gi"
      buildkit_cpu_request               = "500m"
      buildkit_memory_request            = "1Gi"
      buildkit_ephemeral_storage_limit   = "2Gi"
      buildkit_ephemeral_storage_request = "0.2Gi"
    }
  }

  # --- BuildKit Sidecar Image Details ---
  buildkit_image_repo = "moby/buildkit"
  buildkit_image_tag  = "v0.23.0-rootless"
}

inputs = {
  # --- General & GKE ---
  project_id    = local.project_id
  cluster_name  = local.cluster_name
  location      = local.location
  arc_namespace = local.arc_namespace

  # --- Container Registry ---
  gar_project_id        = "uf-build-p" # GAR is in the build project
  gar_location          = local.gar_location
  gar_repository        = local.gar_repository
  custom_image_name     = local.custom_image_name
  enable_custom_image   = local.enable_custom_image
  image_tag             = local.image_tag
  fallback_runner_image = local.fallback_runner_image

  # --- GitHub & ARC ---
  github_repository      = local.github_repository
  github_repository_full = local.github_repository_full
  github_pat             = get_env("RUNNERS_PAT", "")
  controller_name        = local.controller_name
  display_name           = local.display_name
  pat_name               = local.pat_secret_name

  # --- Helm Charts ---
  gcr_repo             = local.arc_helm_repo
  gcr_controller_chart = local.arc_controller_chart
  gcr_runner_chart     = local.arc_runner_set_chart

  # --- Controller Configuration ---
  replicaCount = local.controller_replicas

  # --- Multi-Runner Set Configuration ---
  runner_sets = local.runner_sets

  # --- BuildKit Configuration ---
  # runner_pod_image is now built automatically by the module
  buildkit_pod_image = "${local.buildkit_image_repo}:${local.buildkit_image_tag}"
}
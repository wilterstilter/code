resource "google_project_iam_binding" "freight_data_admin" {
  project = var.project_id
  role    = "roles/container.admin"
  members = [
    "group:freight-data@uberfreight.com",
    "group:freight-data-vendor@uberfreight.com"
  ]
}

# Create service account for GKE
resource "google_service_account" "gke" {
  project                      = var.project_id
  account_id                   = var.name
  create_ignore_already_exists = true
}

# Essential IAM bindings for GKE service account
resource "google_project_iam_member" "gke_service_agent" {
  project = var.project_id
  role    = "roles/container.serviceAgent"
  member  = "serviceAccount:${google_service_account.gke.email}"
}

resource "google_project_iam_member" "editor" {
  project = var.project_id
  role    = "roles/container.defaultNodeServiceAccount"
  member  = "serviceAccount:${google_service_account.gke.email}"
}

# Shared VPC access for custom service account
resource "google_compute_subnetwork_iam_member" "custom_sa_subnetwork_access" {
  project    = var.network_project_id
  region     = var.region
  subnetwork = var.subnetwork
  role       = "roles/compute.networkUser"
  member     = "serviceAccount:${google_service_account.gke.email}"
}

# Grants the Artifact Registry Reader role to the GKE service account
resource "google_project_iam_member" "gke_node_artifact_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.gke.email}"
}

# Required: Container Engine Robot Service Account network access - Host Project
resource "google_compute_subnetwork_iam_member" "container_engine_robot_network_user" {
  project    = var.network_project_id
  region     = var.region
  subnetwork = var.subnetwork
  role       = "roles/compute.networkUser"
  member     = "serviceAccount:service-${var.project_number}@container-engine-robot.iam.gserviceaccount.com"
}

# Required: Container Engine Robot Service Account network access - Service Project
resource "google_project_iam_member" "container_engine_robot_network_user_service" {
  project = var.project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:service-${var.project_number}@container-engine-robot.iam.gserviceaccount.com"
}

# Grant service agent role to the gke default service account
resource "google_project_iam_member" "gke_service_agent_2" {
  project = var.project_id
  role    = "roles/container.serviceAgent"
  member  = "serviceAccount:service-${var.project_number}@container-engine-robot.iam.gserviceaccount.com"
}

# Grant Host Service Agent User role to GKE service account
resource "google_project_iam_member" "gke_host_agent" {
  project = var.network_project_id
  role    = "roles/container.hostServiceAgentUser"
  member  = "serviceAccount:service-${var.project_number}@container-engine-robot.iam.gserviceaccount.com"
}

# Required: Security Admin role for Container Engine Robot - Host Project
resource "google_project_iam_member" "container_engine_security_admin" {
  project = var.network_project_id
  role    = "roles/compute.securityAdmin"
  member  = "serviceAccount:service-${var.project_number}@container-engine-robot.iam.gserviceaccount.com"
}

# Required: Cloud Services Service Account network access - Host Project
resource "google_compute_subnetwork_iam_member" "cloud_services_network_user" {
  project    = var.network_project_id
  region     = var.region
  subnetwork = var.subnetwork
  role       = "roles/compute.networkUser"
  member     = "serviceAccount:${var.project_number}@cloudservices.gserviceaccount.com"
}

# Workload Identity binding for KSA to GSA
resource "google_service_account_iam_member" "ksa_binding" {
  count              = var.workload_identity_service_account != "" && var.workload_identity_ksa_name != "" ? 1 : 0
  service_account_id = "projects/${var.project_id}/serviceAccounts/${var.workload_identity_service_account}"
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${var.workload_identity_ksa_namespace}/${var.workload_identity_ksa_name}]"
}

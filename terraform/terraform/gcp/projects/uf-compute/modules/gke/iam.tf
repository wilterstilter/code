resource "google_project_iam_binding" "devops_admin" {
  project = var.project_id
  role    = "roles/container.admin"
  members = [
    "group:${var.group}",
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

# Add GKE Hub admin permissions for DevOps group (covers all Hub permissions)
resource "google_project_iam_binding" "devops_hub_admin" {
  project = var.project_id
  role    = "roles/gkehub.admin"
  members = [
    "group:${var.group}",
  ]
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

# GKE Hub permissions for GKE Service Account
resource "google_project_iam_member" "gke_sa_hub_admin" {
  project = var.project_id
  role    = "roles/gkehub.admin"
  member  = "serviceAccount:${google_service_account.gke.email}"
}

resource "google_project_iam_member" "editor_1" {
  project = var.project_id
  role    = "roles/container.nodeServiceAccount"
  member  = "serviceAccount:${google_service_account.gke.email}"
}

#resource "google_project_iam_member" "container_engine_security_admin_2" {
#  project = var.network_project_id
#  role    = "roles/compute.securityAdmin"
#  member  = "serviceAccount:${google_service_account.gke.email}"
#}

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

resource "google_project_iam_member" "gkehub_admin_2" {
  project = var.project_id
  role    = "roles/gkehub.admin"
  member  = "serviceAccount:service-${var.project_number}@container-engine-robot.iam.gserviceaccount.com"
}


# Required: Security Admin role for Container Engine Robot - Host Project
resource "google_project_iam_member" "container_engine_security_admin" {
  project = var.network_project_id
  role    = "roles/compute.securityAdmin"
  member  = "serviceAccount:service-${var.project_number}@container-engine-robot.iam.gserviceaccount.com"
}

resource "google_compute_subnetwork_iam_member" "security_admin_access" {
  region     = var.region
  subnetwork = var.subnetwork
  role       = "roles/compute.securityAdmin"
  member     = "serviceAccount:service-${var.project_number}@container-engine-robot.iam.gserviceaccount.com"
}

resource "google_compute_subnetwork_iam_member" "sa_subnetwork_access" {
  project    = var.network_project_id
  region     = var.region
  subnetwork = var.subnetwork
  role       = "roles/compute.networkUser"
  member     = "serviceAccount:service-${var.project_number}@gcp-sa-gkehub.iam.gserviceaccount.com"
}

#resource "google_compute_subnetwork_iam_member" "service_subnetwork_access" {
#  region     = var.region
#  subnetwork = var.subnetwork
#  role       = "roles/compute.networkUser"
#  member     = "serviceAccount:service-${var.project_number}@gcp-sa-gkehub.iam.gserviceaccount.com"
#}

resource "google_project_iam_member" "gkehub_serviceagent" {
  project = var.project_id
  role    = "roles/gkehub.serviceAgent"
  member  = "serviceAccount:service-${var.project_number}@gcp-sa-gkehub.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "editor_2" {
  project = var.project_id
  role    = "roles/container.nodeServiceAccount"
  member  = "serviceAccount:service-${var.project_number}@gcp-sa-gkehub.iam.gserviceaccount.com"
}

# Required: Cloud Services Service Account network access - Host Project
resource "google_compute_subnetwork_iam_member" "cloud_services_network_user" {
  project    = var.network_project_id
  region     = var.region
  subnetwork = var.subnetwork
  role       = "roles/compute.networkUser"
  member     = "serviceAccount:${var.project_number}@cloudservices.gserviceaccount.com"
}

# Required: Cloud Services Service Account network access - Service Project
/*resource "google_project_iam_member" "cloud_services_network_user_service" {
  project = var.project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:${var.project_number}@cloudservices.gserviceaccount.com"
} */

resource "google_project_iam_member" "service_mesh_service_agent_network" {
  project = var.network_project_id
  role    = "roles/anthosservicemesh.serviceAgent"
  member  = "serviceAccount:service-${var.project_number}@gcp-sa-servicemesh.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "service_mesh_service_agent_host" {
  project = var.project_id
  role    = "roles/anthosservicemesh.serviceAgent"
  member  = "serviceAccount:service-${var.project_number}@gcp-sa-servicemesh.iam.gserviceaccount.com"
}

resource "google_project_iam_binding" "monitoring_viewer" {
  project = var.project_id
  role    = "roles/monitoring.viewer"
  members = [
    "group:${var.group}",
  ]
}

# View GKE backup plans (required for gkebackup.backupPlans.list)
resource "google_project_iam_binding" "gkebackup_viewer" {
  project = var.project_id
  role    = "roles/gkebackup.viewer"
  members = [
    "group:${var.group}",
  ]

}

# View GKE backup plans (required for gkebackup.backupPlans.list)
resource "google_project_iam_binding" "service_mesh_serviceUsageAdmin" {
  project = var.project_id
  role    = "roles/serviceusage.serviceUsageAdmin"
  members = [
    "group:${var.group}",
  ]
}

# =============================================================================
# OpenTelemetry Collector IAM Resources
# =============================================================================

# OpenTelemetry Service Account
resource "google_service_account" "opentelemetry_collector" {
  count        = var.enable_opentelemetry ? 1 : 0
  project      = var.project_id
  account_id   = "${var.name}-otel-collector"
  display_name = "OpenTelemetry Collector Service Account for ${var.name}"
  description  = "Service account for OpenTelemetry Collector with permissions to write metrics, logs, and traces"
}

# OpenTelemetry Workload Identity binding
resource "google_service_account_iam_binding" "opentelemetry_workload_identity" {
  count              = var.enable_opentelemetry ? 1 : 0
  service_account_id = google_service_account.opentelemetry_collector[0].name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[${var.opentelemetry_namespace}/${var.opentelemetry_service_account_name}]"
  ]
}

# OpenTelemetry logging permissions
resource "google_project_iam_member" "opentelemetry_logging_writer" {
  count   = var.enable_opentelemetry ? 1 : 0
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.opentelemetry_collector[0].email}"
}

# OpenTelemetry monitoring permissions
resource "google_project_iam_member" "opentelemetry_monitoring_metric_writer" {
  count   = var.enable_opentelemetry ? 1 : 0
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.opentelemetry_collector[0].email}"
}

# OpenTelemetry Cloud Trace permissions
resource "google_project_iam_member" "opentelemetry_cloudtrace_agent" {
  count   = var.enable_opentelemetry ? 1 : 0
  project = var.project_id
  role    = "roles/cloudtrace.agent"
  member  = "serviceAccount:${google_service_account.opentelemetry_collector[0].email}"
}

# OpenTelemetry Secret Manager access (conditional for Datadog)
resource "google_project_iam_member" "opentelemetry_secret_manager_accessor" {
  count   = var.enable_opentelemetry && var.opentelemetry_enable_datadog ? 1 : 0
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.opentelemetry_collector[0].email}"
}
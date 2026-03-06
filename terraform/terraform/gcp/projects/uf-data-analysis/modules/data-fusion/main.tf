#data "google_compute_default_service_account" "default_sa" {
#  project = var.project_id
#}

data "google_service_account" "dataproc_sa" {
  project    = var.project_id
  account_id = "sa-datafusion"
}

resource "google_data_fusion_instance" "private_instance" {
  project                       = var.project_id
  name                          = var.instance_name
  description                   = "Private Data Fusion instance"
  region                        = var.region
  type                          = var.instance_type
  enable_stackdriver_logging    = true
  enable_stackdriver_monitoring = true
  private_instance              = true
  enable_rbac                   = true # RBAC enabled for enterprise instance
  dataproc_service_account      = data.google_service_account.dataproc_sa.email

  network_config {
    network       = "projects/${var.host_project_id}/global/networks/${var.host_network_name}"
    ip_allocation = var.ip_allocation
  }
}

resource "google_project_iam_member" "datafusion_agent_network_user" {
  project = var.host_project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:service-${var.service_project_number}@gcp-sa-datafusion.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "dataproc_sa_network_user" {
  project = var.host_project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:${data.google_service_account.dataproc_sa.email}" #"serviceAccount:${var.dataproc_service_account}"
}

resource "google_project_iam_member" "dataproc_service_agent_network_user" {
  project = var.host_project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:service-${var.service_project_number}@dataproc-accounts.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "dataproc_editor_role" {
  project = var.project_id
  role    = "roles/dataproc.editor"
  member  = "serviceAccount:${data.google_service_account.dataproc_sa.email}" #"serviceAccount:${var.dataproc_service_account}"
}

resource "google_project_iam_member" "dataproc_runner_worker_role" {
  project = var.project_id
  role    = "roles/dataproc.worker"
  member  = "serviceAccount:${data.google_service_account.dataproc_sa.email}" #"serviceAccount:${var.dataproc_service_account}"
}

resource "google_project_iam_member" "dataproc_storage_object_admin" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${data.google_service_account.dataproc_sa.email}" #"serviceAccount:${var.dataproc_service_account}"
}

resource "google_project_iam_member" "dataproc_storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${data.google_service_account.dataproc_sa.email}" #"serviceAccount:${var.dataproc_service_account}"
}

#data "google_service_account" "dataproc-runner" {
#  project    = var.project_id
#  account_id = "sa-datafusion"
#}

resource "google_service_account_iam_member" "datafusion_impersonation_role" {
  service_account_id = data.google_service_account.dataproc_sa.name #data.google_compute_default_service_account.default_sa.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:service-${var.service_project_number}@gcp-sa-datafusion.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "datafusion_dataproc_viewer" {
  project = var.project_id
  role    = "roles/dataproc.viewer"
  member  = "serviceAccount:service-${var.service_project_number}@gcp-sa-datafusion.iam.gserviceaccount.com"
}

#resource "google_service_account_iam_member" "datafusion_impersonation_user" {
#  service_account_id = data.google_compute_default_service_account.default_sa.name
#  role               = "roles/iam.serviceAccountUser"
#  member             = "group:freight-data@uberfreight.com"
#}

resource "google_project_iam_member" "datafusion_runner" {
  project = var.project_id
  role    = "roles/datafusion.runner"
  member  = "serviceAccount:${data.google_service_account.dataproc_sa.email}" #"serviceAccount:${var.dataproc_service_account}"
}

resource "google_project_iam_member" "datafusion_service_agent_runner" {
  project = var.project_id
  role    = "roles/datafusion.runner"
  member  = "serviceAccount:service-${var.service_project_number}@dataproc-accounts.iam.gserviceaccount.com"
}

#resource "google_service_account_iam_binding" "token_creator_binding" {
#  service_account_id = data.google_service_account.dataproc_sa.name
#  role               = "roles/iam.serviceAccountTokenCreator"
#  members            = ["group:freight-data@uberfreight.com"]
#}

data "google_service_account" "datafusion_all_users_sa" {
  project    = var.project_id
  account_id = "sa-datafusion-all-users"
}

resource "google_service_account_iam_binding" "all_users_sa_impersonation_binding" {
  service_account_id = data.google_service_account.datafusion_all_users_sa.name
  role               = "roles/iam.serviceAccountUser"
  members            = ["serviceAccount:service-${var.service_project_number}@gcp-sa-datafusion.iam.gserviceaccount.com", "group:freight-data@uberfreight.com"]
}

resource "google_project_iam_member" "dataproc_all_users_runner_worker_role" {
  project = var.project_id
  role    = "roles/dataproc.worker"
  member  = "serviceAccount:${data.google_service_account.datafusion_all_users_sa.email}"
}

resource "google_project_iam_member" "dataproc_all_users_storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${data.google_service_account.datafusion_all_users_sa.email}"
}

resource "google_project_iam_member" "datafusion_all_users_runner" {
  project = var.project_id
  role    = "roles/datafusion.runner"
  member  = "serviceAccount:${data.google_service_account.datafusion_all_users_sa.email}"
}

resource "google_project_iam_member" "dataproc_all_users_editor_role" {
  project = var.project_id
  role    = "roles/dataproc.editor"
  member  = "serviceAccount:${data.google_service_account.datafusion_all_users_sa.email}"
}

resource "google_project_iam_member" "dataproc_all_users_storage_object_admin" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${data.google_service_account.datafusion_all_users_sa.email}"
}

#resource "google_project_iam_member" "dataproc_all_users_sa_network_user" {
#  project = var.host_project_id
#  role    = "roles/compute.networkUser"
#  member  = "serviceAccount:${data.google_service_account.datafusion_all_users_sa.email}"
#}

# Create a service account for the Dataflow worker
resource "google_service_account" "dataflow_worker" {
  account_id   = var.service_account
  display_name = "Dataflow Worker Service Account"
}

import {
  id = "projects/uf-logging-p/serviceAccounts/dataflow-worker@uf-logging-p.iam.gserviceaccount.com"
  to = google_service_account.dataflow_worker
}

# Assign the necessary roles to the service account
locals {
  roles = [
    "roles/dataflow.admin",
    "roles/dataflow.worker",
    "roles/pubsub.viewer",
    "roles/pubsub.subscriber",
    "roles/pubsub.publisher",
    "roles/storage.objectAdmin",
    "roles/compute.networkUser"
  ]
}

resource "google_project_iam_member" "dataflow_worker_roles" {
  for_each = toset(local.roles)
  project  = var.project_id
  role     = each.key
  member   = "serviceAccount:${google_service_account.dataflow_worker.email}"
}

resource "google_compute_subnetwork_iam_member" "dataflow_controller_subnetwork_access" {
  project    = var.network_project_id
  region     = var.region
  subnetwork = var.subnetwork
  role       = "roles/compute.networkUser"
  member     = "serviceAccount:${var.controller_service_account}"
}

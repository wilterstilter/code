locals {
  gsa_name = var.create_sa ? google_service_account.parcel_apiedge_gcs_sa[0].name : "projects/${var.project_id}/serviceAccounts/parcel-apiedge-svc-gcs-sa@${var.project_id}.iam.gserviceaccount.com"

  workload_identity_enabled = (
    var.k8s_namespace != null &&
    var.k8s_service_account_name != null
  )
}

# GSA for Parcel Apiedge GCS access with accidental deletion protection
resource "google_service_account" "parcel_apiedge_gcs_sa" {
  count        = var.create_sa ? 1 : 0
  account_id   = "parcel-apiedge-svc-gcs-sa"
  display_name = "Parcel Apiedge GCS Access"

  lifecycle {
    prevent_destroy = true
  }
}

# Assign Object Admin permissions to the bucket
resource "google_storage_bucket_iam_member" "parcel_bucket_admin" {
  bucket = var.create_bucket ? google_storage_bucket.cloud_storage_bucket[0].name : var.bucket_name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${var.create_sa ? google_service_account.parcel_apiedge_gcs_sa[0].email : "parcel-apiedge-svc-gcs-sa@${var.project_id}.iam.gserviceaccount.com"}"
}

# Bind GKE Service Account to GSA via Workload Identity (OPTIONAL)
resource "google_service_account_iam_member" "wi_binding" {
  count = local.workload_identity_enabled ? 1 : 0

  service_account_id = local.gsa_name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${var.k8s_namespace}/${var.k8s_service_account_name}]"
}
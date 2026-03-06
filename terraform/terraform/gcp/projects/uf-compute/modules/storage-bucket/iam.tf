# GSA for GCS access with accidental deletion protection
resource "google_service_account" "storage_gcs_sa" {
  count        = var.create_sa ? 1 : 0
  account_id   = var.service_account_id
  display_name = var.service_account_display_name

  lifecycle {
    prevent_destroy = true
  }
}

# Assign Object Admin permissions to the bucket
resource "google_storage_bucket_iam_member" "storage_bucket_admin" {
  count  = local.gsa_email != "" ? 1 : 0
  bucket = local.bucket_name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${local.gsa_email}"
}

# Bind GKE Service Account to GSA via Workload Identity (OPTIONAL)
resource "google_service_account_iam_member" "wi_binding" {
  count = local.workload_identity_enabled && local.gsa_email != "" ? 1 : 0

  service_account_id = local.gsa_name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${var.k8s_namespace}/${var.k8s_service_account_name}]"
}
locals {
  # Service account email - handles null, empty, and invalid values
  gsa_email = var.create_sa ? google_service_account.storage_gcs_sa[0].email : try(coalesce(var.existing_service_account_email, ""), "")

  # Service account name for workload identity
  gsa_name = var.create_sa ? google_service_account.storage_gcs_sa[0].name : (local.gsa_email != "" ? "projects/${var.project_id}/serviceAccounts/${local.gsa_email}" : "")

  workload_identity_enabled = (
    var.k8s_namespace != null &&
    var.k8s_service_account_name != null
  )

  # Local to simplify bucket reference
  bucket_name = var.create_bucket ? google_storage_bucket.cloud_storage_bucket[0].name : data.google_storage_bucket.existing_bucket[0].name
}
# modules/compute-instance/iam.tf

# IAM binding to grant the user-managed service account access to the storage bucket
resource "google_storage_bucket_iam_member" "bucket_access" {
  # Only create if we have a service account email and a bucket name
  count = local.service_account_email != null && var.storage_bucket_name != null ? 1 : 0

  bucket = var.storage_bucket_name
  role   = var.storage_bucket_role
  member = "serviceAccount:${local.service_account_email}"
}
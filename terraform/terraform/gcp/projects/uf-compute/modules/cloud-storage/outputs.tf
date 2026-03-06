# --- GCS Bucket Outputs ---

output "bucket_name" {
  description = "The name of the GCS bucket"
  value       = var.create_bucket ? google_storage_bucket.cloud_storage_bucket[0].name : var.bucket_name
}

output "bucket_url" {
  description = "The URL of the GCS bucket"
  value       = var.create_bucket ? google_storage_bucket.cloud_storage_bucket[0].url : "gs://${var.bucket_name}"
}

# --- Service Account Outputs ---

output "gsa_email" {
  description = "Email of the GCP Service Account used by pods"
  value       = var.create_sa ? google_service_account.parcel_apiedge_gcs_sa[0].email : "parcel-apiedge-svc-gcs-sa@${var.project_id}.iam.gserviceaccount.com"
}

output "gsa_id" {
  description = "ID of the GCP Service Account"
  value       = var.create_sa ? google_service_account.parcel_apiedge_gcs_sa[0].name : "projects/${var.project_id}/serviceAccounts/parcel-apiedge-svc-gcs-sa@${var.project_id}.iam.gserviceaccount.com"
}
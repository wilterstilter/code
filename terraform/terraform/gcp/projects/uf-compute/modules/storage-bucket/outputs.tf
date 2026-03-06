# --- GCS Bucket Outputs ---

output "bucket_name" {
  description = "The name of the GCS bucket"
  value       = local.bucket_name
}

output "bucket_url" {
  description = "The URL of the GCS bucket"
  value       = "gs://${local.bucket_name}"
}

# --- Service Account Outputs ---

output "gsa_email" {
  description = "Email of the GCP Service Account used, if available"
  value       = local.gsa_email != "" ? local.gsa_email : null
}

output "gsa_id" {
  description = "ID of the GCP Service Account, if available"
  value       = local.gsa_name != "" ? local.gsa_name : null
}
# Outputs for GCS Migration Module

#------------------------------------------------------------------------------
# Bucket Outputs
#------------------------------------------------------------------------------

output "bucket_name" {
  description = "Name of the created GCS bucket"
  value       = google_storage_bucket.migration.name
}

output "bucket_url" {
  description = "URL of the bucket (gs://...)"
  value       = google_storage_bucket.migration.url
}

output "bucket_self_link" {
  description = "Self link of the bucket"
  value       = google_storage_bucket.migration.self_link
}

output "bucket_location" {
  description = "Location of the bucket"
  value       = google_storage_bucket.migration.location
}

#------------------------------------------------------------------------------
# Service Account Outputs - Upload SA
#------------------------------------------------------------------------------

output "uploader_service_account_email" {
  description = "Email of the service account used for uploading data from on-prem"
  value       = google_service_account.migration_uploader.email
}

output "uploader_service_account_id" {
  description = "ID of the service account used for uploading data from on-prem"
  value       = google_service_account.migration_uploader.id
}

output "uploader_service_account_name" {
  description = "Name of the service account used for uploading data from on-prem"
  value       = google_service_account.migration_uploader.name
}

output "uploader_service_account_key_secret_id" {
  description = "Secret Manager secret ID where the service account key is stored"
  value       = var.create_service_account_key ? google_secret_manager_secret.uploader_key[0].secret_id : null
}

output "uploader_service_account_key_secret_name" {
  description = "Full Secret Manager secret name (projects/PROJECT_ID/secrets/SECRET_ID)"
  value       = var.create_service_account_key ? google_secret_manager_secret.uploader_key[0].name : null
}

output "uploader_service_account_key_secret_version" {
  description = "Secret Manager secret version containing the key"
  value       = var.create_service_account_key ? google_secret_manager_secret_version.uploader_key[0].name : null
}

#------------------------------------------------------------------------------
# Service Account Outputs - Reader SA (if created)
#------------------------------------------------------------------------------

output "reader_service_account_email" {
  description = "Email of the service account used by Cloud SQL to read migration data"
  value       = var.create_cloudsql_reader_sa ? google_service_account.migration_reader[0].email : null
}

output "reader_service_account_id" {
  description = "ID of the service account used by Cloud SQL to read migration data"
  value       = var.create_cloudsql_reader_sa ? google_service_account.migration_reader[0].id : null
}

#------------------------------------------------------------------------------
# Usage Instructions
#------------------------------------------------------------------------------

output "usage_instructions" {
  description = "Instructions for using the migration bucket"
  value       = <<-EOT
    GCS Migration Bucket Setup Complete!
    
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    📦 BUCKET DETAILS
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Name:     ${google_storage_bucket.migration.name}
    URL:      ${google_storage_bucket.migration.url}
    Location: ${google_storage_bucket.migration.location}
    
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🔑 SERVICE ACCOUNT FOR ON-PREM UPLOAD
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    Email:       ${google_service_account.migration_uploader.email}
    Permissions: ${var.uploader_permission_level}
    Key Storage: Secret Manager (secure!)
    
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    📥 RETRIEVE SERVICE ACCOUNT KEY (Stored Securely in Secret Manager)
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    Option 1: Using gcloud CLI (Recommended)
    ----------------------------------------
    gcloud secrets versions access latest \
      --secret="${var.create_service_account_key ? google_secret_manager_secret.uploader_key[0].secret_id : "sa-migration-uploader-key"}" \
      --project=${var.project_id} > migration-key.json
    
    chmod 600 migration-key.json
    
    Option 2: Using GCP Console
    ---------------------------
    https://console.cloud.google.com/security/secret-manager/secret/${var.create_service_account_key ? google_secret_manager_secret.uploader_key[0].secret_id : "sa-migration-uploader-key"}/versions?project=${var.project_id}
    
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🚀 USE FROM ON-PREM
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    1. Set authentication:
       export GOOGLE_APPLICATION_CREDENTIALS=/path/to/migration-key.json
    
    2. Test connection:
       gsutil ls gs://${google_storage_bucket.migration.name}/
    
    3. Upload data:
       gsutil cp database_export.sql gs://${google_storage_bucket.migration.name}/raw-data/
       
    4. Import to Cloud SQL:
       gcloud sql import sql INSTANCE_NAME \
         gs://${google_storage_bucket.migration.name}/raw-data/dump.sql \
         --database=DATABASE_NAME
    
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    🔒 SECURITY REMINDERS
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ✓ Key is securely stored in Secret Manager
    ✓ Access is audited via Cloud Audit Logs
    ✓ Rotate keys every 90 days
    ✓ Delete bucket and keys after migration
    ✓ Monitor access with Cloud Logging
    
    For detailed instructions, see: SERVICE_ACCOUNT_KEY_GUIDE.md
  EOT
}


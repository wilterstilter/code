locals {
  tms_cdc_connection_secret = "tms-cdc-connection-${lower(var.env)}"
}

### DATABASE CONFIGS
# Create a secret in Secret Manager
resource "google_secret_manager_secret" "tms_connection" {
  secret_id = local.tms_cdc_connection_secret
  labels    = merge(var.debezium_resource_labels, var.base_labels, { is_encrypted = true })
  replication {
    auto {}
  }
}

# Add a secret version with the password value
# DONE MANUALLY VIA UI TO ADD SECRETS
# TODO: migration to Vault instance under GCP/infra-as-code
# resource "google_secret_manager_secret_version" "tms_connection_payload" {
#   secret = google_secret_manager_secret.tms_connection.secret_id
#   secret_data = jsonencode({
#     username = "username"
#     password = "password"
#     host     = "host.com"
#     port     = 3306
#   })
# }

# Grant access to the user gcoiro@uberfreight.com - to manually create the secret versions
# https://gcp.permissions.cloud/predefinedroles/secretmanager.secretVersionManager (admin not required)
resource "google_secret_manager_secret_iam_member" "insert_access" {
  secret_id = google_secret_manager_secret.tms_connection.secret_id
  role      = "roles/secretmanager.secretVersionManager"
  member    = "user:gcoiro@uberfreight.com"
}

# Capture the secret value using Terraform data
## SETUP NEXT
# data "google_secret_manager_secret_version" "database_configs" {
#   secret = google_secret_manager_secret.tms_connection.id
# }

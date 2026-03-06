locals {
  pubsub_service_account_name = "pubsub-cdc-sa-${lower(var.env)}"
}

### PUBSUB
# Create a service account for Pubsub Access
# Grant Pub/Sub access to the service account
# https://cloud.google.com/pubsub/docs/access-control#pubsub.editor
module "service_accounts" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"
  project_id    = var.project_id
  names         = [local.pubsub_service_account_name]
  display_name  = "Pub/Sub Change Data Capture ${upper(var.env)} Service Account"
  generate_keys = true
  project_roles = [
    "${var.project_id}=>roles/pubsub.editor",
    "${var.project_id}=>roles/storage.objectViewer",
  ]
}

# Saving pubsub service account keys to secret manager
resource "google_secret_manager_secret" "pubsub_sa" {
  secret_id = "${local.pubsub_service_account_name}-keys"
  labels    = merge(var.debezium_resource_labels, var.base_labels)
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "pubsub_sa_version" {
  secret      = google_secret_manager_secret.pubsub_sa.id
  secret_data = module.service_accounts.key
}

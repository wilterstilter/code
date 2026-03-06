locals {
  generate_key_accounts = {
    for account_id, account in var.service_accounts :
    account_id => account
    if account.generate_key == true
  }
}

# Create a service account
resource "google_service_account" "etl_service_account" {
  for_each     = var.service_accounts
  account_id   = each.value["account_id"]
  display_name = each.value["display_name"]
}

# Generate Service account keys
resource "google_service_account_key" "etl_key" {
  for_each           = local.generate_key_accounts
  service_account_id = google_service_account.etl_service_account[each.value.account_id].name
}

# Create service account key Id to secret manager
resource "google_secret_manager_secret" "etl_secret_key_id" {
  for_each  = local.generate_key_accounts
  secret_id = each.value.account_id
  labels    = var.base_labels
  replication {
    auto {}
  }
}

# Store service account's Json key in Secret manager
resource "google_secret_manager_secret_version" "etl_secret_key_version" {
  for_each    = local.generate_key_accounts
  secret      = google_secret_manager_secret.etl_secret_key_id[each.value.account_id].id
  secret_data = base64decode(google_service_account_key.etl_key[each.value.account_id].private_key)
}

# Grant access to the group freight-data@uberfreight.com - to manually access the secret versions
# https://gcp.permissions.cloud/predefinedroles/secretmanager.secretAccessor
resource "google_secret_manager_secret_iam_member" "etl_secret_access" {
  for_each  = local.generate_key_accounts
  secret_id = google_secret_manager_secret.etl_secret_key_id[each.value.account_id].id
  role      = "roles/secretmanager.secretAccessor"
  member    = "group:freight-data@uberfreight.com"
}
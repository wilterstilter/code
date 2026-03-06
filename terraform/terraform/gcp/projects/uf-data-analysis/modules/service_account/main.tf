locals {
  generate_key_accounts = {
    for account_id, account in var.service_accounts :
    account_id => account
    if account.generate_key == true
  }
}

# Create a service account
resource "google_service_account" "da_service_account" {
  for_each     = var.service_accounts
  account_id   = each.value["account_id"]
  display_name = each.value["display_name"]
}

# Generate Service account keys
resource "google_service_account_key" "da_key" {
  for_each           = local.generate_key_accounts
  service_account_id = google_service_account.da_service_account[each.key].name # Use the account_id as the key for the map
}

# Create service account key Id to secret manager
resource "google_secret_manager_secret" "da_secret_key_id" {
  for_each  = local.generate_key_accounts
  secret_id = each.value.account_id # Using account_id as secret_id
  labels    = var.base_labels
  replication {
    auto {}
  }
}

# Store service account's Json key in Secret manager
resource "google_secret_manager_secret_version" "da_secret_key_version" {
  for_each    = local.generate_key_accounts
  secret      = google_secret_manager_secret.da_secret_key_id[each.key].id
  secret_data = base64decode(google_service_account_key.da_key[each.key].private_key)
}

# Grant access to specific principal for their own service account key secret
resource "google_secret_manager_secret_iam_member" "da_secret_access_individual" {
  for_each = {
    for k, v in local.generate_key_accounts : k => v
    if v.secret_accessor_principal != ""
  }
  secret_id = google_secret_manager_secret.da_secret_key_id[each.key].id
  role      = "roles/secretmanager.secretAccessor"
  member    = each.value.secret_accessor_principal
}

resource "google_project_iam_member" "project_level_secret_accessor_admin" {
  project  = var.project_id
  role     = "roles/secretmanager.secretAccessor"
  member   = "group:freight-data@uberfreight.com"
  for_each = local.generate_key_accounts
}

resource "google_project_iam_binding" "secretmanager_viewers" {
  project = var.project_id
  role    = "roles/secretmanager.viewer"
  members = var.secretmanager_viewers
}

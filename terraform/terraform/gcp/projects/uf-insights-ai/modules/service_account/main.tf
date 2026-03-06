variable "project_id" {
  type        = string
  description = "Project Unique Name - like uf-data-warehouse"
  nullable    = false
}
variable "service_accounts" {
  type = map(object({
    account_id   = string
    display_name = string
    generate_key = bool
  }))
}
variable "base_labels" {
  type        = map(string)
  description = "Base Labels to be added to all resource under this project"
  default     = {}
  nullable    = false
}

locals {
  generate_key_accounts = {
    for account_id, account in var.service_accounts :
    account_id => account
    if account.generate_key == true
  }

  freight_insights_ai_group = "insights-ai-dev@uberfreight.com"
}

# Tag service account to allow key creation
data "google_project" "current" {}

data "google_organization" "org" {
  domain = "uberfreight.com"
}

data "google_tags_tag_key" "service_account_key_creation_tag_key" {
  parent     = "organizations/${data.google_organization.org.org_id}"
  short_name = "serviceAccountKeyCreation"
}

data "google_tags_tag_value" "service_account_key_creation_tag_value" {
  parent     = data.google_tags_tag_key.service_account_key_creation_tag_key.id
  short_name = "allowed"
}

resource "google_tags_tag_binding" "binding" {
  parent    = "//cloudresourcemanager.googleapis.com/projects/${data.google_project.current.number}"
  tag_value = "tagValues/${data.google_tags_tag_value.service_account_key_creation_tag_value.name}"
}

# Create service accounts
resource "google_service_account" "service_account" {
  for_each     = var.service_accounts
  account_id   = each.value["account_id"]
  display_name = each.value["display_name"]
}

# Assign roles to the service accounts
resource "google_project_iam_member" "aiplatform" {
  for_each = var.service_accounts
  project  = var.project_id
  role     = "roles/aiplatform.user"
  member   = "serviceAccount:${google_service_account.service_account[each.value.account_id].email}"
}

# Generate Service account keys
resource "google_service_account_key" "key" {
  for_each           = local.generate_key_accounts
  service_account_id = google_service_account.service_account[each.value.account_id].name
  depends_on         = [google_tags_tag_binding.binding]
}

# Create service account key Id to secret manager
resource "google_secret_manager_secret" "secret_key_id" {
  for_each  = local.generate_key_accounts
  secret_id = each.value.account_id
  labels    = var.base_labels
  replication {
    auto {}
  }
}

# Store service account's Json key in Secret manager
resource "google_secret_manager_secret_version" "secret_key_version" {
  for_each    = local.generate_key_accounts
  secret      = google_secret_manager_secret.secret_key_id[each.value.account_id].id
  secret_data = base64decode(google_service_account_key.key[each.value.account_id].private_key)
}

resource "google_secret_manager_secret_iam_member" "secret_access" {
  for_each  = local.generate_key_accounts
  secret_id = google_secret_manager_secret.secret_key_id[each.value.account_id].id
  role      = "roles/secretmanager.secretAccessor"
  member    = "group:${local.freight_insights_ai_group}"
}

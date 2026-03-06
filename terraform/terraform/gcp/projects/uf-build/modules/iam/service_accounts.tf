# Tag service account to allow key creation
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

resource "google_service_account" "default" {
  for_each = toset(var.service_accounts)

  account_id   = each.key
  display_name = each.key
  description  = "Service accounts created for build and deploy infrastructure"
}

resource "google_service_account_key" "default" {
  for_each = toset(var.service_accounts)

  service_account_id = google_service_account.default[each.key].name
}

# Save key in secret for retrieval
resource "google_secret_manager_secret" "default" {
  for_each = toset(var.service_accounts)

  secret_id = "sa-${each.key}-key"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "default" {
  for_each = toset(var.service_accounts)

  secret      = google_secret_manager_secret.default[each.key].id
  secret_data = base64decode(google_service_account_key.default[each.key].private_key)
}

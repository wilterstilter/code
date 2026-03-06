data "google_project" "project" {
  project_id = var.project_id
}

# Service account creation
resource "google_service_account" "default" {
  account_id   = "bring-your-own-cloud-sa"
  display_name = "Cameyo Bring Your Own Cloud"
}

# Create the key for the service account
resource "google_service_account_key" "default" {
  service_account_id = google_service_account.default.name
}

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
  parent    = "//cloudresourcemanager.googleapis.com/projects/${data.google_project.project.number}"
  tag_value = "tagValues/${data.google_tags_tag_value.service_account_key_creation_tag_value.name}"
}

# Save key in secret for retrieval
resource "google_secret_manager_secret" "secret_basic_sa" {
  secret_id = "sa-secret"
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "secret_basic_sa_version" {
  secret      = google_secret_manager_secret.secret_basic_sa.id
  secret_data = base64decode(google_service_account_key.default.private_key)
}

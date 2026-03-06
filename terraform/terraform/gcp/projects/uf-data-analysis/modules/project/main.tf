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

// Getting the project number based on project id
// to adjust google tags tag binding
data "google_project" "current" {
  project_id = var.project_id
}

// Allowing project to get tag - for service account creation and key generation
resource "google_tags_tag_binding" "binding" {
  parent    = "//cloudresourcemanager.googleapis.com/projects/${data.google_project.current.number}"
  tag_value = "tagValues/${data.google_tags_tag_value.service_account_key_creation_tag_value.name}"
}
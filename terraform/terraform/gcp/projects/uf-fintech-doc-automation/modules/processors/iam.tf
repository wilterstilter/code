data "google_project" "project" {
  project_id = var.project_id
}

module "projects_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 7.7"
  mode    = "authoritative"

  projects = [var.project_id]

  bindings = {
    "roles/documentai.editor" = concat([
      "group:fintech_doc_ai_gcp@uberfreight.com",
      "group:financerpagcp@uberfreight.com",
      "serviceAccount:fintech-doc-ai-sa@uf-fintech-doc-automation-d.iam.gserviceaccount.com",
      "serviceAccount:service-${data.google_project.project.number}@gcp-sa-prod-dai-core.iam.gserviceaccount.com",
      ], [
      for project_number in var.authorized_project_numbers : "serviceAccount:service-${project_number}@gcp-sa-prod-dai-core.iam.gserviceaccount.com"
    ]),
    "roles/viewer" = [
      "group:fintech_doc_ai_gcp@uberfreight.com",
      "group:financerpagcp@uberfreight.com",
    ]
    "roles/secretmanager.secretAccessor" = [
      "group:fintech_doc_ai_gcp@uberfreight.com",
    ]
    "roles/aiplatform.user" = concat([
      "group:fintech_doc_ai_gcp@uberfreight.com",
      "group:financerpagcp@uberfreight.com",
      "serviceAccount:fintech-doc-ai-sa@uf-fintech-doc-automation-d.iam.gserviceaccount.com",
      "serviceAccount:service-${data.google_project.project.number}@gcp-sa-prod-dai-core.iam.gserviceaccount.com",
      ], [
      for project_number in var.authorized_project_numbers : "serviceAccount:service-${project_number}@gcp-sa-prod-dai-core.iam.gserviceaccount.com"
    ])
    "roles/aiplatform.viewer" = [
      "group:fintech_doc_ai_gcp@uberfreight.com",
      "group:financerpagcp@uberfreight.com",
    ]
    "roles/serviceusage.serviceUsageAdmin" = [
      "serviceAccount:fintech-doc-ai-sa@uf-fintech-doc-automation-d.iam.gserviceaccount.com",
    ]
  }
}

module "service_accounts" {
  source        = "terraform-google-modules/service-accounts/google"
  version       = "~> 3.0"
  project_id    = var.project_id
  names         = ["fintech-doc-ai-sa"]
  generate_keys = true
  project_roles = [
    "uf-fintech-doc-automation-d=>roles/storage.objectViewer",
    "uf-fintech-doc-automation-d=>roles/serviceusage.serviceUsageAdmin",
  ]
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

  labels = {
    team = "fintech"
  }

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "secret_basic_sa_version" {
  secret = google_secret_manager_secret.secret_basic_sa.id

  secret_data = module.service_accounts.key

}

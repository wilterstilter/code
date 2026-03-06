module "projects_iam_bindings" {
  for_each = var.project_iam_bindings
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  version  = "~> 7.7"
  mode     = "authoritative"
  projects = [
    var.project_id
  ]
  bindings = {
    (each.key) = each.value.entities
  }
}

module "service_account_iam_binding" {
  for_each         = var.service_account_iam_bindings
  source           = "terraform-google-modules/iam/google//modules/service_accounts_iam"
  version          = "~> 8.0"
  service_accounts = [var.uf_freight_search_service_account]
  project          = var.uf_freight_search_sa_project_id
  mode             = "additive"
  bindings = {
    (each.key) = each.value.entities
  }
}

resource "google_project_iam_binding" "bigquery_viewers" {
  project = var.project_id
  role    = "roles/bigquery.metadataViewer" # changing from dataviewer to metadataViewer
  members = var.bqviewers
}

resource "google_project_iam_binding" "bigquery_readers" {
  project = var.project_id
  role    = "roles/bigquery.dataViewer"
  members = var.bqreaders
}

resource "google_project_iam_binding" "gemini_users" {
  project = var.project_id
  role    = "roles/cloudaicompanion.user"
  members = var.gemini_users
}

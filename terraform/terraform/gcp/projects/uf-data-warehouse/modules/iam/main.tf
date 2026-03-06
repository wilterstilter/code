# BigQuery metadata viewers
resource "google_project_iam_binding" "bigquery_viewers" {
  project = var.project_id
  role    = "roles/bigquery.metadataViewer" # changing from dataviewer to metadataViewer
  members = var.bqviewers
}

# Custom Secret Editor Role Creation
resource "google_project_iam_custom_role" "secret_editor" {
  role_id     = "secret_editor"
  title       = "Secret Editor"
  description = "Read/update secret metadata, add versions, access values, but cannot delete"
  project     = var.project_id

  permissions = [
    "secretmanager.secrets.get",
    "secretmanager.secrets.update",
    "secretmanager.versions.add",
    "secretmanager.versions.access"
  ]
}

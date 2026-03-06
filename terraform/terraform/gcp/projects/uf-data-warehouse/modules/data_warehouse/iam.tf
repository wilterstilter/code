resource "google_project_iam_binding" "bigquery_readers" {
  project = var.project_id
  role    = "roles/bigquery.dataViewer"
  members = var.bqreaders
}

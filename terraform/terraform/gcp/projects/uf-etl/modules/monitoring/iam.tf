# Grant monitoring viewer access to specific groups
resource "google_project_iam_binding" "monitoring_viewer" {
  project = var.project_id
  role    = "roles/monitoring.viewer"
  members = [
    "group:freight-data@uberfreight.com",
    "group:freight-data-vendor@uberfreight.com"
  ]
}

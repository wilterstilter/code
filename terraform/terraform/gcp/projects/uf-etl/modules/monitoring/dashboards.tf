resource "google_monitoring_dashboard" "dashboard" {
  project        = var.project_id
  dashboard_json = (var.dashboard_json_file)
}

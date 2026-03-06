resource "google_monitoring_monitored_project" "monitoring_scope" {
  for_each      = toset(var.project_ids_to_monitor)
  metrics_scope = var.metrics_scope
  name          = each.value
}
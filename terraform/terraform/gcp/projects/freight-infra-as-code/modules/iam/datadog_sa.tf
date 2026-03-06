resource "google_service_account" "datadog" {
  account_id   = "datadog-monitor"
  display_name = "datadog-monitor"
  description  = "Service account to integrate GCP with Datadog"
}

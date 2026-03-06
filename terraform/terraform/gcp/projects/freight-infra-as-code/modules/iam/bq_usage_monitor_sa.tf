resource "google_service_account" "bq-usage-monitor" {
  account_id   = "bq-usage-monitor"
  display_name = "bq-usage-monitor"
  description  = "Service account to monitor Org wide BQ usage"
}

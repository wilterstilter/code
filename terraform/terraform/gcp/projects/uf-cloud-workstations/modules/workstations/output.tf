output "service_account" {
  value       = google_service_account.default.email
  description = "Service Account used for all VMs"
}

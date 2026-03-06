# Output the email of the service account
output "email" {
  description = "The email address of the service account."
  value       = google_service_account.crowdstrike_sa.email
}

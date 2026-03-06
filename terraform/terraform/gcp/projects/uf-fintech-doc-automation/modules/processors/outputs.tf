output "email" {
  description = "The service account email"
  value       = module.service_accounts.email
}

output "iam_email" {
  description = "The service account IAM format email"
  value       = module.service_accounts.iam_email
}

output "secret_ids" {
  description = "Map of secret names to their full resource IDs"
  value = {
    for k, v in google_secret_manager_secret.secrets : k => v.id
  }
}

output "secret_names" {
  description = "Map of secret names to their Secret Manager resource names"
  value = {
    for k, v in google_secret_manager_secret.secrets : k => v.name
  }
}

output "secret_versions" {
  description = "Map of secret names to their secret version resource names"
  value = {
    for k, v in google_secret_manager_secret_version.secret_versions : k => v.name
  }
  sensitive = true
}

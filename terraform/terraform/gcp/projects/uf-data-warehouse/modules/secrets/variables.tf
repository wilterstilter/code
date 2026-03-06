variable "project_id" {
  type        = string
  description = "The GCP project ID where secrets will be created"
}

variable "base_labels" {
  type        = map(string)
  description = "Base labels to apply to all secrets"
  default     = {}
}

variable "secrets" {
  type = map(object({
    secret_data               = optional(string)
    labels                    = map(string)
    accessor_service_accounts = list(string)
    accessor_groups           = list(string)
    editor_groups             = optional(list(string), [])
    admin_groups              = list(string)
  }))

  description = <<-EOT
Map of secrets to create in Secret Manager.
secret_data can be null if value is managed manually via UI or gcloud.
EOT
}

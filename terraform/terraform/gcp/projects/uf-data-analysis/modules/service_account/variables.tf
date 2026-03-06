variable "service_accounts" {
  type = map(object({
    account_id                = string
    display_name              = string
    generate_key              = bool
    secret_accessor_principal = string # This could be a group or a service account.
  }))
}

variable "base_labels" {
  type        = map(string)
  description = "Base Labels to be added to all resources under this project"
  default     = {}
  sensitive   = false
  nullable    = false
}

variable "project_id" {
  type        = string
  description = "Project Unique Name - like uf-data-analysis"
  nullable    = false
  sensitive   = false
}

variable "secretmanager_viewers" {
  type        = list(string)
  description = "List of members who can view the service accounts in the secret manager but not the secret values"
  default     = []
}

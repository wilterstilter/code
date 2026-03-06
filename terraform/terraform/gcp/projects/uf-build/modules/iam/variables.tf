variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "service_accounts" {
  type        = list(string)
  default     = []
  description = "Service accounts to be created"
}

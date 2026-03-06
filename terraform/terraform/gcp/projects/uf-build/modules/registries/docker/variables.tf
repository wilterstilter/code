variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "service_account_readers" {
  type        = list(string)
  default     = []
  description = "Service account emails that are authorized to pull images"
}

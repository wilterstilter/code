variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "authorized_project_numbers" {
  type        = list(string)
  description = "GCP project number for the projects that would be to import processor versions from current project"
  default     = []
}

variable "bucket_name_override" {
  type        = string
  description = "bucket name override for dev as it was already created and used"
  default     = null
}

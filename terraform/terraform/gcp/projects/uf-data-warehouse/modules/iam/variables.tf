variable "project_id" {
  type        = string
  description = "Project Unique name - like uf-etl"
  nullable    = false
  sensitive   = false
}

variable "bqviewers" {
  type        = list(string)
  description = "List of metadata viewers to be added to the project."
  default     = []
}

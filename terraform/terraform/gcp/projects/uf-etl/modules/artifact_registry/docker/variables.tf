variable "project_id" {
  type        = string
  description = "Project ID where the Docker Artifact Registry repositories are created."
  sensitive   = false
  nullable    = false
}

variable "location" {
  type        = string
  description = "Location where the Docker Artifact Registry repositories are created."
  sensitive   = false
  nullable    = false
}

variable "repositories" {
  type = map(object({
    description    = optional(string)
    keep_count     = optional(number, 10)
    immutable_tags = optional(bool, false)
  }))
  description = "Map of Docker repository configurations. Key is repository_id, value contains repository settings."
  default     = {}
}

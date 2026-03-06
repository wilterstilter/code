variable "project_id" {
  type        = string
  description = "Project Unique Name - like uf-change-data-capture-n"
  nullable    = false
  sensitive   = false
}

variable "env" {
  type        = string
  description = "Environment name to be used"
  nullable    = false
  sensitive   = false
  default     = "dev"
}

# https://cloud.google.com/storage/docs/locations
variable "bucket_location" {
  type        = string
  description = "Location to create resources"
  nullable    = false
  sensitive   = false
  default     = "US"
}

# variable "region" {
#   type        = string
#   description = "Region in GCP (Google Cloud Platform) to create resources"
#   nullable    = false
#   sensitive   = false
#   default     = "us-west8"
# }

variable "base_labels" {
  type        = map(string)
  description = "Base Labels to be added to all resource under this project"
  default     = {}
  sensitive   = false
  nullable    = false
}

variable "debezium_resource_labels" {
  type        = map(string)
  description = "Debezium Labels to be added to all resource related to CDC"
  default     = {}
  sensitive   = false
  nullable    = false
}

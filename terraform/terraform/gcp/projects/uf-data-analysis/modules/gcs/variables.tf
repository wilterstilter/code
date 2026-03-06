variable "region" {
  type        = string
  description = "Region where the GCS bucket is created."
  default     = "us-south1"
  sensitive   = false
  nullable    = false
}

variable "buckets" {
  type        = list(string)
  description = "A list of buckets to be created."
  default     = []
}

variable "project_id" {
  description = "The project ID where the resources will be created."
  type        = string
  default     = "uf-data-analysis"
}

variable "bucket_users" {
  type        = list(string)
  description = "List of storage bucket users to be added to the project."
  default     = []
}

variable "bucket_viewers" {
  type        = list(string)
  description = "List of storage bucket viewers to be added to the project."
  default     = []
}

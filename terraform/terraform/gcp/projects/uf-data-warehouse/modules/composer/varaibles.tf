variable "region" {
  type        = string
  description = "Region where the Cloud Composer Environment is created."
  default     = "us-south1"
  sensitive   = false
  nullable    = false
}

variable "buckets" {
  type        = list(string)
  description = "A list of buckets to be created."
  default     = []
}

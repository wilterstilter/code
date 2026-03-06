variable "region" {
  type        = string
  description = "Region where the GCS bucket is created."
  default     = "us-south1"
  sensitive   = false
  nullable    = false
}

variable "buckets" {
  type = list(object({
    name = string
    controls = map(object({
      entities = list(string)
    }))

  }))
  description = "A list of bucket objects including names and IAM control maps (role -> members)."
  default     = []
}

variable "project_id" {
  description = "The project ID where the resources will be created."
  type        = string
  default     = "uf-vertex-ai-suite-p"
}

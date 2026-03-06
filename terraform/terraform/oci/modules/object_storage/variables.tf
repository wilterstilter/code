variable "namespace" {
  description = "OCI Object Storage namespace"
  type        = string
}

variable "compartment_id" {
  description = "Compartment OCID"
  type        = string
}

# tflint-ignore: terraform_unused_declarations
variable "region" {
  description = "OCI region"
  type        = string
}

variable "bucket_name" {
  description = "Name of the Object Storage bucket"
  type        = string
}

variable "storage_tier" {
  description = "Object Storage tier"
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "Freeform tags to apply to the bucket"
  type        = map(string)
  default     = {}
}


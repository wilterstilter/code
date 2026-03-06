# GCP project ID
variable "project_id" {
  description = "The GCP project ID where resources will be created"
  type        = string
}

# Name of the GCS bucket
variable "bucket_name" {
  description = "The name of the GCS bucket"
  type        = string
}

# GCS bucket location (multi-region)
variable "location" {
  description = "The location of the GCS bucket (e.g., US, EU)"
  type        = string
  default     = "US"
}

# GCS bucket storage class
variable "storage_class" {
  description = "Storage class for the bucket"
  type        = string
  default     = "STANDARD"
}

# Enable versioning on the bucket
variable "enable_versioning" {
  description = "Whether to enable versioning on the bucket"
  type        = bool
}

# Force destroy bucket when deleting
variable "force_destroy" {
  description = "Allow Terraform to delete bucket even if not empty"
  type        = bool
}

variable "create_bucket" {
  description = "Create GCS bucket if true"
  type        = bool
}
variable "create_sa" {
  description = "Create Service Account if true"
  type        = bool
}

variable "k8s_namespace" {
  description = "Kubernetes namespace for the workload identity binding"
  type        = string
  default     = null
}

variable "k8s_service_account_name" {
  description = "Kubernetes service account name for workload identity"
  type        = string
  default     = null
}

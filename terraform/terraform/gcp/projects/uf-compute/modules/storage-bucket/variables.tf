variable "existing_service_account_email" {
  description = "The email address of an existing GCP service account to use. Must be a valid email, not a full resource name."
  type        = string
  default     = null

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.iam\\.gserviceaccount\\.com$", var.existing_service_account_email)) || var.existing_service_account_email == null || var.existing_service_account_email == ""
    error_message = "existing_service_account_email must be a valid GCP service account email address (e.g., [email_prepend]@[project_id].iam.gserviceaccount.com, not a full resource name. ex. parcel-apiedge-svc-gcs-sa@uf-compute-d.iam.gserviceaccount.com)"
  }

  validation {
    condition     = !(can(regex("^projects/.+/serviceAccounts/.+$", var.existing_service_account_email)))
    error_message = "existing_service_account_email must not be a full resource name (e.g., projects/PROJECT_ID/serviceAccounts/EMAIL). Provide only the email address."
  }
} # GCP project ID
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
  default     = false
}

# Force destroy bucket when deleting
variable "force_destroy" {
  description = "Allow Terraform to delete bucket even if not empty"
  type        = bool
  default     = false
}

variable "allow_destroy" {
  description = "Allow Terraform to delete bucket even if not empty"
  type        = bool
  default     = false
}

variable "create_bucket" {
  description = "Create GCS bucket if true"
  type        = bool
  default     = true
}

variable "create_sa" {
  description = "Create Service Account if true"
  type        = bool
  default     = false
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

variable "bucket_labels" {
  description = "Labels to apply to the GCS bucket"
  type        = map(string)
  default     = {}
}

variable "service_account_id" {
  description = "Service account ID (account_id field)"
  type        = string
  default     = null

  validation {
    condition     = !var.create_sa || (var.service_account_id != null && var.service_account_id != "")
    error_message = "service_account_id must be provided and non-empty when create_sa is true."
  }
}

variable "service_account_display_name" {
  description = "Service account display name"
  type        = string
  default     = null

  validation {
    condition     = !var.create_sa || (var.service_account_display_name != null && var.service_account_display_name != "")
    error_message = "service_account_display_name must be provided and non-empty when create_sa is true."
  }
}
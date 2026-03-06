# Variables for GCS Migration Module

#------------------------------------------------------------------------------
# Required Variables
#------------------------------------------------------------------------------

variable "project_id" {
  description = "The GCP project ID where the bucket will be created"
  type        = string
}

variable "bucket_suffix" {
  description = "Suffix for the bucket name. Full name will be {project_id}-{bucket_suffix}"
  type        = string
  default     = "db-migration"
}

#------------------------------------------------------------------------------
# Bucket Configuration
#------------------------------------------------------------------------------

variable "location" {
  description = "The location of the bucket (e.g., US, EU, us-south1)"
  type        = string
  default     = "US"
}

variable "storage_class" {
  description = "The storage class of the bucket (STANDARD, NEARLINE, COLDLINE, ARCHIVE)"
  type        = string
  default     = "STANDARD"

  validation {
    condition     = contains(["STANDARD", "NEARLINE", "COLDLINE", "ARCHIVE"], var.storage_class)
    error_message = "Storage class must be one of: STANDARD, NEARLINE, COLDLINE, ARCHIVE."
  }
}

variable "force_destroy" {
  description = "Allow deletion of bucket even if it contains objects (set to false for production)"
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Enable object versioning for data protection"
  type        = bool
  default     = true
}

variable "kms_key_name" {
  description = "The KMS key name for bucket encryption. If null, uses Google-managed encryption"
  type        = string
  default     = null
}

#------------------------------------------------------------------------------
# Lifecycle Management
#------------------------------------------------------------------------------

variable "lifecycle_rules" {
  description = "Lifecycle rules to automatically manage objects in the bucket"
  type = list(object({
    action = object({
      type          = string
      storage_class = optional(string)
    })
    condition = object({
      age                = optional(number)
      created_before     = optional(string)
      num_newer_versions = optional(number)
      with_state         = optional(string)
      matches_prefix     = optional(list(string))
      matches_suffix     = optional(list(string))
    })
  }))
  default = [
    {
      action = {
        type          = "SetStorageClass"
        storage_class = "NEARLINE"
      }
      condition = {
        age = 30 # Move to NEARLINE after 30 days
      }
    },
    {
      action = {
        type = "Delete"
      }
      condition = {
        age = 90 # Delete after 90 days
      }
    }
  ]
}

variable "folder_structure" {
  description = "List of folder paths to create in the bucket for organization"
  type        = list(string)
  default = [
    "raw-data",
    "processed-data",
    "backups",
    "logs"
  ]
}

#------------------------------------------------------------------------------
# IAM Configuration - Upload Service Account
#------------------------------------------------------------------------------

variable "uploader_permission_level" {
  description = "Permission level for the uploader service account: 'creator' (write-only) or 'admin' (read/write/delete)"
  type        = string
  default     = "admin"

  validation {
    condition     = contains(["creator", "admin"], var.uploader_permission_level)
    error_message = "Permission level must be either 'creator' or 'admin'."
  }
}

variable "enable_bucket_listing" {
  description = "Allow the uploader service account to list bucket contents"
  type        = bool
  default     = true
}

variable "create_service_account_key" {
  description = "Create a service account key for on-prem authentication. Key will be stored in Secret Manager."
  type        = bool
  default     = true
}

variable "secret_key_accessors" {
  description = "List of members who can access the service account key from Secret Manager (format: user:email, group:email, serviceAccount:email)"
  type        = list(string)
  default     = []
}

variable "secret_key_viewers" {
  description = "List of members who can view secret metadata but not access the key value (format: user:email, group:email)"
  type        = list(string)
  default     = []
}

#------------------------------------------------------------------------------
# IAM Configuration - Cloud SQL Reader Service Account
#------------------------------------------------------------------------------

variable "create_cloudsql_reader_sa" {
  description = "Create a separate service account for Cloud SQL to read migration data"
  type        = bool
  default     = false
}

variable "create_cloudsql_reader_key" {
  description = "Create a service account key for the Cloud SQL reader SA (only if create_cloudsql_reader_sa is true)"
  type        = bool
  default     = false
}

#------------------------------------------------------------------------------
# IAM Configuration - Additional Access
#------------------------------------------------------------------------------

variable "additional_bucket_admins" {
  description = "List of additional members who need admin access to the bucket (format: user:email, group:email, serviceAccount:email)"
  type        = list(string)
  default     = []
}

variable "additional_bucket_viewers" {
  description = "List of additional members who need viewer access to the bucket (format: user:email, group:email, serviceAccount:email)"
  type        = list(string)
  default     = []
}

variable "grant_project_viewer" {
  description = "Grant project viewer role to bucket admins so they can navigate Cloud Console UI and list buckets"
  type        = bool
  default     = true
}

#------------------------------------------------------------------------------
# Labels
#------------------------------------------------------------------------------

variable "labels" {
  description = "Labels to apply to the bucket for organization and cost tracking"
  type        = map(string)
  default     = {}
}


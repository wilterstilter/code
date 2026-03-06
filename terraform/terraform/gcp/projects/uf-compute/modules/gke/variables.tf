variable "project_id" {
  type        = string
  description = "The project name."
}

variable "network_project_id" {
  type        = string
  description = "The ID of the Google Cloud Network project for Shared VPC."
}

variable "name" {
  type        = string
  description = "The NEG name."
}
variable "region" {
  type        = string
  description = "The Region name."
}
variable "zones" {
  type        = list(string)
  description = "Zone of the Network Endpoint Security Group."
}

variable "network" {
  type        = string
  description = "The network to be used for the GKE Cluster."
}

variable "subnetwork" {
  type        = string
  description = "The subnetwork to be used for the GKE Cluster."
}

variable "master_authorized_networks" {
  description = "List of CIDR blocks that can access the Kubernetes API server"
  type        = list(string)
}

variable "group" {
  type        = string
  description = "DevOps Group Name for Admin Access"
}

variable "cluster_labels" {
  description = "Default labels for GCP resources"
  type        = map(string)
  default     = {}
}

variable "maintenance_start_time" {
  type        = string
  description = "Time window specified for daily or recurring maintenance operations in RFC3339 format"
}

variable "maintenance_end_time" {
  type        = string
  description = "Time window specified for daily or recurring maintenance operations in RFC3339 format"
}

variable "maintenance_recurrence" {
  type        = string
  description = "Frequency of the recurring maintenance window in RFC5545 format."
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "The CIDR block for the GKE master"
}
variable "project_number" {
  type        = string
  description = "The numeric identifier of the project"
}
variable "sync_repo" {
  type        = string
  description = "The Config-Sync repository URL"
}
variable "sync_branch" {
  type        = string
  description = "The Config-Sync repository branch"
}
variable "policy_dir" {
  type        = string
  description = "The Config-Sync policy directory"
}
variable "secret_type" {
  type        = string
  description = "The Config-Sync secret type"
}
variable "configmanagement_feature_exists" {
  description = "True value Flag to indicate if Config-Sync feature already exists"
  type        = bool
}
variable "mesh_feature_exists" {
  description = "True value Flag to indicate if ServiceMesh feature already exists"
  type        = bool
}
variable "configmanagement_feature_membership_exists" {
  description = "True value Flag to indicate if Config-Sync feature membership already exists"
  type        = bool
}
variable "mesh_feature_membership_exists" {
  description = "True value Flag to indicate if ServiceMesh feature membership already exists"
  type        = bool
  default     = true
}

# =============================================================================
# OpenTelemetry Variables
# =============================================================================

variable "enable_opentelemetry" {
  description = "Whether to enable OpenTelemetry Collector IAM resources"
  type        = bool
  default     = false
}

variable "opentelemetry_namespace" {
  description = "The Kubernetes namespace for OpenTelemetry Collector"
  type        = string
  default     = "opentelemetry"

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.opentelemetry_namespace))
    error_message = "Namespace name must be a valid Kubernetes namespace name."
  }
}

variable "opentelemetry_service_account_name" {
  description = "The Kubernetes service account name for OpenTelemetry Collector"
  type        = string
  default     = "opentelemetry-collector"

  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9]*[a-z0-9])?$", var.opentelemetry_service_account_name))
    error_message = "Service account name must be a valid Kubernetes name."
  }
}

variable "opentelemetry_enable_datadog" {
  description = "Whether to enable Datadog integration for OpenTelemetry (grants Secret Manager access)"
  type        = bool
  default     = false
}

variable "opentelemetry_datadog_secret_name" {
  description = "The name of the Datadog API key secret in Google Secret Manager"
  type        = string
  default     = "datadog-api-key"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.opentelemetry_datadog_secret_name))
    error_message = "Secret name must contain only alphanumeric characters, underscores, and hyphens."
  }
}
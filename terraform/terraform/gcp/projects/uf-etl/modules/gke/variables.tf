variable "project_id" {
  type        = string
  description = "The project name."
}

variable "name" {
  type        = string
  description = "The name of the GKE cluster."
}

variable "region" {
  type        = string
  description = "The GCP region where the GKE cluster will be created."
}

variable "zones" {
  type        = list(string)
  description = "The list of zones where the GKE cluster nodes will be deployed."
}

variable "network" {
  type        = string
  description = "The network to be used for the GKE Cluster. Format: projects/[PROJECT_ID]/global/networks/[NETWORK_NAME]"
}

variable "subnetwork" {
  type        = string
  description = "The subnetwork to be used for the GKE Cluster. Format: projects/[PROJECT_ID]/regions/[REGION]/subnetworks/[SUBNETWORK_NAME]"
}

variable "master_authorized_networks" {
  description = "List of CIDR blocks that can access the Kubernetes API server"
  type        = list(string)
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
  description = "The CIDR block for the GKE master in a private cluster"
}

variable "network_project_id" {
  type        = string
  description = "The project ID of the Shared VPC host project."
}

variable "project_number" {
  type        = string
  description = "The numeric project number of the GKE cluster's service project."
}

variable "workload_identity_service_account" {
  type        = string
  description = "The email of the Google Service Account to bind to the Kubernetes Service Account. Example: etl-sa-freight-data-d@uf-etl-d.iam.gserviceaccount.com"
  default     = ""
}

variable "workload_identity_ksa_name" {
  type        = string
  description = "The name of the Kubernetes Service Account to bind to the GSA"
  default     = ""
}

variable "workload_identity_ksa_namespace" {
  type        = string
  description = "The Kubernetes namespace where the KSA resides"
  default     = "default"
}

variable "project_id" {
  description = "The project ID where the Data Fusion instance will be created (Service Project)."
  type        = string
  default     = "uf-data-analysis"
}

variable "host_project_id" {
  description = "The project ID of the host project where the VPC is located."
  type        = string
  default     = "freight-network-host-p"
}

variable "region" {
  description = "The GCP region for the Data Fusion instance."
  type        = string
  default     = "us-south1"
}

variable "instance_name" {
  description = "The name of the Data Fusion instance."
  type        = string
}

variable "instance_type" {
  description = "The type of the Data Fusion instance (e.g., BASIC, ENTERPRISE, DEVELOPER)."
  type        = string
  default     = "BASIC"
}

variable "host_network_name" {
  description = "VPC self link"
  type        = string
  default     = "prod"
}

#variable "peering_range_name" {
#  description = "The name of the reserved IP range for the VPC peering."
#  type        = string
#}

variable "ip_allocation" {
  description = "value of the IP allocation for the Data Fusion instance."
  type        = string
}

variable "service_project_number" {
  description = "The project number of the service project where the Data Fusion instance will be created."
  type        = string
  default     = "14938619701"
}

#variable "dataproc_service_account" {
#  description = "The service account to be used by Data Fusion to create Dataproc clusters."
#  type        = string
#}

#variable "dataproc_sa_token_creators" {
#  description = "A list of members to grant token creator access on the Dataproc service account."
#  type        = list(string)
#  default     = []
#}

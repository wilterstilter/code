variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "network_name" {
  type        = string
  description = "VPC name"
}

variable "peering_range_name" {
  description = "The name of the global address used for peering with other networks."
  type        = string
  default     = "datafusion-peering-range"
}

variable "address_type" {
  description = "The type of address for the global address used for peering with other networks."
  type        = string
  default     = "INTERNAL"
}

variable "peering_range_prefix_length" {
  description = "The prefix length for the global address used for peering with other networks."
  type        = number
  default     = 22
}

variable "peering_range_description" {
  description = "The description for the global address used for peering with other networks."
  type        = string
  default     = ""
}

variable "tenant_project_id" {
  description = "The project ID of the tenant project where the Data Fusion instance is created."
  type        = string
}

variable "tenant_vpc_name" {
  description = "The name of the VPC in the tenant project to peer with."
  type        = string
}

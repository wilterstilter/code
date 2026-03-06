variable "project_id" {
  type        = string
  description = "The host project ID where the VPC resides"
}

variable "network_name" {
  type        = string
  description = "The name of the VPC network"
}

# Option 1: Single range (legacy support)
variable "psa_range_name" {
  type        = string
  description = "The name of the global address used for Private Service Access (use psa_ranges for multiple ranges)"
  default     = ""
}

variable "psa_range_address" {
  type        = string
  description = "The starting IP address for the PSA range (use psa_ranges for multiple ranges)"
  default     = null
}

variable "psa_range_prefix_length" {
  type        = number
  description = "The prefix length for the global address used for Private Service Access (use psa_ranges for multiple ranges)"
  default     = 22
}

variable "psa_range_description" {
  type        = string
  description = "The description for the global address used for Private Service Access (use psa_ranges for multiple ranges)"
  default     = "IP range reserved for Private Service Access"
}

# Option 2: Multiple ranges (preferred)
variable "psa_ranges" {
  type = map(object({
    address       = string
    prefix_length = number
    description   = optional(string, "IP range reserved for Private Service Access")
  }))
  description = "Map of PSA ranges to create. Key is the range name, value contains address, prefix_length, and optional description. If provided, psa_range_name is ignored."
  default     = {}
}

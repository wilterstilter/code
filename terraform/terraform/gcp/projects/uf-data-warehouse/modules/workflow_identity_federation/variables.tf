variable "pool_id" {
  type        = string
  description = "Name of WIF Pool Id"
  default     = ""
  nullable    = false
  sensitive   = false
}

variable "pool_name" {
  type        = string
  description = "The display name of the wif pool"
  default     = ""
  sensitive   = false
  nullable    = false
}

variable "pool_description" {
  type        = string
  description = "The description of the wif pool and what it is used for"
  default     = ""
  sensitive   = false
  nullable    = false
}
variable "pool_disabled" {
  type        = bool
  description = "A boolean depicting whether the wif pool is disabled or not"
  default     = false
  sensitive   = false
  nullable    = false
}

variable "pool_provider_id" {
  type        = string
  description = "The unique identifier for the Workload Identity Pool Provider within the specified pool."
  default     = null
}

variable "pool_provider_display_name" {
  type        = string
  description = "A human-readable name for the Workload Identity Pool Provider."
  default     = ""
  sensitive   = false
  nullable    = false
}

variable "pool_provider_description" {
  type        = string
  description = "A detailed description of the Workload Identity Pool Provider."
  default     = ""
  sensitive   = false
  nullable    = false
}

variable "pool_provider_disabled" {
  type        = bool
  description = "Shows whether the wif pool provider is disabled"
  default     = false
  sensitive   = false
  nullable    = false
}

variable "oidc_uri" {
  type        = string
  description = "Github uri where we can get the token for WIF"
  sensitive   = false
  nullable    = false
}

variable "attribute_condition" {
  type        = string
  description = "any attribute conditions on WIF"
  default     = ""
  sensitive   = false
  nullable    = false
}

variable "attribute_mapping" {
  type        = map(string)
  description = "The list of mapped attributes for wif"
  sensitive   = false
  nullable    = false
}

variable "service_account_id" {
  type        = string
  description = "The service account for wif's Id"
  default     = ""
  nullable    = false
  sensitive   = false
}

variable "service_account_display_name" {
  type        = string
  description = "The display name of the service account"
  default     = ""
  sensitive   = false
  nullable    = false
}

variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "project_number" {
  type        = string
  description = " Project Number"
  default     = ""
  nullable    = false
  sensitive   = false
}
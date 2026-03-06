variable "project_id" {
  type        = string
  description = "The project ID to deploy to."
}

variable "name" {
  type        = string
  description = "The name of the network endpoint group."
}

variable "network_endpoint_type" {
  type        = string
  description = "The type of network endpoint group. Must be either INTERNET_IP_PORT or INTERNET_FQDN_PORT."
  default     = "INTERNET_IP_PORT"

  validation {
    condition     = contains(["INTERNET_IP_PORT", "INTERNET_FQDN_PORT"], var.network_endpoint_type)
    error_message = "The network_endpoint_type must be either INTERNET_IP_PORT or INTERNET_FQDN_PORT."
  }
}

variable "port" {
  type        = number
  description = "The port for the network endpoint."
  default     = 443
}

variable "ip_addresses" {
  type        = list(string)
  description = "A list of IP addresses to add as endpoints. Required when network_endpoint_type is INTERNET_IP_PORT."
  default     = []
}

variable "fqdns" {
  type        = list(string)
  description = "A list of FQDNs to add as endpoints. Required when network_endpoint_type is INTERNET_FQDN_PORT."
  default     = []
}

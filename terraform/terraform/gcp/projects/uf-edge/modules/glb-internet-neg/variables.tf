variable "domains" {
  type        = list(string)
  description = "A list of domain names for the load balancer and SSL certificate. The first domain in the list will be used to generate resource names."
}

variable "default_service" {
  type        = list(string)
  description = "A list of self-links to the Internet Network Endpoint Groups."
}

variable "security_policy_self_link" {
  type        = string
  description = "The self-link of the Cloud Armor security policy to apply to the backend service."
}

variable "min_tls_version" {
  description = "The minimum TLS version for the SSL policy. Allowed values: TLS_1_2, TLS_1_3"
  type        = string
  default     = "TLS_1_2"

  validation {
    condition     = contains(["TLS_1_2", "TLS_1_3"], var.min_tls_version)
    error_message = "Invalid TLS version. Only TLS_1_2 and TLS_1_3 are allowed."
  }
}

variable "backend_timeout_sec" {
  description = "Timeout (in seconds) for the backend service."
  type        = number
  default     = 120
}

variable "redirect_map" {
  description = "Optional map of source host to target host for 301 redirects. Example: { 'uatlaser.transplace.com' = 'uatlaser.tplaser.com.mx' }"
  type        = map(string)
  default     = {}
}


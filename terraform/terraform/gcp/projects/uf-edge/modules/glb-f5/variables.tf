
variable "domain" {
  type        = string
  description = "Primary domain for the load balancer and SSL certificate."
}

variable "additional_hostnames" {
  type        = list(string)
  default     = []
  description = "Additional hostnames that should terminate on this GLB and route to the same backend."
}


variable "health_check_port" {
  type        = string
  description = "Port used for health checks."
}

variable "default_service" {
  type        = list(string)
  description = "Network endpoint group self link list"
}

variable "security_policy_self_link" {
  type        = string
  description = "Link for the security policy"
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
  description = "Timeout (in seconds) for backend service."
  type        = number
  default     = 120
}

variable "max_rate_per_endpoint" {
  description = "Maximum requests per second per backend endpoint."
  type        = number
  default     = 80
}

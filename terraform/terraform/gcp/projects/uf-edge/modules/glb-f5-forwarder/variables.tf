
variable "domain" {
  type        = string
  description = "The domain that will be added to the load balancer and SSL certificate."
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

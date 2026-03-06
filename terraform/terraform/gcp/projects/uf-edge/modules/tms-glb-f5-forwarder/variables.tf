
variable "domain" {
  type        = string
  description = "The domain that will be added to the load balancer and SSL certificate."
}

variable "health_check_port" {
  type        = string
  description = "Port used for health checks."
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

variable "default_service" {
  description = "List of backend self-links for default (all traffic) routing"
  type        = list(string)
  default     = []
}

variable "path_backends" {
  description = "Map of paths to backend config objects (neg_links, health_path, health_port)"
  type = map(object({
    neg_links                 = list(string)
    health_path               = string
    health_port               = number
    health_protocol           = optional(string, "HTTPS") # HTTP or HTTPS
    timeout_sec               = optional(number, 30)
    max_rate_per_endpoint     = optional(number, 80)
    backend_log_enabled       = optional(bool, true)
    backend_log_sample_rate   = optional(number, 1.0)
    health_check_timeout_sec  = optional(number, 30) # health check timeout
    health_check_interval_sec = optional(number, 30)
    healthy_threshold         = optional(number, 2)
    unhealthy_threshold       = optional(number, 2)
  }))
  default = {}
}

variable "default_backend_timeout_sec" {
  description = "Timeout (in seconds) for the default backend service. Default is 30."
  type        = number
  default     = 30
}

variable "health_check_interval_sec" {
  description = "Interval (seconds) between health checks."
  type        = number
  default     = 30
}

variable "health_check_timeout_sec" {
  description = "Timeout (seconds) for health check responses."
  type        = number
  default     = 30
}

variable "health_check_healthy_threshold" {
  description = "Number of consecutive successes for healthy."
  type        = number
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "Number of consecutive failures for unhealthy."
  type        = number
  default     = 2
}

variable "default_max_rate_per_endpoint" {
  description = "Max requests/sec per endpoint for default backend."
  type        = number
  default     = 80
}

variable "default_backend_log_enabled" {
  description = "Enable logging for default backend."
  type        = bool
  default     = true
}

variable "default_backend_log_sample_rate" {
  description = "Log sample rate for default backend."
  type        = number
  default     = 1.0
}

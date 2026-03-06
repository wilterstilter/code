variable "project_id" {
  description = "The GCP project ID where the backend services will be created"
  type        = string
}

variable "load_balancing_scheme" {
  description = "The load balancing scheme. Use EXTERNAL_MANAGED for Global LB with advanced traffic management"
  type        = string
  default     = "EXTERNAL_MANAGED"
}

#------------------------------------------------------------------------------
# Health Check Configuration
#------------------------------------------------------------------------------
variable "health_check_configs" {
  description = "Configuration for global health checks"
  type = map(object({
    protocol            = optional(string, "HTTP") # HTTP, HTTPS, TCP, GRPC
    port                = number
    request_path        = optional(string, "/")
    check_interval_sec  = optional(number, 10)
    timeout_sec         = optional(number, 5)
    healthy_threshold   = optional(number, 2)
    unhealthy_threshold = optional(number, 2)
  }))
  default = {}
}

#------------------------------------------------------------------------------
# Backend Service Configuration
#------------------------------------------------------------------------------
variable "backend_service_configs" {
  description = "Configuration for global backend services with multi-region NEG support"
  type = map(object({
    # Basic settings
    protocol          = optional(string, "HTTP")
    port_name         = optional(string, "http")
    timeout_sec       = optional(number, 30)
    health_check_name = string

    # NEG list - simple list of NEG paths (like neg-backends module)
    neg_names = list(string)

    # Balancing settings (applied to all NEGs)
    balancing_mode        = optional(string, "RATE")
    max_rate_per_endpoint = optional(number, 100)
    capacity_scaler       = optional(number, 1.0)

    # Session affinity
    session_affinity = optional(string, "NONE")

    # Connection draining
    connection_draining_timeout_sec = optional(number, 300)

    # Security
    security_policy = optional(string, null)

    # Logging
    logging_enabled     = optional(bool, true)
    logging_sample_rate = optional(number, 1.0)
  }))
  default = {}
}

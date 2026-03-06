variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The region for the backend service"
  type        = string
}

variable "protocol" {
  description = "The protocol for the backend service (e.g., HTTP, HTTPS)"
  type        = string
  default     = "HTTP"
}

variable "timeout_sec" {
  description = "Timeout for the backend service"
  type        = number
  default     = 60
}

variable "load_balancing_scheme" {
  description = "The load balancing scheme (e.g., INTERNAL, EXTERNAL)"
  type        = string
  default     = "INTERNAL"
}

variable "health_check_configs" {
  description = "Configuration for health checks"
  type = map(object({
    check_interval_sec  = number
    timeout_sec         = number
    healthy_threshold   = number
    unhealthy_threshold = number
    request_path        = optional(string) # Required for HTTP, optional for TCP
    port                = number
    is_global           = optional(bool, false)
    type                = optional(string, "http") # "http" or "tcp", defaults to "http" for backward compatibility
  }))
}

variable "backend_service_configs" {
  description = "Configuration for backend services and NEGs"
  type = map(object({
    neg_names                       = list(string)     # List of NEG names or instance group URIs
    health_check_name               = string           # Name of the health check to use
    balancing_mode                  = string           # RATE, UTILIZATION, or CONNECTION
    max_rate_per_endpoint           = optional(number) # Optional: not used with UTILIZATION mode
    capacity_scaler                 = number
    timeout_sec                     = optional(number, 60)  # Optional timeout with a default of 60 seconds
    logging                         = optional(bool, false) # Enable or disable logging (default: false)
    sample_rate                     = optional(number, 1.0) # Logging sample rate (default: 1.0)
    session_affinity                = optional(string)      # Optional: CLIENT_IP, GENERATED_COOKIE, etc.
    connection_draining_timeout_sec = optional(number)      # Optional: for TCP/graceful shutdown
    protocol                        = optional(string)      # Optional: HTTP, HTTPS, TCP, UDP. Defaults to module-level protocol
  }))
}


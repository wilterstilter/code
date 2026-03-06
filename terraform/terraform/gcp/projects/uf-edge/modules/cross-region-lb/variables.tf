variable "project_id" {
  description = "The GCP project ID where the load balancer will be created"
  type        = string
}

variable "domain" {
  description = "The base domain name for the load balancer"
  type        = string
}

variable "load_balancing_scheme" {
  description = "The load balancing scheme. EXTERNAL_MANAGED for internet-facing, INTERNAL_MANAGED for VPC-internal"
  type        = string
  default     = "EXTERNAL_MANAGED"
  validation {
    condition     = contains(["EXTERNAL_MANAGED", "INTERNAL_MANAGED"], var.load_balancing_scheme)
    error_message = "load_balancing_scheme must be either EXTERNAL_MANAGED or INTERNAL_MANAGED"
  }
}

variable "regions" {
  description = "List of regions for internal cross-region load balancing (required for INTERNAL_MANAGED)"
  type        = list(string)
  default     = []
}

variable "network" {
  description = "The VPC network for internal load balancing (required if load_balancing_scheme is INTERNAL_MANAGED)"
  type        = string
  default     = null
}

variable "lb_subnets" {
  description = "Map of region to load balancer subnet for internal IPs (required for INTERNAL_MANAGED). Format: {region = subnet_self_link}"
  type        = map(string)
  default     = {}

  validation {
    condition = (
      var.load_balancing_scheme != "INTERNAL_MANAGED" ||
      length(var.lb_subnets) > 0
    )
    error_message = "lb_subnets must be provided when load_balancing_scheme is INTERNAL_MANAGED."
  }
}

#------------------------------------------------------------------------------
# Frontend Configuration
#------------------------------------------------------------------------------
variable "frontends" {
  description = "Configuration for multiple frontends (subdomains)"
  type = map(object({
    port                 = number
    default_backend      = string
    enable_http_redirect = optional(bool, true)
    enable_cors          = optional(bool, false)
    ip_addresses         = optional(map(string), {}) # Map of region to IP address for INTERNAL_MANAGED
    url_map = list(object({
      path                = string
      backend             = string
      priority            = optional(number)
      path_prefix_rewrite = optional(bool, false)
      host_rewrite        = optional(bool, false)
    }))
    forbidden_uris = optional(list(object({
      path_pattern = string
      priority     = number
      status_code  = number
      message      = string
    })), [])
  }))
}

#------------------------------------------------------------------------------
# Backend Configuration
#------------------------------------------------------------------------------
variable "backends" {
  description = "Configuration for global backend services with cross-region NEG support"
  type = map(object({
    # Option 1: Provide NEG links to create new backend service
    neg_links = optional(list(string), [])

    # Option 2: Reference existing backend service (e.g., from uf-compute)
    backend_service_self_link = optional(string, null)

    # Health check configuration (only needed if creating new backend service)
    health_check = optional(string, null)

    # Backend service settings (only used if creating new backend service)
    protocol    = optional(string, "HTTP")
    port_name   = optional(string, "http")
    timeout_sec = optional(number, 30)

    # Load balancing settings
    balancing_mode        = optional(string, "RATE")
    max_rate_per_endpoint = optional(number, 100)
    capacity_scaler       = optional(number, 1.0)

    # Session affinity
    session_affinity        = optional(string, "GENERATED_COOKIE")
    affinity_cookie_ttl_sec = optional(number, 86400)

    # Connection draining
    connection_draining_timeout_sec = optional(number, 300)

    # Security
    security_policy = optional(string, null)

    # Logging
    logging_enabled     = optional(bool, true)
    logging_sample_rate = optional(number, 1.0)
  }))
}

#------------------------------------------------------------------------------
# Health Check Configuration
#------------------------------------------------------------------------------
variable "health_checks" {
  description = "Configuration for global health checks"
  type = map(object({
    protocol            = optional(string, "HTTP") # HTTP, HTTPS, TCP
    path                = string
    port                = number
    check_interval_sec  = optional(number, 10)
    timeout_sec         = optional(number, 5)
    healthy_threshold   = optional(number, 2)
    unhealthy_threshold = optional(number, 2)
  }))
}

#------------------------------------------------------------------------------
# SSL Certificate Configuration
#------------------------------------------------------------------------------
variable "certificate_id" {
  description = "The ID of the Certificate Manager certificate to use for HTTPS frontends (optional)"
  type        = string
  default     = null
}

variable "ssl_certificate_ids" {
  description = "List of SSL certificate IDs to attach to the HTTPS proxy (optional if using certificate_id)"
  type        = list(string)
  default     = null
}

variable "create_ssl_certificate" {
  description = "Whether to create a managed SSL certificate"
  type        = bool
  default     = false
}

variable "ssl_certificate_domains" {
  description = "List of domains for the managed SSL certificate"
  type        = list(string)
  default     = null
}

variable "ssl_policy" {
  description = "SSL policy to use for HTTPS"
  type        = string
  default     = null
}

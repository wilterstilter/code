variable "domain" {
  description = "The domain name for the load balancer"
  type        = string
}

variable "region" {
  description = "The region where the load balancer will be created"
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork where the load balancer will be created"
  type        = string
}

variable "frontends" {
  description = "Configuration for multiple frontends"
  type = map(object({
    ip_address             = string
    port                   = number
    enable_host_rewrite    = optional(bool, false) # Optional, default to false
    enable_https_redirects = optional(bool, false)
    default_backend        = string
    url_map = list(object({
      path                = string
      backend             = string
      priority            = optional(number)      # Optional priority field
      path_prefix_rewrite = optional(bool, false) # Optional, default to false
      forbidden_uris      = optional(list(string))
      host_rewrite        = optional(bool, false) # Optional, default to false
    }))
    forbidden_uris = optional(list(object({
      path_pattern = string
      priority     = number
      status_code  = number
      message      = string
    })), []) # Default to an empty list
  }))
}

variable "backends" {
  description = "Configuration for backends"
  type = map(object({
    neg_links                  = optional(list(string), [])
    cross_project_backend      = optional(string, null)
    health_check               = optional(string, null)
    enable_path_prefix_rewrite = optional(bool, false) # Add this variable
    enable_header_action       = optional(bool, false)
    timeout_sec                = optional(number, 30)   # Timeout in seconds for the backend (default: 30 seconds)
    security_policy            = optional(string, null) # Security policy for the backend (default: null)
  }))
}

variable "health_checks" {
  description = "Configuration for health checks"
  type = map(object({
    path = string
    port = number
  }))
}

variable "project_id" {
  description = "The project ID where the load balancer will be created"
  type        = string
}

variable "certificate_id" {
  description = "The ID of the SSL certificate to use for HTTPS frontends"
  type        = string
}

variable "http_redirect_lb_name" {
  description = "The name for the HTTP to HTTPS redirect load balancer"
  type        = string
  default     = "http-to-https-redirect-lb" # Default name for the HTTP redirect load balancer 
}

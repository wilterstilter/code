
variable "domain" {
  type        = string
  description = "The domain that will be added to the load balancer and SSL certificate."
}

variable "default_service" {
  type        = list(string)
  description = "Network endpoint group self link list"
}

variable "url_map" {
  description = "Map of URL paths to NEG links, health check ports, and health check paths."
  type = map(object({
    neg_links             = list(string)
    health_check_port     = string
    health_check_path     = string
    forbidden_uris        = optional(list(string), [])
    cross_project_backend = optional(string, "")
  }))
}

variable "region" {
  type        = string
  description = "The region where the load balancer will be created."
}

variable "network" {
  type        = string
  description = "The network where the load balancer will be created."
}

variable "proxy_subnetwork" {
  type        = string
  description = "The proxy subnetwork where the load balancer will be created."
}

variable "subnetwork" {
  type        = string
  description = "The subnetwork where the load balancer will be created."
}

variable "project_id" {
  type        = string
  description = "The project ID where the load balancer will be created."

}

variable "address" {
  type        = string
  description = "The address for the load balancer frontend ip."
}

variable "certificate_id" {
  description = "The id of the SSL certificate to use for the ILB."
  type        = string
  default     = null
}

variable "default_hc_path" {
  description = "The default health check path for the default service."
  type        = string
}

variable "default_hc_port" {
  description = "The default health check port for the default service."
  type        = string
}

variable "port" {
  description = "The port for the load balancer (e.g., 80 for HTTP, 443 for HTTPS)"
  type        = number
  default     = 443
}

variable "enable_host_rewrite" {
  description = "Whether to enable the host rewrite rule"
  type        = bool
  default     = false
}

variable "enable_https_redirects" {
  description = "Whether to enable HTTPS redirects"
  type        = bool
  default     = false
}

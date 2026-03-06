variable "network" {
  type        = string
  description = "The network to be used for the PSC endpoint and for the load balancer."
}

variable "subnetwork" {
  type        = string
  description = "The subnet used for the PSC endpoint."
}

variable "private_dns" {
  type        = string
  description = "The Private dns used by endpoints"
}

variable "endpoints" {
  type = map(object({
    service_attachment_uri  = string
    dns_subdomain           = string
    allow_psc_global_access = bool
  }))
  description = "Private Service Connect endpoint info"
}

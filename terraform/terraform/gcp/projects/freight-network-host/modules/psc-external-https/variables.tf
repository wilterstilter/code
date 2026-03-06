variable "service_attachment_uri" {
  type        = string
  description = "Private Service Connect Service attachment URI"
}

variable "network" {
  type        = string
  description = "The network to be used for the PSC endpoint and for the load balancer."
}

variable "subnetwork" {
  type        = string
  description = "The subnet used for the PSC endpoint."
}

variable "domain" {
  type        = string
  description = "The domain that will be added to the load balancer and SSL certificate."
}

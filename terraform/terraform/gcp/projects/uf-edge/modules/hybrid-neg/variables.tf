
variable "name" {
  type        = string
  description = "The NEG name."
}

variable "onpremise_ip_addresses" {
  type        = list(string)
  description = "On Premise IP to be forwarded to."
}

variable "onpremise_port" {
  type        = string
  description = "Port number of the Onpremise Endpoint."
}

variable "zones" {
  type        = list(string)
  description = "Zone of the Network Endpoint Security Group."
}

variable "network" {
  type        = string
  description = "The network to be used for the load balancer."
}

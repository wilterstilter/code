variable "network" {
  type        = string
  description = "The network that will have access to this internal DNS zone."
}

variable "domain" {
  type        = string
  description = "Domain name"
}

variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "targets" {
  type        = list(string)
  description = "Target DNS servers"
}

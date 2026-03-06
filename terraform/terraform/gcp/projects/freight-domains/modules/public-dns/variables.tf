variable "domain" {
  type        = string
  description = "The domain name"
}

variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "recordsets" {
  type = list(object({
    name    = string
    type    = string
    ttl     = number
    records = optional(list(string), null)

    routing_policy = optional(object({
      wrr = optional(list(object({
        weight  = number
        records = list(string)
      })), [])
      geo = optional(list(object({
        location = string
        records  = list(string)
      })), [])
    }))
  }))
  description = "A list of DNS record objects in the standard terraform dns structure"
  default     = []
}

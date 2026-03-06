variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "network_name" {
  type        = string
  description = "VPC name"
}

variable "interconnects_project_id" {
  type        = string
  description = "The project ID that hosts dedicated interconnects"
  default     = null
}

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges that will be used in some of the subnets"
  default     = {}
}

variable "routes" {
  type        = list(map(string))
  description = "List of routes being created in this VPC"
  default     = []
}

variable "ingress_rules" {
  description = "List of ingress rules."
  default     = []
  type = list(object({
    name                    = string
    description             = optional(string, null)
    disabled                = optional(bool, null)
    priority                = optional(number, null)
    destination_ranges      = optional(list(string), [])
    source_ranges           = optional(list(string), [])
    source_tags             = optional(list(string))
    source_service_accounts = optional(list(string))
    target_tags             = optional(list(string))
    target_service_accounts = optional(list(string))

    allow = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
    deny = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
  }))
}

variable "egress_rules" {
  description = "List of egress rules."
  default     = []
  type = list(object({
    name                    = string
    description             = optional(string, null)
    disabled                = optional(bool, null)
    priority                = optional(number, null)
    destination_ranges      = optional(list(string), [])
    source_ranges           = optional(list(string), [])
    source_tags             = optional(list(string))
    source_service_accounts = optional(list(string))
    target_tags             = optional(list(string))
    target_service_accounts = optional(list(string))

    allow = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
    deny = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
  }))
}


variable "global_advertised_ranges" {
  description = "List of Global Load Balancer and Global Private Service Connect IPs or other IPs that are not advertised by GCP implcitly"
  type = list(object({
    range       = string
    description = string
  }))
  default = []
}

variable "regions" {
  type = map(object({
    asn           = number
    psc_subnet_ip = optional(string)
    subnets = optional(list(object({
      name                      = string
      ip                        = string
      private_access            = optional(string)
      private_ipv6_access       = optional(string)
      flow_logs                 = optional(string)
      flow_logs_interval        = optional(string)
      flow_logs_sampling        = optional(string)
      flow_logs_metadata        = optional(string)
      flow_logs_filter          = optional(string)
      flow_logs_metadata_fields = optional(list(string))
      description               = optional(string)
      purpose                   = optional(string)
      role                      = optional(string)
      stack_type                = optional(string)
      ipv6_access_type          = optional(string)
    })), [])
    routers = optional(map(object({
      attachments = optional(map(object({
        interconnect_id   = string
        type              = optional(string, "DEDICATED")
        bandwidth         = optional(string)
        vlan              = optional(number)
        candidate_subnets = optional(list(string))
        peer = object({
          name                      = string
          peer_asn                  = string
          advertised_route_priority = optional(number)
          bfd = optional(object({
            session_initialization_mode = string
            min_transmit_interval       = optional(number)
            min_receive_interval        = optional(number)
            multiplier                  = optional(number)
          }))
        })
      })), {})
    })), {})
  }))
  description = "The list of subnets being created"
  default     = {}
}

variable "private_service_connect_google_ip" {
  description = "The internal IP to be used for the private service connect."
  type        = string
  default     = ""
}

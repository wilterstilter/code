# Hub VCN configuration (compartment, CIDR, subnets, gateways, NSGs, etc.).
# tflint-ignore: terraform_unused_declarations
variable "region" {
  description = "OCI region where the hub and spoke VCNs should be created"
  type        = string
}

variable "hub" {
  description = <<DESC
Hub VCN configuration.
Fields:
  - compartment_id (string)
  - display_name (string)
  - cidr_block (string)
  - dns_label (optional string)
  - freeform_tags / defined_tags (optional map)
  - create_internet_gateway / create_nat_gateway / create_service_gateway (optional bools)
  - service_gateway_service_id (string when service gateway enabled)
  - route_rules (optional list of route rules)
  - nsgs (optional map defining hub NSGs and rules)
  - subnets (optional list of objects: name, cidr_block, is_public?, availability_domain?, security_list_ids?, route_table_id?, dns_label?, compartment_id?, freeform_tags?, defined_tags?, nsgs?)
DESC
  type = object({
    compartment_id             = string
    display_name               = string
    cidr_block                 = string
    dns_label                  = optional(string)
    freeform_tags              = optional(map(string), {})
    defined_tags               = optional(map(string), {})
    create_internet_gateway    = optional(bool, false)
    create_nat_gateway         = optional(bool, false)
    create_service_gateway     = optional(bool, false)
    service_gateway_service_id = optional(string)
    route_rules                = optional(list(map(any)), [])
    nsgs = optional(map(object({
      freeform_tags = optional(map(string))
      defined_tags  = optional(map(string))
      ingress_rules = optional(list(object({
        description = optional(string)
        protocol    = string
        source      = string
        source_type = optional(string, "CIDR_BLOCK")
        stateless   = optional(bool, false)
        tcp_ports   = optional(list(number))
        udp_ports   = optional(list(number))
        tcp_options = optional(object({
          destination_port_range = optional(object({
            min = number
            max = optional(number)
          }))
          source_port_range = optional(object({
            min = number
            max = optional(number)
          }))
        }))
        udp_options = optional(object({
          destination_port_range = optional(object({
            min = number
            max = optional(number)
          }))
          source_port_range = optional(object({
            min = number
            max = optional(number)
          }))
        }))
        icmp_options = optional(object({
          type = optional(number)
          code = optional(number)
        }))
      })), [])
      egress_rules = optional(list(object({
        description      = optional(string)
        protocol         = string
        destination      = optional(string)
        destination_type = optional(string, "CIDR_BLOCK")
        stateless        = optional(bool, false)
        tcp_ports        = optional(list(number))
        udp_ports        = optional(list(number))
        destinations     = optional(list(string), [])
        tcp_options = optional(object({
          destination_port_range = optional(object({
            min = number
            max = optional(number)
          }))
          source_port_range = optional(object({
            min = number
            max = optional(number)
          }))
        }))
        udp_options = optional(object({
          destination_port_range = optional(object({
            min = number
            max = optional(number)
          }))
          source_port_range = optional(object({
            min = number
            max = optional(number)
          }))
        }))
        icmp_options = optional(object({
          type = optional(number)
          code = optional(number)
        }))
      })), [])
    })), {})
    subnets = optional(list(object({
      name                = string
      cidr_block          = string
      is_public           = optional(bool, false)
      availability_domain = optional(string)
      security_list_ids   = optional(list(string))
      route_table_id      = optional(string)
      dns_label           = optional(string)
      compartment_id      = optional(string)
      freeform_tags       = optional(map(string))
      defined_tags        = optional(map(string))
      nsgs                = optional(list(string), [])
    })), [])
  })
}

# Map of spoke VCNs (one per key) including VCN CIDR, subnets, and NSGs.
variable "spokes" {
  description = <<DESC
Map of spoke VCN configurations keyed by logical name.
Each value supports:
  - compartment_id (string)
  - display_name (string)
  - cidr_block (string)
  - dns_label (optional string)
  - freeform_tags / defined_tags (optional map)
  - nsgs (optional map defining NSGs and rules for this spoke)
  - subnets (optional list with same fields as hub subnets)
DESC
  type = map(object({
    compartment_id = string
    display_name   = string
    cidr_block     = string
    dns_label      = optional(string)
    freeform_tags  = optional(map(string))
    defined_tags   = optional(map(string))
    nsgs = optional(map(object({
      freeform_tags = optional(map(string))
      defined_tags  = optional(map(string))
      ingress_rules = optional(list(object({
        description = optional(string)
        protocol    = string
        source      = string
        source_type = optional(string, "CIDR_BLOCK")
        stateless   = optional(bool, false)
        tcp_ports   = optional(list(number))
        udp_ports   = optional(list(number))
        tcp_options = optional(object({
          destination_port_range = optional(object({
            min = number
            max = optional(number)
          }))
          source_port_range = optional(object({
            min = number
            max = optional(number)
          }))
        }))
        udp_options = optional(object({
          destination_port_range = optional(object({
            min = number
            max = optional(number)
          }))
          source_port_range = optional(object({
            min = number
            max = optional(number)
          }))
        }))
        icmp_options = optional(object({
          type = optional(number)
          code = optional(number)
        }))
      })), [])
      egress_rules = optional(list(object({
        description      = optional(string)
        protocol         = string
        destination      = optional(string)
        destination_type = optional(string, "CIDR_BLOCK")
        stateless        = optional(bool, false)
        tcp_ports        = optional(list(number))
        udp_ports        = optional(list(number))
        destinations     = optional(list(string), [])
        tcp_options = optional(object({
          destination_port_range = optional(object({
            min = number
            max = optional(number)
          }))
          source_port_range = optional(object({
            min = number
            max = optional(number)
          }))
        }))
        udp_options = optional(object({
          destination_port_range = optional(object({
            min = number
            max = optional(number)
          }))
          source_port_range = optional(object({
            min = number
            max = optional(number)
          }))
        }))
        icmp_options = optional(object({
          type = optional(number)
          code = optional(number)
        }))
      })), [])
    })), {})
    subnets = optional(list(object({
      name                = string
      cidr_block          = string
      is_public           = optional(bool, false)
      availability_domain = optional(string)
      security_list_ids   = optional(list(string))
      route_table_id      = optional(string)
      dns_label           = optional(string)
      compartment_id      = optional(string)
      freeform_tags       = optional(map(string))
      defined_tags        = optional(map(string))
      nsgs                = optional(list(string), [])
    })), [])
  }))
  default = {}
}


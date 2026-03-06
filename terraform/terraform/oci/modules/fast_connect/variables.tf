# tflint-ignore: terraform_unused_declarations
variable "region" {
  description = "OCI region for Fastconnect"
  type        = string
}

variable "compartment_id" {
  description = "OCID of the compartment where FastConnect virtual circuits are managed."
  type        = string
}

variable "drg_id" {
  description = "OCID of the Dynamic Routing Gateway that the virtual circuits will attach to."
  type        = string
}

variable "default_customer_bgp_asn" {
  description = "Optional default customer ASN used for BGP peering when a connection does not override it."
  type        = number
  default     = null
}

variable "default_freeform_tags" {
  description = "Freeform tags applied to all resources unless overridden per connection."
  type        = map(string)
  default     = {}
}

variable "default_defined_tags" {
  description = "Defined tags applied to all resources unless overridden per connection."
  type        = map(string)
  default     = {}
}

variable "connections" {
  description = <<DESC
Map of FastConnect virtual circuit configurations keyed by logical name. Each connection supports:
  - display_name (optional string)
  - compartment_id (optional string, defaults to module compartment)
  - bandwidth_shape_name (string)
  - customer_asn (optional number, defaults to module-level ASN)
  - provider_service_id (string) – required for provider-managed circuits
  - is_bfd_enabled (optional bool)
  - ip_mtu (optional string, e.g. MTU_1500 or MTU_9000)
  - routing_policy (optional list of strings)
  - freeform_tags / defined_tags (optional maps)
DESC
  type = map(object({
    display_name   = optional(string)
    compartment_id = optional(string)

    bandwidth_shape_name = string
    customer_asn         = optional(number)

    provider_service_id       = string
    provider_service_key_name = optional(string)

    is_bfd_enabled = optional(bool)
    ip_mtu         = optional(string)
    routing_policy = optional(list(string), [])

    freeform_tags = optional(map(string))
    defined_tags  = optional(map(string))
    cross_connect_mappings = optional(list(object({
      cross_connect_or_cross_connect_group_id = optional(string)
      customer_bgp_peering_ip                 = optional(string)
      oracle_bgp_peering_ip                   = optional(string)
      customer_bgp_peering_ipv6               = optional(string)
      oracle_bgp_peering_ipv6                 = optional(string)
      vlan                                    = optional(number)
      bgp_md5auth_key                         = optional(string)
    })))
  }))

  validation {
    condition     = length(var.connections) > 0
    error_message = "At least one FastConnect connection must be defined."
  }
  validation {
    condition     = alltrue([for conn in values(var.connections) : try(conn.provider_service_id, null) != null])
    error_message = "Each connection must specify provider_service_id."
  }
  validation {
    condition = alltrue([
      for conn in values(var.connections) :
      conn.cross_connect_mappings == null || length(conn.cross_connect_mappings) == 1
    ])
    error_message = "Layer 2 FastConnect circuits require exactly one cross_connect_mappings entry."
  }
}



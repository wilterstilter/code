variable "access_policy_name" {
  type        = string
  description = "Name for the Scoped Access Policy"
}

variable "project_id" {
  type        = string
  description = "Numerical ID of the GCP project"
}

variable "access_level" {
  type = list(object({
    access_level_name        = string
    access_level_description = string
    combining_function       = optional(string, "AND")
    ip_subnetworks           = optional(list(string), [])
    vpc_network_sources = optional(map(object({
      network_id        = string # This attribute is required whenever 'vpc_network_sources' is given in inputs. Put as optional to avoid lint issues 
      ip_address_ranges = optional(list(string), [])
    })), {})
    required_access_levels = optional(list(string), [])
    members                = optional(list(string), [])
    regions                = optional(list(string), [])
  }))
}

variable "perimeter" {
  type = object({
    perimeter_name          = string
    perimeter_description   = string
    resources               = optional(list(string), [])
    restricted_services     = optional(list(string), [])
    access_levels           = optional(list(string), [])
    vpc_accessible_services = optional(list(string), ["*"])
    ingress_policies = optional(list(object({
      from = any
      to   = any
      })),
      [{
        "from" = {
          "sources" = {
            access_levels = ["*"] # Allow Access from everywhere
          },
          "identityType" = "ANY_IDENTITY"
        }
        "to" = {
          "resources" = ["*"]
          "operations" = {
            "bigquery.googleapis.com" = {
              "methods" = ["*"] # Allow All methods
            }
          }
        }
    }])
    egress_policies = optional(list(object({
      from = any
      to   = any
    })), [])
    resources_dry_run               = optional(list(string), [])
    restricted_services_dry_run     = optional(list(string), [])
    access_levels_dry_run           = optional(list(string), [])
    vpc_accessible_services_dry_run = optional(list(string), ["*"])
    ingress_policies_dry_run = optional(list(object({
      from = any
      to   = any
    })), [])
    egress_policies_dry_run = optional(list(object({
      from = any
      to   = any
    })), [])
  })
  default = {
    title                 = "default"
    perimeter_name        = "default"
    perimeter_description = "default"
    resources             = []
    restricted_services   = []
    access_levels         = []
  }
}

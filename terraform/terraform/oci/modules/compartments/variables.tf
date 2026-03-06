variable "parent_compartment_id" {
  description = "OCID of the parent compartment (or tenancy root) under which new compartments will be created."
  type        = string
}

variable "default_freeform_tags" {
  description = "Freeform tags applied to all compartments unless overridden."
  type        = map(string)
  default     = {}
}

variable "environments" {
  description = <<DESC
Hierarchy definition for environment compartments and optional children.
Map key becomes the environment identifier.
Each environment may contain:
  - display_name (optional)
  - description (optional)
  - enable_delete_protection (optional, default false)
  - freeform_tags (optional)
  - defined_tags (optional)
  - children (map of child compartments with the same optional fields)
DESC
  type = map(object({
    display_name             = optional(string)
    description              = optional(string)
    enable_delete_protection = optional(bool)
    freeform_tags            = optional(map(string))
    defined_tags             = optional(map(string))
    children = optional(map(object({
      display_name             = optional(string)
      description              = optional(string)
      enable_delete_protection = optional(bool)
      freeform_tags            = optional(map(string))
      defined_tags             = optional(map(string))
    })))
  }))
}


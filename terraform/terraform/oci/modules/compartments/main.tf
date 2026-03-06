locals {
  environment_compartments = {
    for env_key, env in var.environments :
    env_key => merge(
      {
        display_name             = env.display_name != null ? env.display_name : env_key
        description              = env.description != null ? env.description : "OCI compartment ${env_key}"
        enable_delete_protection = coalesce(env.enable_delete_protection, false)
        freeform_tags            = merge(var.default_freeform_tags, coalesce(env.freeform_tags, {}))
        defined_tags             = coalesce(env.defined_tags, {})
      },
      env
    )
  }

  child_compartments = {
    for item in flatten([
      for env_key, env in var.environments : [
        for child_key, child in coalesce(env.children, {}) : {
          key                      = "${env_key}/${child_key}"
          env_key                  = env_key
          display_name             = child.display_name != null ? child.display_name : child_key
          description              = child.description != null ? child.description : "OCI compartment ${child_key}"
          enable_delete_protection = coalesce(child.enable_delete_protection, false)
          freeform_tags            = merge(var.default_freeform_tags, coalesce(child.freeform_tags, {}))
          defined_tags             = coalesce(child.defined_tags, {})
        }
      ]
    ]) :
    item.key => item
  }
}

resource "oci_identity_compartment" "environment" {
  for_each = local.environment_compartments

  name                     = replace(each.value.display_name, "/[^[:alnum:]_\\-]/", "-")
  description              = each.value.description
  parent_compartment_id    = var.parent_compartment_id
  enable_delete_protection = each.value.enable_delete_protection
  freeform_tags            = each.value.freeform_tags
  defined_tags             = each.value.defined_tags
}

resource "oci_identity_compartment" "child" {
  for_each = local.child_compartments

  name                     = replace(each.value.display_name, "/[^[:alnum:]_\\-]/", "-")
  description              = each.value.description
  parent_compartment_id    = oci_identity_compartment.environment[each.value.env_key].id
  enable_delete_protection = each.value.enable_delete_protection
  freeform_tags            = each.value.freeform_tags
  defined_tags             = each.value.defined_tags
}

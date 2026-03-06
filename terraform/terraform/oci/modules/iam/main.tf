# IAM Policies
resource "oci_identity_policy" "this" {
  for_each = { for idx, policy in var.policies : policy.name => policy }

  compartment_id = var.compartment_id
  name           = each.value.name
  description    = each.value.description
  statements     = each.value.statements

  freeform_tags = var.tags
}


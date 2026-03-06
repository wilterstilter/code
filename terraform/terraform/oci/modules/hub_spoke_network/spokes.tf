# Spoke VCNs (one per entry in the spokes map).
resource "oci_core_virtual_network" "spoke" {
  for_each = local.spokes

  compartment_id = each.value.compartment_id
  cidr_block     = each.value.cidr_block
  display_name   = each.value.display_name
  dns_label      = coalesce(each.value.dns_label, null)
  freeform_tags  = merge(var.hub.freeform_tags, coalesce(each.value.freeform_tags, {}))
  defined_tags   = merge(var.hub.defined_tags, coalesce(each.value.defined_tags, {}))
}

# Create the subnets declared for each spoke VCN.
resource "oci_core_subnet" "spoke" {
  for_each = local.spoke_subnets

  compartment_id             = coalesce(each.value.compartment_id, local.spokes[each.value.spoke_key].compartment_id)
  vcn_id                     = oci_core_virtual_network.spoke[each.value.spoke_key].id
  display_name               = each.value.name
  cidr_block                 = each.value.cidr_block
  availability_domain        = lookup(each.value, "availability_domain", null)
  prohibit_public_ip_on_vnic = !(lookup(each.value, "is_public", false))
  route_table_id             = lookup(each.value, "route_table_id", null)
  security_list_ids          = lookup(each.value, "security_list_ids", null)
  dns_label                  = lookup(each.value, "dns_label", null)
  freeform_tags              = merge(var.hub.freeform_tags, coalesce(local.spokes[each.value.spoke_key].freeform_tags, {}), coalesce(each.value.freeform_tags, {}))
  defined_tags               = merge(var.hub.defined_tags, coalesce(local.spokes[each.value.spoke_key].defined_tags, {}), coalesce(each.value.defined_tags, {}))
}


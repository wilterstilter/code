# Hub VCN that hosts shared services and provides transit for spoke networks.
resource "oci_core_virtual_network" "hub" {
  compartment_id = var.hub.compartment_id
  cidr_block     = var.hub.cidr_block
  display_name   = var.hub.display_name
  dns_label      = coalesce(var.hub.dns_label, null)
  freeform_tags  = var.hub.freeform_tags
  defined_tags   = var.hub.defined_tags
}

# Dynamic Routing Gateway (DRG) that all hub/spoke VCNs attach to for east-west connectivity.
resource "oci_core_drg" "hub" {
  compartment_id = var.hub.compartment_id
  display_name   = "${var.hub.display_name}-drg"
  freeform_tags  = var.hub.freeform_tags
  defined_tags   = var.hub.defined_tags
}

# Attach the hub VCN to the DRG.
resource "oci_core_drg_attachment" "hub" {
  drg_id = oci_core_drg.hub.id

  network_details {
    id   = oci_core_virtual_network.hub.id
    type = "VCN"
  }
}

# Create hub subnets defined in the input (public, private, etc.).
resource "oci_core_subnet" "hub" {
  for_each = local.hub_subnets

  compartment_id             = coalesce(each.value.compartment_id, var.hub.compartment_id)
  vcn_id                     = oci_core_virtual_network.hub.id
  display_name               = each.value.name
  cidr_block                 = each.value.cidr_block
  availability_domain        = lookup(each.value, "availability_domain", null)
  prohibit_public_ip_on_vnic = !(lookup(each.value, "is_public", false))
  route_table_id             = lookup(each.value, "route_table_id", null)
  security_list_ids          = lookup(each.value, "security_list_ids", null)
  dns_label                  = lookup(each.value, "dns_label", null)
  freeform_tags              = coalesce(each.value.freeform_tags, var.hub.freeform_tags)
  defined_tags               = coalesce(each.value.defined_tags, var.hub.defined_tags)
}

# Attach each spoke VCN to the hub DRG for transit connectivity.
resource "oci_core_drg_attachment" "spoke" {
  for_each = local.spokes

  drg_id = oci_core_drg.hub.id

  network_details {
    id   = oci_core_virtual_network.spoke[each.key].id
    type = "VCN"
  }

  display_name  = "${each.value.display_name}-drg-attachment"
  freeform_tags = merge(var.hub.freeform_tags, coalesce(each.value.freeform_tags, {}))
  defined_tags  = merge(var.hub.defined_tags, coalesce(each.value.defined_tags, {}))
}

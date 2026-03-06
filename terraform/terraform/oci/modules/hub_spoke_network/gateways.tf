# Optional Internet Gateway for hub VCN public egress.
resource "oci_core_internet_gateway" "hub" {
  count = var.hub.create_internet_gateway ? 1 : 0

  compartment_id = var.hub.compartment_id
  vcn_id         = oci_core_virtual_network.hub.id
  display_name   = "${var.hub.display_name}-igw"
  enabled        = true
  freeform_tags  = var.hub.freeform_tags
  defined_tags   = var.hub.defined_tags
}

# Optional NAT Gateway for private hub subnets to reach the internet.
resource "oci_core_nat_gateway" "hub" {
  count = var.hub.create_nat_gateway ? 1 : 0

  compartment_id = var.hub.compartment_id
  vcn_id         = oci_core_virtual_network.hub.id
  display_name   = "${var.hub.display_name}-nat"
  freeform_tags  = var.hub.freeform_tags
  defined_tags   = var.hub.defined_tags
}

# Optional Service Gateway for private access to OCI services.
resource "oci_core_service_gateway" "hub" {
  count = var.hub.create_service_gateway ? 1 : 0

  compartment_id = var.hub.compartment_id
  vcn_id         = oci_core_virtual_network.hub.id
  display_name   = "${var.hub.display_name}-sgw"

  services {
    service_id = var.hub.service_gateway_service_id
  }

  freeform_tags = var.hub.freeform_tags
  defined_tags  = var.hub.defined_tags
}

# Optional custom route table applied to hub subnets when caller supplies route rules.
resource "oci_core_route_table" "hub" {
  count = length(coalesce(var.hub.route_rules, [])) > 0 ? 1 : 0

  compartment_id = var.hub.compartment_id
  vcn_id         = oci_core_virtual_network.hub.id
  display_name   = "${var.hub.display_name}-rt"

  dynamic "route_rules" {
    for_each = coalesce(var.hub.route_rules, [])
    content {
      cidr_block        = lookup(route_rules.value, "cidr_block", null)
      destination       = lookup(route_rules.value, "destination", null)
      destination_type  = lookup(route_rules.value, "destination_type", null)
      network_entity_id = lookup(route_rules.value, "network_entity_id", null)
      description       = lookup(route_rules.value, "description", null)
    }
  }

  freeform_tags = var.hub.freeform_tags
  defined_tags  = var.hub.defined_tags
}


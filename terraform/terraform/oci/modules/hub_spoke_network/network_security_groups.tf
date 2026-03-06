# Hub-level Network Security Groups defined in hub.nsgs.
resource "oci_core_network_security_group" "hub" {
  for_each = local.hub_nsgs

  compartment_id = var.hub.compartment_id
  vcn_id         = oci_core_virtual_network.hub.id
  display_name   = each.key
  freeform_tags  = merge(var.hub.freeform_tags, lookup(each.value, "freeform_tags", {}))
  defined_tags   = merge(var.hub.defined_tags, lookup(each.value, "defined_tags", {}))
}

# Ingress rules for hub NSGs.
resource "oci_core_network_security_group_security_rule" "hub_ingress" {
  for_each = local.hub_nsg_ingress_rules

  network_security_group_id = oci_core_network_security_group.hub[each.value.nsg_name].id
  direction                 = "INGRESS"
  protocol                  = lookup(local.protocol_map, lower(tostring(each.value.rule.protocol)), tostring(each.value.rule.protocol))
  source_type               = lookup(each.value.rule, "source_type", "CIDR_BLOCK")
  source                    = each.value.rule.source
  stateless                 = lookup(each.value.rule, "stateless", false)
  description               = lookup(each.value.rule, "description", null)

  # Optional TCP port constraints for the rule.
  dynamic "tcp_options" {
    for_each = [for opts in [lookup(each.value.rule, "tcp_options", null)] : opts if opts != null]
    content {
      # Destination port range for TCP traffic (min/max).
      dynamic "destination_port_range" {
        for_each = [for rng in [lookup(tcp_options.value, "destination_port_range", null)] : rng if rng != null]
        content {
          min = destination_port_range.value.min
          max = try(destination_port_range.value.max, destination_port_range.value.min)
        }
      }
      # Source port range (rarely set; kept for completeness).
      dynamic "source_port_range" {
        for_each = [for rng in [lookup(tcp_options.value, "source_port_range", null)] : rng if rng != null]
        content {
          min = source_port_range.value.min
          max = try(source_port_range.value.max, source_port_range.value.min)
        }
      }
    }
  }

  # Optional UDP port constraints.
  dynamic "udp_options" {
    for_each = [for opts in [lookup(each.value.rule, "udp_options", null)] : opts if opts != null]
    content {
      # Destination UDP port range.
      dynamic "destination_port_range" {
        for_each = [for rng in [lookup(udp_options.value, "destination_port_range", null)] : rng if rng != null]
        content {
          min = destination_port_range.value.min
          max = try(destination_port_range.value.max, destination_port_range.value.min)
        }
      }
      # Source UDP port range.
      dynamic "source_port_range" {
        for_each = [for rng in [lookup(udp_options.value, "source_port_range", null)] : rng if rng != null]
        content {
          min = source_port_range.value.min
          max = try(source_port_range.value.max, source_port_range.value.min)
        }
      }
    }
  }

  # Optional ICMP type/code matching.
  dynamic "icmp_options" {
    for_each = (
      try(each.value.rule.icmp_options, null) != null &&
      try(each.value.rule.icmp_options.type, null) != null
    ) ? [each.value.rule.icmp_options] : []
    content {
      type = icmp_options.value.type
      code = try(icmp_options.value.code, null)
    }
  }
}

# Egress rules for hub NSGs.
resource "oci_core_network_security_group_security_rule" "hub_egress" {
  for_each = local.hub_nsg_egress_rules

  network_security_group_id = oci_core_network_security_group.hub[each.value.nsg_name].id
  direction                 = "EGRESS"
  protocol                  = lookup(local.protocol_map, lower(tostring(each.value.rule.protocol)), tostring(each.value.rule.protocol))
  destination_type          = lookup(each.value.rule, "destination_type", "CIDR_BLOCK")
  destination               = each.value.rule.destination
  stateless                 = lookup(each.value.rule, "stateless", false)
  description               = lookup(each.value.rule, "description", null)

  # Optional TCP port constraints.
  dynamic "tcp_options" {
    for_each = [for opts in [lookup(each.value.rule, "tcp_options", null)] : opts if opts != null]
    content {
      # Destination TCP port range.
      dynamic "destination_port_range" {
        for_each = [for rng in [lookup(tcp_options.value, "destination_port_range", null)] : rng if rng != null]
        content {
          min = destination_port_range.value.min
          max = try(destination_port_range.value.max, destination_port_range.value.min)
        }
      }
      # Source TCP port range.
      dynamic "source_port_range" {
        for_each = [for rng in [lookup(tcp_options.value, "source_port_range", null)] : rng if rng != null]
        content {
          min = source_port_range.value.min
          max = try(source_port_range.value.max, source_port_range.value.min)
        }
      }
    }
  }

  # Optional UDP port constraints.
  dynamic "udp_options" {
    for_each = [for opts in [lookup(each.value.rule, "udp_options", null)] : opts if opts != null]
    content {
      # Destination UDP port range.
      dynamic "destination_port_range" {
        for_each = [for rng in [lookup(udp_options.value, "destination_port_range", null)] : rng if rng != null]
        content {
          min = destination_port_range.value.min
          max = try(destination_port_range.value.max, destination_port_range.value.min)
        }
      }
      # Source UDP port range.
      dynamic "source_port_range" {
        for_each = [for rng in [lookup(udp_options.value, "source_port_range", null)] : rng if rng != null]
        content {
          min = source_port_range.value.min
          max = try(source_port_range.value.max, source_port_range.value.min)
        }
      }
    }
  }

  # Optional ICMP type/code matching.
  dynamic "icmp_options" {
    for_each = (
      try(each.value.rule.icmp_options, null) != null &&
      try(each.value.rule.icmp_options.type, null) != null
    ) ? [each.value.rule.icmp_options] : []
    content {
      type = icmp_options.value.type
      code = try(icmp_options.value.code, null)
    }
  }
}

# Spoke-level Network Security Groups defined in spokes.<name>.nsgs.
resource "oci_core_network_security_group" "spoke" {
  for_each = local.spoke_nsgs

  compartment_id = local.spokes[each.value.spoke_key].compartment_id
  vcn_id         = oci_core_virtual_network.spoke[each.value.spoke_key].id
  display_name   = each.value.name
  freeform_tags = merge(
    var.hub.freeform_tags,
    coalesce(local.spokes[each.value.spoke_key].freeform_tags, {}),
    lookup(each.value.definition, "freeform_tags", {})
  )
  defined_tags = merge(
    var.hub.defined_tags,
    coalesce(local.spokes[each.value.spoke_key].defined_tags, {}),
    lookup(each.value.definition, "defined_tags", {})
  )
}

# Ingress rules for spoke NSGs.
resource "oci_core_network_security_group_security_rule" "spoke_ingress" {
  for_each = local.spoke_nsg_ingress_rules

  network_security_group_id = oci_core_network_security_group.spoke[each.value.nsg_key].id
  direction                 = "INGRESS"
  protocol                  = lookup(local.protocol_map, lower(tostring(each.value.rule.protocol)), tostring(each.value.rule.protocol))
  source_type               = lookup(each.value.rule, "source_type", "CIDR_BLOCK")
  source                    = each.value.rule.source
  stateless                 = lookup(each.value.rule, "stateless", false)
  description               = lookup(each.value.rule, "description", null)

  # Optional TCP port constraints.
  dynamic "tcp_options" {
    for_each = [for opts in [lookup(each.value.rule, "tcp_options", null)] : opts if opts != null]
    content {
      # Destination TCP port range.
      dynamic "destination_port_range" {
        for_each = [for rng in [lookup(tcp_options.value, "destination_port_range", null)] : rng if rng != null]
        content {
          min = destination_port_range.value.min
          max = try(destination_port_range.value.max, destination_port_range.value.min)
        }
      }
      # Source TCP port range.
      dynamic "source_port_range" {
        for_each = [for rng in [lookup(tcp_options.value, "source_port_range", null)] : rng if rng != null]
        content {
          min = source_port_range.value.min
          max = try(source_port_range.value.max, source_port_range.value.min)
        }
      }
    }
  }

  # Optional UDP port constraints.
  dynamic "udp_options" {
    for_each = [for opts in [lookup(each.value.rule, "udp_options", null)] : opts if opts != null]
    content {
      # Destination UDP port range.
      dynamic "destination_port_range" {
        for_each = [for rng in [lookup(udp_options.value, "destination_port_range", null)] : rng if rng != null]
        content {
          min = destination_port_range.value.min
          max = try(destination_port_range.value.max, destination_port_range.value.min)
        }
      }
      # Source UDP port range.
      dynamic "source_port_range" {
        for_each = [for rng in [lookup(udp_options.value, "source_port_range", null)] : rng if rng != null]
        content {
          min = source_port_range.value.min
          max = try(source_port_range.value.max, source_port_range.value.min)
        }
      }
    }
  }

  # Optional ICMP type/code matching.
  dynamic "icmp_options" {
    for_each = (
      try(each.value.rule.icmp_options, null) != null &&
      try(each.value.rule.icmp_options.type, null) != null
    ) ? [each.value.rule.icmp_options] : []
    content {
      type = icmp_options.value.type
      code = try(icmp_options.value.code, null)
    }
  }
}

# Egress rules for spoke NSGs.
resource "oci_core_network_security_group_security_rule" "spoke_egress" {
  for_each = local.spoke_nsg_egress_rules

  network_security_group_id = oci_core_network_security_group.spoke[each.value.nsg_key].id
  direction                 = "EGRESS"
  protocol                  = lookup(local.protocol_map, lower(tostring(each.value.rule.protocol)), tostring(each.value.rule.protocol))
  destination_type          = lookup(each.value.rule, "destination_type", "CIDR_BLOCK")
  destination               = each.value.rule.destination
  stateless                 = lookup(each.value.rule, "stateless", false)
  description               = lookup(each.value.rule, "description", null)

  # Optional TCP port constraints.
  dynamic "tcp_options" {
    for_each = [for opts in [lookup(each.value.rule, "tcp_options", null)] : opts if opts != null]
    content {
      # Destination TCP port range.
      dynamic "destination_port_range" {
        for_each = [for rng in [lookup(tcp_options.value, "destination_port_range", null)] : rng if rng != null]
        content {
          min = destination_port_range.value.min
          max = try(destination_port_range.value.max, destination_port_range.value.min)
        }
      }
      # Source TCP port range.
      dynamic "source_port_range" {
        for_each = [for rng in [lookup(tcp_options.value, "source_port_range", null)] : rng if rng != null]
        content {
          min = source_port_range.value.min
          max = try(source_port_range.value.max, source_port_range.value.min)
        }
      }
    }
  }

  # Optional UDP port constraints.
  dynamic "udp_options" {
    for_each = [for opts in [lookup(each.value.rule, "udp_options", null)] : opts if opts != null]
    content {
      # Destination UDP port range.
      dynamic "destination_port_range" {
        for_each = [for rng in [lookup(udp_options.value, "destination_port_range", null)] : rng if rng != null]
        content {
          min = destination_port_range.value.min
          max = try(destination_port_range.value.max, destination_port_range.value.min)
        }
      }
      # Source UDP port range.
      dynamic "source_port_range" {
        for_each = [for rng in [lookup(udp_options.value, "source_port_range", null)] : rng if rng != null]
        content {
          min = source_port_range.value.min
          max = try(source_port_range.value.max, source_port_range.value.min)
        }
      }
    }
  }

  # Optional ICMP type/code matching.
  dynamic "icmp_options" {
    for_each = (
      try(each.value.rule.icmp_options, null) != null &&
      try(each.value.rule.icmp_options.type, null) != null
    ) ? [each.value.rule.icmp_options] : []
    content {
      type = icmp_options.value.type
      code = try(icmp_options.value.code, null)
    }
  }
}


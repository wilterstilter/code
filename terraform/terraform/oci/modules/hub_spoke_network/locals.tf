locals {
  hub_subnets = {
    for subnet in coalesce(var.hub.subnets, []) :
    subnet.name => subnet
  }

  spokes = {
    for spoke_key, spoke in var.spokes :
    spoke_key => spoke
  }

  spoke_subnets = {
    for item in flatten([
      for spoke_key, spoke in var.spokes : [
        for subnet in coalesce(spoke.subnets, []) : merge(subnet, {
          spoke_key     = spoke_key
          composite_key = "${spoke_key}/${subnet.name}"
        })
      ]
    ]) :
    item.composite_key => item
  }

  protocol_map = {
    tcp  = "6"
    udp  = "17"
    icmp = "1"
    all  = "all"
  }

  hub_nsgs = coalesce(var.hub.nsgs, {})

  hub_nsg_ingress_rules = {
    for item in flatten([
      for nsg_name, nsg in local.hub_nsgs : flatten([
        for rule_index, rule in coalesce(nsg.ingress_rules, []) : [
          for expanded_index, expanded_rule in(
            length(coalesce(try(rule.tcp_ports, null), [])) > 0 ?
            [for port in coalesce(try(rule.tcp_ports, null), []) : merge(rule, {
              tcp_options = merge(
                try(rule.tcp_options, {}),
                { destination_port_range = { min = port, max = port } }
              ),
              tcp_ports = null
            })] :
            length(coalesce(try(rule.udp_ports, null), [])) > 0 ?
            [for port in coalesce(try(rule.udp_ports, null), []) : merge(rule, {
              udp_options = merge(
                try(rule.udp_options, {}),
                { destination_port_range = { min = port, max = port } }
              ),
              udp_ports = null
            })] :
            [rule]
            ) : {
            key      = "${nsg_name}/ingress/${rule_index}-${expanded_index}"
            nsg_name = nsg_name
            rule     = expanded_rule
          }
        ]
      ])
    ]) :
    item.key => item
  }

  hub_nsg_egress_rules = {
    for item in flatten([
      for nsg_name, nsg in local.hub_nsgs : flatten([
        for rule_index, rule in coalesce(nsg.egress_rules, []) : flatten([
          for expanded_index, expanded_rule in(
            length(coalesce(try(rule.tcp_ports, null), [])) > 0 ?
            [for port in coalesce(try(rule.tcp_ports, null), []) : merge(rule, {
              tcp_options = merge(
                try(rule.tcp_options, {}),
                { destination_port_range = { min = port, max = port } }
              ),
              tcp_ports = null
            })] :
            length(coalesce(try(rule.udp_ports, null), [])) > 0 ?
            [for port in coalesce(try(rule.udp_ports, null), []) : merge(rule, {
              udp_options = merge(
                try(rule.udp_options, {}),
                { destination_port_range = { min = port, max = port } }
              ),
              udp_ports = null
            })] :
            [rule]
            ) : [
            for destination_index, destination in(
              length(coalesce(try(expanded_rule.destinations, null), [])) > 0
              ? coalesce(expanded_rule.destinations, [])
              : compact([try(expanded_rule.destination, null)])
              ) : {
              key      = "${nsg_name}/egress/${rule_index}-${expanded_index}-${destination_index}"
              nsg_name = nsg_name
              rule = merge(expanded_rule, {
                destination  = destination
                destinations = null
              })
            }
          ]
        ])
      ])
    ]) :
    item.key => item
  }

  spoke_nsgs = {
    for item in flatten([
      for spoke_key, spoke in var.spokes : [
        for nsg_name, nsg in coalesce(spoke.nsgs, {}) : {
          key        = "${spoke_key}/${nsg_name}"
          spoke_key  = spoke_key
          name       = nsg_name
          definition = nsg
        }
      ]
    ]) :
    item.key => item
  }

  spoke_nsg_ingress_rules = {
    for item in flatten([
      for nsg_key, metadata in local.spoke_nsgs : flatten([
        for rule_index, rule in coalesce(metadata.definition.ingress_rules, []) : [
          for expanded_index, expanded_rule in(
            length(coalesce(try(rule.tcp_ports, null), [])) > 0 ?
            [for port in coalesce(try(rule.tcp_ports, null), []) : merge(rule, {
              tcp_options = merge(
                try(rule.tcp_options, {}),
                { destination_port_range = { min = port, max = port } }
              ),
              tcp_ports = null
            })] :
            length(coalesce(try(rule.udp_ports, null), [])) > 0 ?
            [for port in coalesce(try(rule.udp_ports, null), []) : merge(rule, {
              udp_options = merge(
                try(rule.udp_options, {}),
                { destination_port_range = { min = port, max = port } }
              ),
              udp_ports = null
            })] :
            [rule]
            ) : {
            key     = "${nsg_key}/ingress/${rule_index}-${expanded_index}"
            nsg_key = nsg_key
            rule    = expanded_rule
          }
        ]
      ])
    ]) :
    item.key => item
  }

  spoke_nsg_egress_rules = {
    for item in flatten([
      for nsg_key, metadata in local.spoke_nsgs : flatten([
        for rule_index, rule in coalesce(metadata.definition.egress_rules, []) : flatten([
          for expanded_index, expanded_rule in(
            length(coalesce(try(rule.tcp_ports, null), [])) > 0 ?
            [for port in coalesce(try(rule.tcp_ports, null), []) : merge(rule, {
              tcp_options = merge(
                try(rule.tcp_options, {}),
                { destination_port_range = { min = port, max = port } }
              ),
              tcp_ports = null
            })] :
            length(coalesce(try(rule.udp_ports, null), [])) > 0 ?
            [for port in coalesce(try(rule.udp_ports, null), []) : merge(rule, {
              udp_options = merge(
                try(rule.udp_options, {}),
                { destination_port_range = { min = port, max = port } }
              ),
              udp_ports = null
            })] :
            [rule]
            ) : [
            for destination_index, destination in(
              length(coalesce(try(expanded_rule.destinations, null), [])) > 0
              ? coalesce(expanded_rule.destinations, [])
              : compact([try(expanded_rule.destination, null)])
              ) : {
              key     = "${nsg_key}/egress/${rule_index}-${expanded_index}-${destination_index}"
              nsg_key = nsg_key
              rule = merge(expanded_rule, {
                destination  = destination
                destinations = null
              })
            }
          ]
        ])
      ])
    ]) :
    item.key => item
  }
}

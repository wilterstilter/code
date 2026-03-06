# FastConnect private virtual circuit per connection (provider- or colocation-based).
resource "oci_core_virtual_circuit" "this" {
  for_each = local.connections

  compartment_id = each.value.compartment_id
  display_name   = each.value.display_name
  type           = "PRIVATE"

  bandwidth_shape_name = each.value.bandwidth_shape_name
  customer_asn         = each.value.customer_asn
  gateway_id           = var.drg_id

  provider_service_id       = try(each.value.provider_service_id, null)
  provider_service_key_name = try(each.value.provider_service_key_name, null)

  is_bfd_enabled = try(each.value.is_bfd_enabled, null)
  ip_mtu         = try(each.value.ip_mtu, null)
  routing_policy = try(each.value.routing_policy, null)

  dynamic "cross_connect_mappings" {
    for_each = each.value.cross_connect_mappings
    content {
      cross_connect_or_cross_connect_group_id = try(cross_connect_mappings.value.cross_connect_or_cross_connect_group_id, null)
      customer_bgp_peering_ip                 = try(cross_connect_mappings.value.customer_bgp_peering_ip, null)
      oracle_bgp_peering_ip                   = try(cross_connect_mappings.value.oracle_bgp_peering_ip, null)
      customer_bgp_peering_ipv6               = try(cross_connect_mappings.value.customer_bgp_peering_ipv6, null)
      oracle_bgp_peering_ipv6                 = try(cross_connect_mappings.value.oracle_bgp_peering_ipv6, null)
      vlan                                    = try(cross_connect_mappings.value.vlan, null)
      bgp_md5auth_key                         = try(cross_connect_mappings.value.bgp_md5auth_key, null)
    }
  }

  freeform_tags = each.value.freeform_tags
  defined_tags  = each.value.defined_tags
}


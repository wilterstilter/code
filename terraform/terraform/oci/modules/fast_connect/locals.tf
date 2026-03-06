locals {
  default_freeform_tags = coalesce(var.default_freeform_tags, {})
  default_defined_tags  = coalesce(var.default_defined_tags, {})

  connections = {
    for key, conn in var.connections : key => merge(conn, {
      compartment_id         = coalesce(conn.compartment_id, var.compartment_id)
      display_name           = coalesce(conn.display_name, "fastconnect-${key}")
      freeform_tags          = merge(local.default_freeform_tags, coalesce(conn.freeform_tags, {}))
      defined_tags           = merge(local.default_defined_tags, coalesce(conn.defined_tags, {}))
      customer_asn           = coalesce(conn.customer_asn, var.default_customer_bgp_asn)
      cross_connect_mappings = coalesce(conn.cross_connect_mappings, [])
    })
  }
}

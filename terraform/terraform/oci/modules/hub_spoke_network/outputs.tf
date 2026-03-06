# Hub VCN OCID for downstream modules.
output "hub_vcn_id" {
  description = "OCID of the hub VCN."
  value       = oci_core_virtual_network.hub.id
}

# DRG OCID in case callers need to add extra attachments.
output "hub_drg_id" {
  description = "OCID of the created DRG."
  value       = oci_core_drg.hub.id
}

# Map of spoke names to their VCN OCIDs.
output "spoke_vcn_ids" {
  description = "Map of spoke keys to VCN OCIDs."
  value       = { for key, vcn in oci_core_virtual_network.spoke : key => vcn.id }
}

# Map of hub subnet names to subnet OCIDs.
output "hub_subnet_ids" {
  description = "Map of hub subnet names to subnet OCIDs."
  value       = { for key, subnet in oci_core_subnet.hub : key => subnet.id }
}

# Hub NSG OCIDs keyed by NSG name.
output "hub_nsg_ids" {
  description = "Map of hub NSG names to OCIDs."
  value       = { for key, nsg in oci_core_network_security_group.hub : key => nsg.id }
}

# Spoke subnet OCIDs grouped by spoke key.
output "spoke_subnet_ids" {
  description = "Spoke subnet IDs grouped by spoke key."
  value = {
    for key, spoke in local.spokes :
    key => [
      for subnet_key, subnet in local.spoke_subnets :
      oci_core_subnet.spoke[subnet_key].id
      if subnet.spoke_key == key
    ]
  }
}

# Spoke NSG OCIDs keyed by "spoke/name".
output "spoke_nsg_ids" {
  description = "Map of spoke NSGs (spoke/name) to OCIDs."
  value       = { for key, nsg in oci_core_network_security_group.spoke : key => nsg.id }
}


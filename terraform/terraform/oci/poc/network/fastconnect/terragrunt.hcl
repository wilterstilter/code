include "root" {
  path = find_in_parent_folders("terragrunt.hcl")
}

include "common" {
  path   = "${get_terragrunt_dir()}/../../common.hcl"
  expose = true
}

dependency "network" {
  config_path = "../dev"
}

locals {
  common = include.common.locals
}

terraform {
  source = "../../../modules/fast_connect"
}

inputs = {
  region                   = local.common.region
  compartment_id           = local.common.compartment_id
  drg_id                   = dependency.network.outputs.hub_drg_id
  default_customer_bgp_asn = 65105 # on-premises ASN from existing Megaport VC

  connections = {
    megaport_primary = {
      display_name              = "uf-fastconnect-megaport-primary"
      bandwidth_shape_name      = "1 Gbps"
      provider_service_id       = "ocid1.providerservice.oc1.phx.aaaaaaaamj33a2ebotdg5jzwjmlrp7ufslcgl2r4skusfse4ijlgzqonvy3a" # Megaport provider
      routing_policy            = ["MARKET_LEVEL"]                                                                             # advertise/accept all traffic
      customer_bgp_asn          = 65105
      cross_connect_mappings = [
        {
          customer_bgp_peering_ip = "192.168.3.1/30"
          oracle_bgp_peering_ip   = "192.168.3.2/30"
          vlan                    = 0
        }
      ]

      freeform_tags = merge(local.common.common_tags, {
        Component = "network-fastconnect"
        Partner   = "Megaport"
        Role      = "primary"
      })
    }

    megaport_secondary = {
      display_name              = "uf-fastconnect-megaport-secondary"
      bandwidth_shape_name      = "1 Gbps"
      provider_service_id       = "ocid1.providerservice.oc1.phx.aaaaaaaamj33a2ebotdg5jzwjmlrp7ufslcgl2r4skusfse4ijlgzqonvy3a"
      routing_policy            = ["MARKET_LEVEL"]
      customer_bgp_asn          = 65105
      cross_connect_mappings = [
        {
          customer_bgp_peering_ip = "192.168.1.1/30"
          oracle_bgp_peering_ip   = "192.168.1.2/30"
          vlan                    = 0
        }
      ]

      freeform_tags = merge(local.common.common_tags, {
        Component = "network-fastconnect"
        Partner   = "Megaport"
        Role      = "secondary"
      })
    }
  }
}

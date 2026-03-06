include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path   = "${get_terragrunt_dir()}/../../common.hcl"
  expose = true
}

locals {
  common = include.common.locals
}

terraform {
  source = "../../../modules/hub_spoke_network"
}

inputs = {
  region = local.common.region
  # Hub VCN (shared services / transit)
  hub = {
    compartment_id          = local.common.compartment_id                                    # OCI compartment where hub resources live
    display_name            = "uf-dev-hub"                                                   # VCN name shown in OCI console
    cidr_block              = "10.213.0.0/16"                                                # address space for the hub VCN
    dns_label               = "ufdevhub"                                                     # forms the VCN DNS suffix (e.g. *.ufdevhub.oraclevcn.com)
    create_internet_gateway = true                                                           # deploy IGW so public subnets can reach the internet
    create_nat_gateway      = true                                                           # deploy NAT gateway for private subnet outbound traffic
    freeform_tags           = merge(local.common.common_tags, { Component = "network-hub" }) # reusable tags across hub resources
    nsgs = {                                                                                 # Network security groups inside the hub VCN
      # Public hub subnet outbound policy (internet egress)
      hub-public-egress = {
        egress_rules = [
          {
            description      = "Allow outbound internet from public hub subnet"
            protocol         = "all"
            destination      = "0.0.0.0/0"
            destination_type = "CIDR_BLOCK"
          }
        ]
      }
      # Private hub subnet policy (shared services / management)
      hub-private-internal = {
        ingress_rules = [
          {
            description = "Allow app management/HTTPS into hub"
            protocol    = "tcp"
            source      = "10.20.0.0/16"
            tcp_ports   = [22, 443]
          },
          {
            description = "Allow data spoke to reach shared services"
            protocol    = "tcp"
            source      = "10.30.0.0/16"
            tcp_ports   = [443]
          }
        ]
        egress_rules = [
          {
            description      = "Allow private subnet outbound to spokes"
            protocol         = "all"
            destination      = "10.0.0.0/8"
            destination_type = "CIDR_BLOCK"
          }
        ]
      }
    }
    subnets = [ # Actual subnets carved out of the hub VCN CIDR
      {
        name          = "hub-public"                                                          # subnet name
        cidr_block    = "10.213.1.0/24"                                                       # subnet CIDR within hub VCN
        is_public     = true                                                                  # flag tells module to keep public routing
        freeform_tags = merge(local.common.common_tags, { Component = "network-hub-public" }) # subnet tags
        nsgs          = ["hub-public-egress"]                                                 # attach public NSG
      },
      {
        name          = "hub-private"                                                          # name for shared-services subnet
        cidr_block    = "10.213.2.0/24"                                                        # private subnet range
        is_public     = false                                                                  # no direct internet routing
        freeform_tags = merge(local.common.common_tags, { Component = "network-hub-private" }) # subnet tags
        nsgs          = ["hub-private-internal"]                                               # attach internal NSG
      }
    ]
    route_rules = []
  }

  # Spoke VCNs (application and data workloads)
  spokes = {
    app = {
      compartment_id = local.common.compartment_id
      display_name   = "uf-dev-app"
      cidr_block     = "10.214.0.0/16"
      dns_label      = "ufdevapp"
      freeform_tags  = merge(local.common.common_tags, { Component = "network-app" })
      nsgs = {
        app-workers = {
          ingress_rules = [
            {
              description = "Allow hub private management/HTTPS"
              protocol    = "tcp"
              source      = "10.0.0.0/8"
              tcp_ports   = [22, 443]
            }
          ]
          egress_rules = [
            {
              description = "Allow workers outbound to internet via NAT"
              protocol    = "tcp"
              destination = "0.0.0.0/0"
              tcp_ports   = [443]
            },
            {
              description = "Allow workers to database spoke"
              protocol    = "tcp"
              destinations = [
                "10.67.100.0/24",
                "10.67.200.0/24"
              ]
              tcp_ports = [443]
            }
          ]
        }
      }
      subnets = [
        {
          name          = "app-private-a"
          cidr_block    = "10.214.1.0/24"
          freeform_tags = merge(local.common.common_tags, { Component = "network-app" })
          nsgs          = ["app-workers"]
        }
      ]
    }
  }
}

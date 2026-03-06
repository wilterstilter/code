# Hub-and-Spoke Network Module

This module builds a complete hub-and-spoke topology in Oracle Cloud Infrastructure (OCI). It is designed to let you provision a shared **hub VCN** plus any number of **spoke VCNs**, wire them into a **Dynamic Routing Gateway (DRG)**, and configure the surrounding subnets, gateways, and network security groups (NSGs) with minimal boilerplate. Every feature is optional—omit a block and the module simply skips it—so you can start small and grow the design over time.

---

## Table of Contents

1. [Overview](#overview)
2. [Hub VCN](#hub-vcn)
3. [Spoke VCNs](#spoke-vcns)
4. [Network Security Groups](#network-security-groups)
5. [DRG](#drg)
6. [Outputs](#outputs)
7. [Full Example](#full-example)

---

## Overview

| Capability | Description |
| --- | --- |
| Hub VCN | Shared services / transit network. Optional Internet, NAT, and Service gateways plus a custom route table. |
| Spoke VCNs | Workload networks (application, data, analytics, etc.). Each spoke defines its own subnets and NSGs. |
| NSGs | Reusable security groups with simple `tcp_ports` / `udp_ports` lists that expand into individual OCI rules, plus full support for port ranges and ICMP filters. (Attach NSGs to instances in downstream modules.) |
| DRG integration | Creates a DRG and attaches the hub plus every spoke, relying on the DRG’s default route table/distribution. |
| Tagging | Freeform and defined tags propagate automatically; subnets/NSGs can override hub defaults. |

The module reads the following top-level inputs (see `variables.tf` for the exhaustive schema):

- `hub`: hub VCN configuration (compartment, CIDR, optional gateways, subnets, NSGs).
- `spokes`: map of spoke definitions keyed by name.

---

## Hub VCN

Configure the hub by providing metadata, optional gateways, subnets, and reusable NSGs.

```hcl
hub = {
  compartment_id = var.compartment_id
  display_name   = "uf-dev-hub"
  cidr_block     = "10.10.0.0/16"
  dns_label      = "ufdevhub" # optional; controls *.ufdevhub.oraclevcn.com hostnames

  # Toggle gateways as needed per environment.
  create_internet_gateway = true
  create_nat_gateway      = true
  create_service_gateway  = true

  freeform_tags = {
    Environment = "dev"
    Component   = "hub-network"
  }

  subnets = [
    {
      name        = "hub-public"
      cidr_block  = "10.10.1.0/24"
      is_public   = true
      nsgs        = ["hub-public-egress"]
    },
    {
      name        = "hub-private"
      cidr_block  = "10.10.2.0/24"
      nsgs        = ["hub-private-internal"]
    }
  ]

  nsgs = {
    hub-public-egress = {
      egress_rules = [
        {
          description      = "Allow outbound to all OCI services"
          protocol         = "all" # tcp/udp/icmp/all or numeric values
          destination      = "all-oci-services-in-oracle-services-network"
          destination_type = "SERVICE_CIDR_BLOCK"
        }
      ]
    }

    hub-private-internal = {
      ingress_rules = [
        {
          description = "Allow app spokes to manage hub services"
          protocol    = "tcp"
          source      = "10.20.0.0/16"
          tcp_ports   = [22, 443] # expands to one rule per port
        },
        {
          description = "Allow data spokes to reach hub services"
          protocol    = "tcp"
          source      = "10.30.0.0/16"
          tcp_ports   = [443]
        }
      ]
      egress_rules = [
        {
          description = "Allow hub private subnet to reach all spokes"
          protocol    = "all"
          destination = "10.0.0.0/8"
        }
      ]
    }
  }
}
```

> **Tip:** Subnets inherit hub-level tags, route table, and NSGs automatically. Override them on a per-subnet basis only when necessary.

---

## Spoke VCNs

Each entry under `spokes` provisions a VCN, its subnets, and NSGs. The module attaches every spoke to the hub DRG automatically.

```hcl
spokes = {
  app = {
    compartment_id = var.compartment_id
    display_name   = "uf-dev-app"
    cidr_block     = "10.20.0.0/16"
    dns_label      = "ufdevapp"
    freeform_tags  = { Component = "app-network" }

    nsgs = {
      app-workers = {
        ingress_rules = [
          {
            description = "Allow hub private management/HTTPS"
            protocol    = "tcp"
            source      = "10.10.2.0/24"
            tcp_ports   = [22, 443]
          }
        ]
        egress_rules = [
          {
            description = "Allow outbound HTTPS"
            protocol    = "tcp"
            destination = "0.0.0.0/0"
            tcp_ports   = [443]
          },
          {
            description = "Allow DB connections"
            protocol    = "tcp"
            destination = "10.30.1.64/26" # subset of data subnet
            tcp_ports   = [1521]
          }
        ]
      }
    }

    subnets = [
      {
        name        = "app-private-a"
        cidr_block  = "10.20.1.0/24"
        nsgs        = ["app-workers"]
      },
      {
        name        = "app-private-b"
        cidr_block  = "10.20.2.0/24"
        nsgs        = ["app-workers"]
      }
    ]
  }

  data = {
    compartment_id = var.compartment_id
    display_name   = "uf-dev-data"
    cidr_block     = "10.30.0.0/16"
    freeform_tags  = { Component = "data-network" }

    nsgs = {
      data-db = {
        ingress_rules = [
          {
            description = "Allow app workers"
            protocol    = "tcp"
            source      = "10.20.0.0/16"
            tcp_ports   = [1521]
          }
        ]
        egress_rules = [
          {
            description = "Allow DB outbound to hub"
            protocol    = "tcp"
            destination = "10.10.2.0/24"
            tcp_ports   = [443]
          }
        ]
      }
    }

    subnets = [
      {
        name        = "data-private-a"
        cidr_block  = "10.30.1.0/24"
        nsgs        = ["data-db"]
      }
    ]
  }
}
```

> **Tip:** Keep a single spoke if isolation needs are light; create multiple spokes when you need separate blast radii, IAM policies, or quota boundaries. NSGs are created by the module but must be attached to workloads (instances, OKE nodes, etc.) by downstream configurations.

---

## Network Security Groups

NSG rules accept both concise lists and detailed objects. The module normalizes them into the structures OCI expects.

```hcl
nsgs = {
  web = {
    ingress_rules = [
      {
        description = "Allow HTTP/HTTPS from hub"
        protocol    = "tcp"
        source      = "10.10.2.0/24"
        tcp_ports   = [80, 443] # expands into single-port rules
      },
      {
        description = "Allow ICMP echo"
        protocol    = "icmp"
        source      = "10.0.0.0/8"
        icmp_options = {
          type = 8
          code = 0
        }
      },
      {
        description = "Allow TCP range 7000-7005"
        protocol    = "tcp"
        source      = "192.168.1.0/24"
        tcp_options = {
          destination_port_range = { min = 7000, max = 7005 }
        }
      }
    ]
  }
}
```

- `protocol` accepts strings (`"tcp"`, `"udp"`, `"icmp"`, `"all"`) or numeric protocol IDs.
- `tcp_ports` / `udp_ports` create one OCI rule per listed port.
- `tcp_options` / `udp_options` let you describe contiguous ranges or source-port constraints.
- `icmp_options` sets ICMP type/code filters.

Attach the NSGs to instances or load balancers after this module runs; OCI does not support attaching NSGs directly to subnets.

---

## DRG

The module creates a DRG in the hub compartment and attaches the hub VCN plus every spoke VCN to it. Each attachment relies on OCI’s autogenerated route table and import distribution, which keeps the configuration simple while still allowing you to add custom policies later if required (via the console or a follow-on module).

---

## Outputs

- `hub_vcn_id`, `hub_drg_id`
- `hub_subnet_ids`, `hub_nsg_ids`
- `spoke_vcn_ids`, `spoke_subnet_ids`, `spoke_nsg_ids`

These outputs provide OCIDs you can feed into downstream Terraform modules (OKE clusters, database systems, compute instances, etc.).

---

## Full Example

```hcl
module "network" {
  source = "../modules/hub_spoke_network"

  hub = {
    compartment_id = var.compartment_id
    display_name   = "uf-dev-hub"
    cidr_block     = "10.10.0.0/16"
    create_internet_gateway = true
    create_nat_gateway      = true
    subnets = [
      {
        name        = "hub-public"
        cidr_block  = "10.10.1.0/24"
        is_public   = true
        nsgs        = ["hub-public-egress"]
      }
    ]
    nsgs = {
      hub-public-egress = {
        egress_rules = [
          {
            description      = "Allow outbound to OCI services"
            protocol         = "all"
            destination      = "all-oci-services-in-oracle-services-network"
            destination_type = "SERVICE_CIDR_BLOCK"
          }
        ]
      }
    }
  }

  spokes = {
    app = {
      compartment_id = var.compartment_id
      display_name   = "uf-dev-app"
      cidr_block     = "10.20.0.0/16"
      nsgs = {
        app-workers = {
          ingress_rules = [
            {
              description = "Allow hub management/HTTPS"
              protocol    = "tcp"
              source      = "10.10.0.0/16"
              tcp_ports   = [22, 443]
            }
          ]
          egress_rules = [
            {
              description  = "Worker outbound"
              protocol     = "tcp"
              destination  = "0.0.0.0/0"
              tcp_ports    = [443, 9092]
            }
          ]
        }
      }
      subnets = [{
        name       = "app-private"
        cidr_block = "10.20.1.0/24"
        nsgs       = ["app-workers"]
      }]
    }
  }
}
```

Use this module as the foundation for your OCI networking—plug the outputs into OKE clusters, compute modules, or Terraform stacks that deploy application infrastructure.


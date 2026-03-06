# FastConnect Module

Provision and attach Oracle Cloud Infrastructure (OCI) FastConnect virtual circuits to an existing Dynamic Routing Gateway (DRG). The module automates creation of the virtual circuit and the corresponding DRG attachment so traffic from on-premises networks can reach hub-and-spoke VCNs.

## What This Module Does
- Creates one or more **private virtual circuits** (provider-managed or colocation) with the requested bandwidth shape and BGP parameters.
- Optionally enables **BFD** and configures MD5 authentication for BGP sessions.
- Attaches each virtual circuit to the DRG, relying on OCI’s default DRG route table and import/export distributions.
- Exposes OCIDs for the virtual circuits and DRG attachments.

## When to Use It
Run this module after the hub-and-spoke network is in place and the FastConnect circuit has been ordered/accepted:
1. Oracle or the colocation provider has issued the **service key** (provider model) or the **cross-connect OCIDs** (colocation model).
2. BGP parameters (customer ASN, peer IPs, VLAN IDs) are confirmed with the on-premises network team.
3. The DRG that anchors your hub VCN is already created (the hub module exports the DRG OCID).

## Required Inputs
- `compartment_id` – Compartment that owns the virtual circuits.
- `drg_id` – Target DRG OCID.
- `connections` – Map of connection definitions; each entry **must** specify:
  - `bandwidth_shape_name`
  - Either `provider_service_id` (provider circuit) or at least one `cross_connect_mapping` (colocation).
  - `customer_bgp_asn` or a module-level `default_customer_bgp_asn`.
  - Optional overrides for service key, VLAN, BGP IPs, tags, BFD, MD5, and routing policy.

See `variables.tf` for the complete schema.

## Outputs
- `virtual_circuit_ids` – Map of connection key → virtual circuit OCID.
- `drg_attachment_ids` – Map of connection key → DRG attachment OCID.

## Usage Pattern
1. Collect provider or cross-connect details and the BGP configuration from the network team.
2. Populate a Terragrunt/Terraform stack with one entry per circuit under `connections`.
3. Apply the stack once the provider marks the circuit *Provisioned*.
4. After Terraform finishes, configure the on-premises router using the assigned Oracle peer IPs (available in the OCI Console or API).

### Example Terragrunt Snippet
```hcl
terraform {
  source = "../../../modules/fast_connect"
}

inputs = {
  compartment_id          = local.common.compartment_id
  drg_id                  = dependency.network.outputs.hub_drg_id
  default_customer_bgp_asn = 65101
  connections = {
    primary = {
      display_name            = "fc-dal-primary"
      bandwidth_shape_name    = "10 Gbps"
      provider_service_id     = var.megaport_service_id
      provider_service_key_name = var.megaport_service_key
      bgp_md5_auth_key        = var.primary_bgp_md5
      is_bfd_enabled          = true
    }
    secondary = {
      display_name         = "fc-dal-secondary"
      bandwidth_shape_name = "10 Gbps"
      provider_service_id  = var.zayo_service_id
      provider_service_key_name = var.zayo_service_key
    }
  }
}
```

> Replace the provider service IDs/keys with values issued by your FastConnect provider. For colocation deployments, supply `cross_connect_mappings` instead.

## Operational Considerations
- **Manual approvals:** The provider must accept the service key or patch the cross-connect before BGP comes up.
- **Routing policy:** By default attachments inherit OCI’s system import/export distributions. If you need custom policies, update the DRG after apply or extend this module.
- **Monitoring:** After apply, enable FastConnect alarms (BGP status, light levels) via OCI Monitoring.
- **Change management:** Adjusting BGP ASN, VLAN, or peer IPs may require recreating the virtual circuit; coordinate downtime windows accordingly.

## Prerequisites Checklist
- DRG and hub VCN are deployed (hub-spoke module).
- FastConnect service key and VLAN/BGP parameters issued by the provider.
- On-premises routers prepared to peer with Oracle (ports, ACLs, MD5 keys).
- IAM permissions to manage virtual circuits, DRGs, and networking artifacts in the target compartment.



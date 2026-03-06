include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

include "common" {
  path   = find_in_parent_folders("common.hcl")
  expose = true
}

terraform {
  source = "${dirname(find_in_parent_folders())}//projects/freight-network-host/modules/vpc-peering"
}

inputs = {
  project_id                  = include.gcp.locals.project_id
  network_name                = "prod"
  base_labels                 = merge(include.common.locals.base_labels, { "env" : include.gcp.locals.env })
  peering_range_name          = "datafusion-peering-range"
  address_type                = "INTERNAL"
  peering_range_prefix_length = 22
  peering_range_description   = "Global address used for peering with other networks for Data Fusion"
  tenant_project_id           = "dba3d0345e9bf49b5-tp"
  tenant_vpc_name             = "us-south1-uf-datafusion"
}

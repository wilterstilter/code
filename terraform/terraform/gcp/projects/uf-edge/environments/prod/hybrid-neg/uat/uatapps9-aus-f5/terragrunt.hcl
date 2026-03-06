include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-edge/modules/hybrid-neg"
}

include "common2" {
    path = find_in_parent_folders("common2.hcl")
    expose = true
}

dependency "vpc" {
  config_path = "../../../../../../freight-network-host/environments/prod/vpc"
}

inputs = {
  name = include.common2.locals.name
  network = dependency.vpc.outputs.network_id
  zones = [
    "us-south1-b",
    "us-east4-b"
  ]
  onpremise_port  = "443"
  onpremise_ip_addresses = [
    "52.153.241.0"
  ]
}

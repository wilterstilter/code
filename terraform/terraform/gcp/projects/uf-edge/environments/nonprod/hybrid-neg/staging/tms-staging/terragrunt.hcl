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
  config_path = "../../../../../../freight-network-host/environments/nonprod/vpc"
}

inputs = {
  name = include.common2.locals.name
  network = dependency.vpc.outputs.network_id
  zones = [
    "us-south1-c"
  ]
  onpremise_port  = "7077"
  onpremise_ip_addresses = [
    "10.2.112.11",
    "10.2.112.12",
    "10.2.112.13",
    "10.2.112.14",
    "10.2.112.15"
  ]
}

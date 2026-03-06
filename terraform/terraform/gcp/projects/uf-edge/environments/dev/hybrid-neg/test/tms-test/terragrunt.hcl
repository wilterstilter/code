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
  config_path = "../../../../../../freight-network-host/environments/dev/vpc"
}

inputs = {
  name = include.common2.locals.name
  network = dependency.vpc.outputs.network_id
  zones = [
    "us-south1-c"
  ]
  onpremise_port  = "7077"
  onpremise_ip_addresses = [
    "10.2.240.226",
    "10.2.240.219",
    "10.2.240.213"
  ]
}

include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-edge/modules/hybrid-neg"
}

include "common" {
    path = find_in_parent_folders("common.hcl")
    expose = true
}

dependency "vpc" {
  config_path = "../../../../../freight-network-host/environments/prod/vpc"
}

inputs = {
  name = include.common.locals.name
  network = dependency.vpc.outputs.network_id
  zones = [
    "us-south1-a"
  ]
  onpremise_port  = "7077"
  onpremise_ip_addresses = [
    "10.2.204.202",
    "10.2.204.196"
  ]
}

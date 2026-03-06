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
    "us-south1-a"
  ]
  onpremise_port  = "8080"
  onpremise_ip_addresses = [
    "10.2.112.45",
    "10.2.112.57",
    "10.2.112.58",
    "10.2.112.105",
    "10.2.112.106",
    "10.2.112.28",
    "10.2.112.29",
    "10.2.112.32",
    "10.2.112.33",
    "10.2.112.37",
    "10.2.112.38",
    "10.2.112.39"
  ]
}

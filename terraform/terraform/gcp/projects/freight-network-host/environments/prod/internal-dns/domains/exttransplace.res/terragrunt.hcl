include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/freight-network-host/modules/forwarding-zone"
}

include "domains" {
    path = find_in_parent_folders("domains.hcl")
    expose = true
}

dependency "vpc" {
  config_path = "../../../vpc"
}

inputs = {
    project_id = include.gcp.locals.project_id
    domain = include.domains.locals.domain
    network = dependency.vpc.outputs.network_id
    targets = [
        "10.2.120.100", // lwdcvpr1.exttransplace.res
        "10.2.120.101", // lwdcvpr2.exttransplace.res
        "10.2.120.103", // lwdcvpr3.exttransplace.res
        "10.1.120.100", // dwdcvpr1.exttransplace.res
        "10.1.120.101", // dwdcvpr2.exttransplace.res
        "10.1.120.103", // dwdcvpr3.exttransplace.res
    ]
}

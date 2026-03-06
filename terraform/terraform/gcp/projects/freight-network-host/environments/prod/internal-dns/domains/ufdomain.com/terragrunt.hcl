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
        "172.19.49.5", // Azure East US
        "172.19.49.4", // Azure East US
        "172.19.48.5", // Azure South Central US
        "172.19.48.4", // Azure South Central US
    ]
}

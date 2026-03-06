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
        "10.1.231.100", // dwdcvp07.uberfreight.com
        "10.1.231.101", // dwdcvp08.uberfreight.com
        "10.2.231.100", // awdcvp07.uberfreight.com
        "10.2.231.101", // awdcvp08.uberfreight.com
        "172.19.20.38", // ascwdcp08.uberfreight.com
        "172.19.20.37", // ascwdcp07.uberfreight.com
    ]
}

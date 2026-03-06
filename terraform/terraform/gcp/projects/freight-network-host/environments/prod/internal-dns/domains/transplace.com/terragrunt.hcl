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
	    "10.1.102.254", // dwdcvp3.transplace.com
	    "10.1.102.200", // dwdcvp4.transplace.com
	    "172.19.20.39", // ascwdcp2.transplace.com
	    "10.2.244.200", // lwdcvp3.transplace.com
	    "10.67.50.101", // dwdcvp2.transplace.com
	    "10.67.50.100", // dwdcvp1.transplace.com
	    "10.67.3.205",  // lwdcvp2.transplace.com
	    "10.67.3.182",  // lwdcvp1.transplace.com
	    "10.2.102.200", // lwdcvp4.transplace.com
	    "172.19.20.36", // ascwdcp1.transplace.com
	    "172.19.20.36", // ASCWDCP1.transplace.com
    ]
}

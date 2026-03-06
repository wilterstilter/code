include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

include "common" {
    path = find_in_parent_folders("common.hcl")
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/freight-network-host/modules/psc-external-https"
}

dependency "vpc" {
  config_path = "../../vpc"
}

inputs = {
    network = dependency.vpc.outputs.network_id
    subnetwork = dependency.vpc.outputs.psc_regional_subnets["us-east4"]
    domain = "us-east4.devpod.ufinternal.com"
    service_attachment_uri = "projects/z056d8e0307a04ed4p-tp/regions/us-east4/serviceAttachments/k8s1-sa-4g1p33s3-cloudshell-gateway-jucifzs0"
}

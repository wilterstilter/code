include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

include "common" {
    path = find_in_parent_folders("common.hcl")
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/freight-network-host/modules/psc-internal-tcp"
}

dependency "vpc" {
  config_path = "../../vpc"
}

inputs = {
    network = dependency.vpc.outputs.network_id
    subnetwork = dependency.vpc.outputs.uber_accessible_psc_subnet["us-south1"].id
    private_dns = "dom8wddrd3w.us-south1.gcp.confluent.cloud"
    endpoints = {
        "confluent-kafka-psc-n-us-south1-a" = {
            service_attachment_uri = "projects/cc-prod-11/regions/us-south1/serviceAttachments/s-kvrvd-service-attachment-us-south1-a",
            dns_subdomain = "us-south1-a",
            allow_psc_global_access = false
        },
        "confluent-kafka-psc-n-us-south1-b" = {
            service_attachment_uri = "projects/cc-prod-11/regions/us-south1/serviceAttachments/s-kvrvd-service-attachment-us-south1-b",
            dns_subdomain = "us-south1-b",
            allow_psc_global_access = false
        },
        "confluent-kafka-psc-n-us-south1-c" = {
            service_attachment_uri = "projects/cc-prod-11/regions/us-south1/serviceAttachments/s-kvrvd-service-attachment-us-south1-c",
            dns_subdomain = "us-south1-c",
            allow_psc_global_access = false
        }
    }
}

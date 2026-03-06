include "gcp" {
    path = find_in_parent_folders("gcp/terragrunt.hcl")
    expose = true
}

terraform {
  source = "${dirname(find_in_parent_folders("gcp/terragrunt.hcl"))}//projects/freight-infra-as-code/modules/policies/data-warehouse"
}

dependency "vpc" {
  config_path = "../../../../../freight-network-host/environments/prod/vpc"
}

inputs = {
  access_policy_name = "DWH-Non-Prod BQ context access policy"
  project_id         = "125324592177"
  access_level = [
    {
      access_level_name        = "uf_default_network_access_level"
      access_level_description = "Allow ingress from any public IP"
      ip_subnetworks           = ["0.0.0.0/0"]
    },
    {
      access_level_name        = "uf_default_vpc_access_level"
      access_level_description = "Allow ingress from GCP VPC subnets for communication/IAC changes"
      vpc_network_sources = {
        "prod-vpc" = {
          network_id = dependency.vpc.outputs.network_id
          ip_address_ranges = [
            "10.247.1.0/24", #GitHub runners subnet, for IaC changes
            "10.247.2.0/28", #Kafka connect Instances subnet
          ]
        }
      }
    }
  ]
}

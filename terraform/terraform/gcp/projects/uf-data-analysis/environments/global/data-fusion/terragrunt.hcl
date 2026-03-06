include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../../modules/data-fusion"
}

locals {
  project_id = include.gcp.locals.project_id
}

dependency "vpc" {
  config_path = "../../../../freight-network-host/environments/prod/vpc"
}

# Inputs for the terragrunt configuration
inputs = {
  project_id                 = "uf-data-analysis"
  host_project_id            = "freight-network-host-p"
  instance_name              = "uf-datafusion"
  region                     = "us-south1"
  instance_type              = "ENTERPRISE" # or BASIC
  host_network_name          = "prod"
  ip_allocation              = "172.27.20.0/22"
  #peering_range_name         = "datafusion-peering-range"
  service_project_number     = "14938619701"
  dataproc_service_account   = "sa-datafusion@uf-data-analysis.iam.gserviceaccount.com"
  #dataproc_sa_token_creators = ["group:freight-data@uberfreight.com"]
}

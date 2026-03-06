# Include GCP configuration
include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

# Include common configuration
include "common" {
  path   = find_in_parent_folders("common.hcl")
  expose = true
}

# Terraform configuration source
terraform {
  source = "${dirname(find_in_parent_folders())}//projects/uf-data-warehouse/modules/composer"
}

dependency "vpc" {
  config_path = "../../../../freight-network-host/environments/prod/vpc"
}

# Inputs for the Cloud Composer environment
inputs = {
  project_id = include.gcp.locals.project_id
  location   = include.common.locals.region

  buckets = []
}

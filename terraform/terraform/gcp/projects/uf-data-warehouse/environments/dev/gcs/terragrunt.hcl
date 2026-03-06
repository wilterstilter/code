# Include GCP configuration
include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

# Terraform configuration source
terraform {
  source = "../../../modules/gcs"
}

inputs = {
  project_id = include.gcp.locals.project_id
  location   = "us-south1"
  buckets = [
    "uf-dataplatform-temp-dev" # Custom bucket name to store the static csv files which are required for loading silver layer alteryx tables 
  ]
}
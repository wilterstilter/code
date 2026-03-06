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
    "uf-composer-nonprod", # Custom bucket name to test the CICD dags
    "uf-ogg-cdc-nonprod" # Custom bucket for staging cdc data from Oracle Golden Gate
  ]
}
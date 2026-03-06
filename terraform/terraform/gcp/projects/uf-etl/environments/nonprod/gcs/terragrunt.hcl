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
    "uf-etl-nonprod-composer" # Custom bucket name for the Composer environment dedicated to nonprod project.
  ]
}
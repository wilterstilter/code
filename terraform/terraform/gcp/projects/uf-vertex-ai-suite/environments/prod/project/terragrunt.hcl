# Include GCP configuration
include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

# Terraform configuration source
terraform {
 source = "../../../modules/project"
}

# Inputs for the terragrunt configuration
inputs = {
  project_id = include.gcp.locals.project_id
}

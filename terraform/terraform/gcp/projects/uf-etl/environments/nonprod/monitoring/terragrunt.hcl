# Include GCP configuration
include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

# Terraform configuration source
terraform {
 source = "../../../modules/monitoring"
}

# Inputs for the terragrunt configuration
inputs = {
  project_id = include.gcp.locals.project_id
  dashboard_json_file = file("dashboard.json")
}

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
  source = "${dirname(find_in_parent_folders())}//projects/uf-data-warehouse/modules/custom_role"
}

# Inputs for the terragrunt configuration
inputs = {
  project_id = include.gcp.locals.project_id
  custom_roles = [
    "custom.namespace.editor",
    "custom.namespace.editor.serviceAccount",
    "custom.namespace.viewer",
    "custom.devopsOsLogin",
    "custom.bqStudio.user",
    "custom.gcs.storageBucketViewer",
  ]
}

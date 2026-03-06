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
  source = "${dirname(find_in_parent_folders())}//projects/uf-data-warehouse/modules/service_account"
}

# Inputs for the terragrunt configuration
inputs = {
  service_accounts = {
    security-control-test-sa = {
      account_id   = "security-control-test-sa"
      display_name = "VPC security control test service account"
      generate_key = true
    },
    uf-data-adhoc-sa = {
      account_id   = "uf-data-adhoc-sa"
      display_name = "service account for uf-data group for any adhoc testing in Dev"
      generate_key = true
    }
  }
  base_labels = merge(include.common.locals.base_labels, { "env" : include.gcp.locals.env })
}

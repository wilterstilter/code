# Include GCP configuration
include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

# Terraform configuration source
terraform {
  source = "../../../modules/service_account"
}

# Inputs for the terragrunt configuration
inputs = {
  service_accounts = {
    looker-bq-monitoring = {
      account_id   = "looker-bq-monitoring"
      display_name = "Bigquery Monitoring Service account that is used with looker studio"
      generate_key = false
    }
  }
}
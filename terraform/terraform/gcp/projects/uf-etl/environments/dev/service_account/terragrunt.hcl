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
    cloud-composer-sa-d = {
      account_id   = "cloud-composer-sa-d"
      display_name = "Cloud Composer service account"
      generate_key = true
    },
    etl-sa-freight-data-d = {
      account_id   = "etl-sa-freight-data-d"
      display_name = "Service account used by freight-data team to run ETL jobs in cloud composer"
      generate_key = true
    },
    etl-sa-freight-data-science-d = {
      account_id   = "etl-sa-freight-data-science-d"
      display_name = "Service account used by data science team to run ETL jobs in cloud composer"
      generate_key = true
    },
    etl-sa-mx-d = {
      account_id   = "etl-sa-mx-d"
      display_name = "Service account used by mexico team to run ETL jobs in cloud composer"
      generate_key = true
    },
    etl-sa-enterprise-analysts-d = {
      account_id   = "etl-sa-enterprise-analysts-d"
      display_name = "Service account used by enterprise-analyst team to run ETL jobs in cloud composer"
      generate_key = true
    },
    sa-etl-intermodal-d = {
      account_id   = "sa-etl-intermodal-d"
      display_name = "Service account used by intermodal team to run ETL jobs in cloud composer"
      generate_key = true
    },
    etl-sa-logistics-engineering-d = {
      account_id   = "etl-sa-logistics-engineering-d"
      display_name = "Service account used by logistics engineering team to run ETL jobs in cloud composer"
      generate_key = true
    },
  }
}
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
    cloud-composer-sa-n = {
      account_id   = "cloud-composer-sa-n"
      display_name = "Cloud Composer service account"
      generate_key = true
    },
    etl-sa-freight-data-n = {
      account_id   = "etl-sa-freight-data-n"
      display_name = "Service account used by freight-data team to run ETL jobs in cloud composer"
      generate_key = true
    },
    etl-sa-freight-data-science-n = {
      account_id   = "etl-sa-freight-data-science-n"
      display_name = "Service account used by data science team to run ETL jobs in cloud composer"
      generate_key = true
    },
    etl-sa-enterprise-analysts-n = {
      account_id   = "etl-sa-enterprise-analysts-n"
      display_name = "Service account used by enterprise-analyst team to run ETL jobs in cloud composer"
      generate_key = true
    },
    etl-sa-mx-n = {
      account_id   = "etl-sa-mx-n"
      display_name = "Service account used by mexico team to run ETL jobs in cloud composer"
      generate_key = true
    },
    sa-etl-intermodal-n = {
      account_id   = "sa-etl-intermodal-n"
      display_name = "Service account used by intermodal team to run ETL jobs in cloud composer"
      generate_key = true
    },
    etl-sa-logistics-engineering-n = {
      account_id   = "etl-sa-logistics-engineering-n"
      display_name = "Service account used by logistics engineering team to run ETL jobs in cloud composer"
      generate_key = true
    },
  }
}
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
    cloud-composer-sa-p = {
      account_id   = "cloud-composer-sa-p"
      display_name = "Cloud Composer service account"
      generate_key = true
    },
    etl-sa-freight-data-p = {
      account_id   = "etl-sa-freight-data-p"
      display_name = "Service account used by freight-data team to run ETL jobs in cloud composer"
      generate_key = true
    },
    etl-sa-freight-data-science-p = {
      account_id   = "etl-sa-freight-data-science-p"
      display_name = "Service account used by data science team to run ETL jobs in cloud composer"
      generate_key = true
    },
    etl-sa-mx-p = {
      account_id   = "etl-sa-mx-p"
      display_name = "Service account used by mexico team to run ETL jobs in cloud composer"
      generate_key = true
    },
    etl-sa-enterprise-analysts-p = {
      account_id   = "etl-sa-enterprise-analysts-p"
      display_name = "Service account used by enterprise-analyst team to run ETL jobs in cloud composer"
      generate_key = true
    },
    sa-etl-intermodal-p = {
      account_id   = "sa-etl-intermodal-p"
      display_name = "Service account used by intermodal team to run ETL jobs in cloud composer"
      generate_key = true
    },
    etl-sa-logistics-engineering-p = {
      account_id   = "etl-sa-logistics-engineering-p"
      display_name = "Service account used by logistics engineering team to run ETL jobs in cloud composer"
      generate_key = true
    },
  }
}
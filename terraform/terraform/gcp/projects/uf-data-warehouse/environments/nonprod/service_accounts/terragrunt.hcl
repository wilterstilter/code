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
    confluent-kafka-sa = {
      account_id   = "confluent-kafka-sa"
      display_name = "Confluent Kafka service account"
      generate_key = true
    },
    cloud-composer-sa = {
      account_id   = "cloud-composer-sa"
      display_name = "Cloud Composer service account"
      generate_key = true
    },
    ogg-cdc-sa = {
      account_id = "ogg-cdc-sa"
      display_name = "OGG Service Account" #Golden Gate SA for writing into BQ & GCS
      generate_key = true
    },
    tms-bq-schema-updater-sa = { #naming pattern <source>_<destination>-schema-updater-sa
      account_id = "tms-bq-schema-updater-sa"
      display_name = "TMS BQ Schema Updater SA" #SA to update schema from TMS to BQ
      generate_key = true
    },
    bq-dataset-metrics-sa = {
      account_id = "bq-dataset-metrics-sa"
      display_name = "BQ Dataset Metrics SA" #Service account that emit/compute metrics on datasets
      generate_key = true
    }
  }
  base_labels = merge(include.common.locals.base_labels, { "env" : include.gcp.locals.env })
}

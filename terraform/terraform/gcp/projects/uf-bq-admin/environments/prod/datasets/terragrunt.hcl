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
  source = "${dirname(find_in_parent_folders())}//projects/uf-bq-admin/modules/datasets"
}

# Inputs for the terragrunt configuration
inputs = {
  project_id = include.gcp.locals.project_id
  location   = include.common.locals.region

  # Datasets configuration
  datasets = [
    {
      dataset_id                  = "uf_billing"
      layer                       = "billing_exports"
      description                 = "Namespace for billing export from all UF GCP projects"
      default_table_expiration_ms = null # Table never expires
      location                    = "us-central1" #Changing dataset location to a supported region for Cloud Billing data export - https://cloud.google.com/billing/docs/how-to/export-data-bigquery#limitations
      controls                    = {}
    },
    {
      dataset_id                  = "uf_bq_monitoring"
      layer                       = "monitoring"
      description                 = "Namespace for all the bigquery monitoring views"
      default_table_expiration_ms = null # Table never expires
      controls = {
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com",
            "serviceAccount:iac-cicd@freight-infra-as-code.iam.gserviceaccount.com"
          ]
        }
      }
    },
  ]
  env         = include.gcp.locals.env
  base_labels = merge(include.common.locals.base_labels, { "env" : include.gcp.locals.env })
  bq_labels   = include.common.locals.bq_labels
}

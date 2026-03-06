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
  project_id = include.gcp.locals.project_id
  service_accounts = {
    uf-bq-freight-search-sa-d = {
      account_id   = "uf-bq-freight-search-sa-d"
      display_name = "BQ Consumer service account for freight search team dedicated to dev"
      generate_key = true
      secret_accessor_principal = "group:freight-search-eng@uberfreight.com"
    },
    uf-bq-freight-search-sa-n = {
      account_id   = "uf-bq-freight-search-sa-n"
      display_name = "BQ Consumer service account for freight search team dedicated to nonprod"
      generate_key = true
      secret_accessor_principal = "group:freight-search-eng@uberfreight.com"
    },
    uf-bq-freight-search-sa-p = {
      account_id   = "uf-bq-freight-search-sa-p"
      display_name = "BQ Consumer service account for freight search team dedicated to prod"
      generate_key = true
      secret_accessor_principal = "group:freight-search-eng@uberfreight.com"
    },
    sa-tableau-fintech = {
      account_id   = "sa-tableau-fintech"
      display_name = "Tableau service account for Fintech team"
      generate_key = true
      secret_accessor_principal = "group:freight-fintech-data@uberfreight.com"
    },
    sa-tableau-freight-data = {
      account_id   = "sa-tableau-freight-data"
      display_name = "Tableau service account for Freight data team"
      generate_key = true
      secret_accessor_principal = "group:freight-data@uberfreight.com"
    },
    sa-hyper-create-engine = {
      account_id   = "sa-hyper-create-engine"
      display_name = "Service account used by the freight data team for the hyper create engine process"
      generate_key = true
      secret_accessor_principal = "group:freight-data@uberfreight.com"
    },
    sa-datafusion = {
      account_id   = "sa-datafusion"
      display_name = "Data fusion service account"
      generate_key = true
      secret_accessor_principal = "group:freight-data@uberfreight.com"
    },
    sa-datafusion-all-users = {
      account_id   = "sa-datafusion-all-users"
      display_name = "Service account for all data fusion users to run their pipelines"
      generate_key = true
      secret_accessor_principal = "group:freight-data@uberfreight.com"
    },
    sa-tableau-data-science-team = {
      account_id   = "sa-tableau-data-science-team"
      display_name = "Tableau service account for data science team"
      generate_key = true
      secret_accessor_principal = "group:ufds-group@uberfreight.com"
    },
    sa-canada-gcp-team = {
      account_id   = "sa-canada-gcp-team"
      display_name = "service account for canada team"
      generate_key = true
      secret_accessor_principal = "group:canada_gcp_access@uberfreight.com"
    },
    sa-customer-finance-team = {
      account_id   = "sa-customer-finance-team"
      display_name = "service account for customer finance team"
      generate_key = true
      secret_accessor_principal = "group:freight-fintech-finops-gcp@uberfreight.com"
    },
    sa-tableau-logistics-eng = {
      account_id   = "sa-tableau-logistics-eng"
      display_name = "service account for logistics engineering team"
      generate_key = true
      secret_accessor_principal = "group:logisticsengineering@uberfreight.com"
    },
    sa-tableau-cea-team = {
      account_id   = "sa-tableau-cea-team"
      display_name = "service account for client engagement analysts team"
      generate_key = true
      secret_accessor_principal = "group:client_engagement_analysts@uberfreight.com"
    },
    sa-tableau-enterprise-reports = {
      account_id   = "sa-tableau-enterprise-reports"
      display_name = "service account for enterprise reports team"
      generate_key = true
      secret_accessor_principal = "group:enterprisereports@uberfreight.com"
    },
  }
  secretmanager_viewers = [
    "group:freight-search-eng@uberfreight.com",
    "group:freight-fintech-data@uberfreight.com",
    "group:canada_gcp_access@uberfreight.com",
    "group:ufds-group@uberfreight.com",
    "group:freight-fintech-finops-gcp@uberfreight.com",
    "group:logisticsengineering@uberfreight.com",
    "group:client_engagement_analysts@uberfreight.com",
    "group:enterprisereports@uberfreight.com"
  ]
}

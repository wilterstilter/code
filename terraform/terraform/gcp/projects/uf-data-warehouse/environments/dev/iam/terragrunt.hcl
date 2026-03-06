include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../../modules/iam"
}

locals {
  project_id = include.gcp.locals.project_id
}

# Inputs for the terragrunt configuration
inputs = {
  project_id                        = local.project_id
  bqviewers = ["group:freight-data@uberfreight.com",
    "group:freight-data-vendor@uberfreight.com",
    "group:ufds-group@uberfreight.com",
    "group:freight-search-eng@uberfreight.com",
    "group:freight-fintech-data@uberfreight.com",
    "group:c360bigqueryaccess@uberfreight.com",
    "group:freight-data-mexico@uberfreight.com",
    "group:freight-data-devs@uberfreight.com",
    "group:freight-fintech-finops-gcp@uberfreight.com",
    "group:DL-MLEngineering@uberfreight.com",
    "group:sg-az-gcp-devops@uberfreight.com",
    "group:thinktankteam@uberfreight.com",
    "group:international_group_gcp_access@uberfreight.com",
    "group:logisticsengineering@uberfreight.com",
    "group:canada_gcp_access@uberfreight.com",
    "serviceAccount:sa-tableau-fintech@uf-data-analysis.iam.gserviceaccount.com",
    "group:stratopsgcpusers@uberfreight.com",
    "group:optipro-data@uberfreight.com",
    "group:client_engagement_analysts@uberfreight.com",
    "group:ltldataprogram@uberfreight.com",
    "group:freight-productops@uberfreight.com",
    "serviceAccount:sa-customer-finance-team@uf-data-analysis.iam.gserviceaccount.com",
    "serviceAccount:sa-canada-gcp-team@uf-data-analysis.iam.gserviceaccount.com",
    "serviceAccount:sa-tableau-data-science-team@uf-data-analysis.iam.gserviceaccount.com",
    "group:bigcp@uberfreight.com",
    "group:network-dynamics-analysts@uberfreight.com",
    "group:tms-product@uberfreight.com",
    "serviceAccount:sa-tableau-cea-team@uf-data-analysis.iam.gserviceaccount.com",
  ]
}

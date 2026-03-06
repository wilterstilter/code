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
  source = "${dirname(find_in_parent_folders())}//projects/uf-data-warehouse/modules/iam"
}

inputs = {
  project_id         = include.gcp.locals.project_id
  project_number     = "849336014541"
  region             = "us-south1"
  network_project_id = "freight-network-host-p"                                                                   # Network project id
  network            = "projects/freight-network-host-p/global/networks/prod"                                     # Network for the Composer environment 
  subnetwork         = "projects/freight-network-host-p/regions/us-south1/subnetworks/us-south1-composer-network" # Subnetwork for the Composer environment
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

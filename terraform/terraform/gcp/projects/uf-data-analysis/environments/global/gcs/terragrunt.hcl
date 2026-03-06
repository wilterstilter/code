# Include GCP configuration
include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

# Terraform configuration source
terraform {
  source = "../../../modules/gcs"
}

inputs = {
  project_id = include.gcp.locals.project_id
  location   = "us-south1"
  buckets = [
    "uf-datafusion-job-history", # Data fusion job history bucket for storing job history logs
    "uf-datafusion-artifacts" # Data fusion artifacts bucket for storing artifacts like csv, json etc
  ]
  bucket_users = [
    "group:thinktankteam@uberfreight.com",
    "group:network-dynamics-analysts@uberfreight.com",
    "group:logisticsengineering@uberfreight.com",
    "group:freight-fintech-finops-gcp@uberfreight.com",
    "group:international_group_gcp_access@uberfreight.com",
    "group:canada_gcp_access@uberfreight.com",
    "group:client_engagement_analysts@uberfreight.com",
    "serviceAccount:service-14938619701@gcp-sa-datafusion.iam.gserviceaccount.com",
    "serviceAccount:service-14938619701@dataproc-accounts.iam.gserviceaccount.com",
    "serviceAccount:14938619701-compute@developer.gserviceaccount.com",
    "group:intercompany_brokerage_accounting@uberfreight.com",
  ]
  bucket_viewers = [
    "group:thinktankteam@uberfreight.com",
    "group:network-dynamics-analysts@uberfreight.com",
    "group:logisticsengineering@uberfreight.com",
    "group:freight-fintech-finops-gcp@uberfreight.com",
    "group:international_group_gcp_access@uberfreight.com",
    "group:canada_gcp_access@uberfreight.com",
    "group:client_engagement_analysts@uberfreight.com",
    "serviceAccount:service-14938619701@gcp-sa-datafusion.iam.gserviceaccount.com",
    "serviceAccount:service-14938619701@dataproc-accounts.iam.gserviceaccount.com",
    "serviceAccount:14938619701-compute@developer.gserviceaccount.com",
    "group:intercompany_brokerage_accounting@uberfreight.com",
  ]
}

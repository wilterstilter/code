include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../../modules/iam"
}

locals {
  project_id     = include.gcp.locals.project_id
}

# Inputs for the terragrunt configuration
inputs = {
  project_id = local.project_id
  looker_service_account = "looker-bq-monitoring@uf-bq-admin-p.iam.gserviceaccount.com"
  looker_sa_project_id = local.project_id

  project_iam_bindings = {
    "roles/viewer" = {
      entities = [
        "group:freight-data@uberfreight.com",
        "group:freight-data-vendor@uberfreight.com"
      ]
    },
    "roles/bigquery.jobUser" = {
      entities = [
        "group:freight-data@uberfreight.com",
        "group:freight-data-vendor@uberfreight.com",
        "serviceAccount:looker-bq-monitoring@uf-bq-admin-p.iam.gserviceaccount.com",
        "serviceAccount:iac-cicd@freight-infra-as-code.iam.gserviceaccount.com",
        "serviceAccount:bq-usage-monitor@freight-infra-as-code.iam.gserviceaccount.com",
      ]
    },
    "roles/bigquery.resourceAdmin" = {
      entities = [
        "group:freight-data@uberfreight.com",
        "group:freight-data-vendor@uberfreight.com"
      ]
    },
    "roles/bigquery.resourceViewer"= {
      entities = [
        "serviceAccount:bq-usage-monitor@freight-infra-as-code.iam.gserviceaccount.com",
      ]
    },
    "roles/bigquery.resourceEditor" = {
      entities = [
        "serviceAccount:looker-bq-monitoring@uf-bq-admin-p.iam.gserviceaccount.com",
        "serviceAccount:iac-cicd@freight-infra-as-code.iam.gserviceaccount.com"
      ]
    },
    "roles/bigquery.dataViewer" = {
      entities = [
        "serviceAccount:looker-bq-monitoring@uf-bq-admin-p.iam.gserviceaccount.com",
        "serviceAccount:bq-usage-monitor@freight-infra-as-code.iam.gserviceaccount.com",
      ]
    },
    "roles/bigquery.admin" = {
      entities = [
        "group:freight-data@uberfreight.com",
        "group:sg-az-gcp-billing-admins@uberfreight.com"
      ]
    },
  }

  service_account_iam_bindings = {
    "roles/iam.serviceAccountTokenCreator" = {
      entities = [
        "serviceAccount:service-org-223503570424@gcp-sa-datastudio.iam.gserviceaccount.com" # Get this ID from https://lookerstudio.google.com/u/0/serviceAgentHelp
      ]
    },
    "roles/iam.serviceAccountUser" = {
      entities = [
        "group:freight-data@uberfreight.com",
        "group:freight-data-vendor@uberfreight.com"
      ]
    }
  }
}

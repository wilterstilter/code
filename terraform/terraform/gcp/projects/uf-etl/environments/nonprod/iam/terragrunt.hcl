include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../../modules/iam"
}

dependency "service_account" {
  config_path  = "../service_account"
  skip_outputs = true
}

dependency "custom_roles" {
  config_path = "../custom_roles"
}

locals {
  project_id     = include.gcp.locals.project_id
}

# Inputs for the terragrunt configuration
inputs = {
  project_id          = local.project_id
  etl_service_account = "etl-sa-freight-data-n@${local.project_id}.iam.gserviceaccount.com"
  etl_sa_project_id   = local.project_id

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
        "serviceAccount:etl-sa-freight-data-n@${local.project_id}.iam.gserviceaccount.com",
        "serviceAccount:wif-storage-nonprod@uf-etl-n.iam.gserviceaccount.com",
        "serviceAccount:sa-hyper-create-engine@uf-data-analysis.iam.gserviceaccount.com",
        "serviceAccount:etl-sa-enterprise-analysts-n@${local.project_id}.iam.gserviceaccount.com",
        "serviceAccount:etl-sa-freight-data-science-n@${local.project_id}.iam.gserviceaccount.com",
        "serviceAccount:etl-sa-mx-n@${local.project_id}.iam.gserviceaccount.com",
        "serviceAccount:etl-sa-logistics-engineering-n@${local.project_id}.iam.gserviceaccount.com"
      ]
    },
    "roles/composer.worker" = {
      entities = [
        "serviceAccount:cloud-composer-sa-n@${local.project_id}.iam.gserviceaccount.com"
      ]
    },
    "roles/composer.admin" = {
      entities = [
        "group:freight-data@uberfreight.com",
        "group:freight-data-vendor@uberfreight.com",
      ]
    },
    "roles/bigquery.resourceViewer" = {
      entities = [
        "group:freight-data@uberfreight.com",
        "group:freight-data-vendor@uberfreight.com"
      ]
    },
    "roles/storage.objectUser" = {
      entities = [
        "group:freight-data@uberfreight.com",
        "group:freight-data-vendor@uberfreight.com"
      ]
    },
    "roles/storage.objectViewer" = {
      entities = [
        "group:ufds-group@uberfreight.com",
        "group:thinktankteam@uberfreight.com",
        "group:freight-fintech-data@uberfreight.com",
        "group:freight-data-mexico@uberfreight.com",
        "group:freight-data-devs@uberfreight.com",
        "group:logisticsengineering@uberfreight.com"
      ]
    },
    "${dependency.custom_roles.outputs.custom_role_name["custom.composer.daguser"]}" = {
      entities = [
        "group:ufds-group@uberfreight.com",
        "group:thinktankteam@uberfreight.com",
        "group:freight-search-eng@uberfreight.com",
        "group:freight-fintech-data@uberfreight.com",
        "group:freight-data-mexico@uberfreight.com",
        "group:freight-data-devs@uberfreight.com",
        "group:enterprisereports@uberfreight.com",
        "group:logisticsengineering@uberfreight.com"
      ]
    },
    "roles/logging.admin" = {
      entities = [
        "group:freight-data@uberfreight.com"
      ]
    },
    "roles/monitoring.admin" = {
      entities = [
        "group:freight-data@uberfreight.com"
      ]
    },
  }

  service_account_iam_bindings = {
    "roles/iam.serviceAccountTokenCreator" = {
      entities = [
        "serviceAccount:cloud-composer-sa-n@${local.project_id}.iam.gserviceaccount.com"
      ]
    }
  }
}
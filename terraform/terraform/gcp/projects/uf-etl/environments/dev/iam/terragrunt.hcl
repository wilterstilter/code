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
  project_number = "694102367060"
}

# Inputs for the terragrunt configuration
inputs = {
  project_id          = local.project_id
  project_number      = local.project_number
  etl_service_account = "etl-sa-freight-data-d@${local.project_id}.iam.gserviceaccount.com"
  etl_sa_project_id   = local.project_id

  project_iam_bindings = {
    "roles/owner" = {
      entities = [
        "serviceAccount:iac-cicd@freight-infra-as-code.iam.gserviceaccount.com"
      ]
    },
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
        "serviceAccount:etl-sa-freight-data-d@${local.project_id}.iam.gserviceaccount.com",
        "serviceAccount:wif-storage-dev@uf-etl-d.iam.gserviceaccount.com",
        "serviceAccount:sa-hyper-create-engine@uf-data-analysis.iam.gserviceaccount.com",
        "serviceAccount:etl-sa-enterprise-analysts-d@${local.project_id}.iam.gserviceaccount.com",
        "serviceAccount:etl-sa-freight-data-science-d@${local.project_id}.iam.gserviceaccount.com",
        "serviceAccount:etl-sa-mx-d@${local.project_id}.iam.gserviceaccount.com",
        "serviceAccount:etl-sa-logistics-engineering-d@${local.project_id}.iam.gserviceaccount.com"
      ]
    },
    "roles/bigquery.dataEditor" = {
      entities = [
        "group:freight-data@uberfreight.com",
        "group:freight-data-vendor@uberfreight.com"
      ]
    },
    "roles/bigquery.resourceViewer" = {
      entities = [
        "group:freight-data@uberfreight.com",
        "group:freight-data-vendor@uberfreight.com"
      ]
    },
    "roles/composer.worker" = {
      entities = [
        "serviceAccount:cloud-composer-sa-d@${local.project_id}.iam.gserviceaccount.com"
      ]
    },
    "roles/composer.admin" = {
      entities = [
        "group:freight-data@uberfreight.com",
        "group:freight-data-vendor@uberfreight.com",
      ]
    },
    "roles/container.developer" = {
      entities = [
        "serviceAccount:cloud-composer-sa-d@${local.project_id}.iam.gserviceaccount.com"
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
    "roles/artifactregistry.admin" = {
      entities = [
        "group:freight-data@uberfreight.com",
        "group:freight-data-vendor@uberfreight.com"
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
        "serviceAccount:cloud-composer-sa-d@${local.project_id}.iam.gserviceaccount.com",
        "serviceAccount:${local.project_number}-compute@developer.gserviceaccount.com"
      ]
    }
  }
}
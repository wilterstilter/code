include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../../modules/iam"
}

dependency "custom_roles" {
  config_path = "../custom_roles"
}

locals {
  project_id = include.gcp.locals.project_id
}

# Inputs for the terragrunt configuration
inputs = {
  project_id                        = local.project_id
  uf_freight_search_service_account = "uf-bq-freight-search-sa-p@${local.project_id}.iam.gserviceaccount.com" # Prod service account assigned as primiary service account for service account bindings
  uf_freight_search_sa_project_id   = local.project_id
  project_iam_bindings = {
    "roles/viewer" = {
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
    "roles/datafusion.admin" = {
      entities = [
        "group:freight-data@uberfreight.com",
        "serviceAccount:sa-datafusion@uf-data-analysis.iam.gserviceaccount.com"
      ]
    },
    "roles/storage.admin" = {
      entities = [
        "group:freight-data@uberfreight.com"
      ]
    },
    "roles/iam.serviceAccountUser" = {
      entities = [
        "group:freight-data@uberfreight.com"
      ]
    }
    "roles/oauthconfig.editor" = {
      entities = [
        "user:sivadesh@uberfreight.com",
        "user:jaswanth.krishnamurthy@uberfreight.com"
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
    "roles/dataform.admin" = {
      entities = [
        "group:freight-data@uberfreight.com"
      ]
    },
    "roles/aiplatform.colabEnterpriseAdmin" = {
      entities = [
        "group:freight-data@uberfreight.com"
      ]
    }
    "roles/bigquery.jobUser" = {
      entities = [
        "group:freight-data@uberfreight.com",
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
        "group:network-dynamics-analysts@uberfreight.com",
        "group:international_group_gcp_access@uberfreight.com",
        "group:logisticsengineering@uberfreight.com",
        "group:canada_gcp_access@uberfreight.com",
        "serviceAccount:sa-tableau-fintech@uf-data-analysis.iam.gserviceaccount.com",
        "serviceAccount:sa-tableau-freight-data@uf-data-analysis.iam.gserviceaccount.com",
        "serviceAccount:uf-bq-freight-search-sa-d@${local.project_id}.iam.gserviceaccount.com",
        "serviceAccount:uf-bq-freight-search-sa-n@${local.project_id}.iam.gserviceaccount.com",
        "serviceAccount:uf-bq-freight-search-sa-p@${local.project_id}.iam.gserviceaccount.com",
        "serviceAccount:14938619701-compute@developer.gserviceaccount.com",
        "serviceAccount:wif-storage-dev@uf-etl-d.iam.gserviceaccount.com",
        "serviceAccount:etl-sa-freight-data-science-d@uf-etl-d.iam.gserviceaccount.com",
        "serviceAccount:etl-sa-freight-data-d@uf-etl-d.iam.gserviceaccount.com",
        "serviceAccount:sa-datafusion-all-users@uf-data-analysis.iam.gserviceaccount.com",
        "serviceAccount:sa-datafusion@uf-data-analysis.iam.gserviceaccount.com",
        "group:stratopsgcpusers@uberfreight.com",
        "group:optipro-data@uberfreight.com",
        "group:client_engagement_analysts@uberfreight.com",
        "serviceAccount:sa-hyper-create-engine@uf-data-analysis.iam.gserviceaccount.com",
        "group:ltldataprogram@uberfreight.com",
        "group:freight-productops@uberfreight.com",
        "serviceAccount:sa-customer-finance-team@uf-data-analysis.iam.gserviceaccount.com",
        "serviceAccount:sa-canada-gcp-team@uf-data-analysis.iam.gserviceaccount.com",
        "group:bigcp@uberfreight.com",
        "group:tms-product@uberfreight.com",
        "serviceAccount:sa-tableau-data-science-team@uf-data-analysis.iam.gserviceaccount.com",
        "group:enterprisereports@uberfreight.com",
        "serviceAccount:sa-tableau-cea-team@uf-data-analysis.iam.gserviceaccount.com",
        "serviceAccount:sa-tableau-enterprise-reports@uf-data-analysis.iam.gserviceaccount.com",
        "group:bdamxteam@uberfreight.com",
        "group:intercompany_brokerage_accounting@uberfreight.com",
      ]
    },
    "roles/datafusion.viewer" = {
      entities = [
        "group:thinktankteam@uberfreight.com",
        "group:network-dynamics-analysts@uberfreight.com",
        "group:logisticsengineering@uberfreight.com",
        "group:freight-fintech-finops-gcp@uberfreight.com",
        "group:international_group_gcp_access@uberfreight.com",
        "group:canada_gcp_access@uberfreight.com",
        "group:client_engagement_analysts@uberfreight.com",
        "group:intercompany_brokerage_accounting@uberfreight.com",
      ]
    },
    "roles/bigquery.readSessionUser" = {
      entities = [
        "serviceAccount:uf-bq-freight-search-sa-d@${local.project_id}.iam.gserviceaccount.com",
        "serviceAccount:uf-bq-freight-search-sa-n@${local.project_id}.iam.gserviceaccount.com",
        "serviceAccount:uf-bq-freight-search-sa-p@${local.project_id}.iam.gserviceaccount.com",
      ]
    },
    "${dependency.custom_roles.outputs.custom_role_name["custom.notebooks.editor"]}" = {
      entities = [
        "group:freight-data@uberfreight.com"
      ]
    },
  }
  service_account_iam_bindings = {
    "roles/iam.serviceAccountTokenCreator" = {
      entities = [
        "group:freight-search-eng@uberfreight.com"
      ]
    }
  }
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
    "group:tms-product@uberfreight.com",
    "group:enterprisereports@uberfreight.com",
    "serviceAccount:sa-tableau-cea-team@uf-data-analysis.iam.gserviceaccount.com",
    "serviceAccount:sa-tableau-enterprise-reports@uf-data-analysis.iam.gserviceaccount.com",
    "group:bdamxteam@uberfreight.com",
    "group:intercompany_brokerage_accounting@uberfreight.com",
  ]
  bqreaders = ["serviceAccount:sa-tableau-freight-data@uf-data-analysis.iam.gserviceaccount.com",
    "serviceAccount:sa-datafusion-all-users@uf-data-analysis.iam.gserviceaccount.com",
    "serviceAccount:sa-datafusion@uf-data-analysis.iam.gserviceaccount.com",
    "serviceAccount:sa-hyper-create-engine@uf-data-analysis.iam.gserviceaccount.com",
    "serviceAccount:etl-sa-freight-data-d@uf-etl-d.iam.gserviceaccount.com",
    "serviceAccount:sa-customer-finance-team@uf-data-analysis.iam.gserviceaccount.com",
    "serviceAccount:sa-canada-gcp-team@uf-data-analysis.iam.gserviceaccount.com",
  ]
  gemini_users = ["group:freight-data@uberfreight.com",
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
    "group:stratopsgcpusers@uberfreight.com",
    "group:optipro-data@uberfreight.com",
    "group:client_engagement_analysts@uberfreight.com",
    "group:ltldataprogram@uberfreight.com",
    "group:freight-productops@uberfreight.com",
    "group:bigcp@uberfreight.com",
    "group:tms-product@uberfreight.com",
    "group:enterprisereports@uberfreight.com",
    "group:intercompany_brokerage_accounting@uberfreight.com",
  ]
}

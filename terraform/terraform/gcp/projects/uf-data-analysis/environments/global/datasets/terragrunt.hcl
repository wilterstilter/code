include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../../modules/datasets"
}

# Declare dependencies
dependency "custom_roles" {
  config_path = "../custom_roles"
}

# Include common configuration
include "common" {
  path   = find_in_parent_folders("common.hcl")
  expose = true
}

locals {
  project_id = include.gcp.locals.project_id
}

# Inputs for the terragrunt configuration
inputs = {
  project_id = local.project_id
  datasets = [
    {
      dataset_id                  = "paper"
      layer                       = "paper"
      description                 = "Namespace for throw-away temporary data used during development"
      default_table_expiration_ms = 2592000000 # TTL set to 30 days
      controls = {
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com",
            "group:freight-data-devs@uberfreight.com",
            "group:freight-fintech-data@uberfreight.com",
            "group:freight-fintech-finops-gcp@uberfreight.com",
            "group:ufds-group@uberfreight.com",
            "group:freight-data-mexico@uberfreight.com",
            "group:DL-MLEngineering@uberfreight.com",
            "group:sg-az-gcp-devops@uberfreight.com",
            "group:thinktankteam@uberfreight.com",
            "group:network-dynamics-analysts@uberfreight.com",
            "group:international_group_gcp_access@uberfreight.com",
            "group:logisticsengineering@uberfreight.com",
            "group:canada_gcp_access@uberfreight.com",
            "serviceAccount:wif-storage-dev@uf-etl-d.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-d@uf-etl-d.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-n@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-p@uf-etl-p.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-enterprise-analysts-d@uf-etl-d.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-enterprise-analysts-n@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-enterprise-analysts-p@uf-etl-p.iam.gserviceaccount.com",
            "serviceAccount:sa-datafusion-all-users@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:sa-datafusion@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-science-d@uf-etl-d.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-science-n@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-science-p@uf-etl-p.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-logistics-engineering-d@uf-etl-d.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-logistics-engineering-n@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-logistics-engineering-p@uf-etl-p.iam.gserviceaccount.com",
            "group:stratopsgcpusers@uberfreight.com",
            "group:optipro-data@uberfreight.com",
            "group:client_engagement_analysts@uberfreight.com",
            "group:ltldataprogram@uberfreight.com",
            "group:freight-productops@uberfreight.com",
            "group:bigcp@uberfreight.com",
            "group:tms-product@uberfreight.com",
            "group:enterprisereports@uberfreight.com",
            "serviceAccount:sa-tableau-cea-team@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:sa-tableau-enterprise-reports@uf-data-analysis.iam.gserviceaccount.com",
            "group:bdamxteam@uberfreight.com",
            "group:intercompany_brokerage_accounting@uberfreight.com",
          ]
        },
        "roles/bigquery.dataViewer" = {
          entities = ["serviceAccount:sa-customer-finance-team@uf-data-analysis.iam.gserviceaccount.com",
          "serviceAccount:sa-canada-gcp-team@uf-data-analysis.iam.gserviceaccount.com",
          "serviceAccount:sa-tableau-data-science-team@uf-data-analysis.iam.gserviceaccount.com",
          ]
        }
      }
    },
    {
      dataset_id                  = "bronze_fintech_dev"
      layer                       = "bronze"
      description                 = "Namespace that holds fintech data in dev environment"
      default_table_expiration_ms = null # TTL not set
      controls = {
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
          ]
        },
        "${dependency.custom_roles.outputs.custom_role_name["custom.namespace.editor"]}" = {
          entities = [
            "group:freight-fintech-data@uberfreight.com",
            "serviceAccount:sa-tableau-fintech@uf-data-analysis.iam.gserviceaccount.com"
          ]
        },
        "roles/bigquery.dataViewer" = {
          entities = [
            "group:freight-fintech-finops-gcp@uberfreight.com",
            "serviceAccount:sa-customer-finance-team@uf-data-analysis.iam.gserviceaccount.com",
          ]
        }
      }
    },
    {
      dataset_id                  = "thinktank_dataset"
      layer                       = "teamspace"
      description                 = "Namespace for ThinkTank team"
      default_table_expiration_ms = null # TTL not set
      controls = {
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:thinktankteam@uberfreight.com",
            "group:freight-data@uberfreight.com",
            "serviceAccount:sa-datafusion-all-users@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:sa-datafusion@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-enterprise-analysts-d@uf-etl-d.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-enterprise-analysts-n@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-enterprise-analysts-p@uf-etl-p.iam.gserviceaccount.com",
            "serviceAccount:sa-tableau-enterprise-reports@uf-data-analysis.iam.gserviceaccount.com",
          ]
        },
      }
    },
    {
      dataset_id                  = "network_dynamics_dataset"
      layer                       = "teamspace"
      description                 = "Namespace for network-dynamics-analysts team"
      default_table_expiration_ms = null # TTL not set
      controls = {
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:network-dynamics-analysts@uberfreight.com",
            "group:freight-data@uberfreight.com",
            "serviceAccount:sa-datafusion-all-users@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:sa-datafusion@uf-data-analysis.iam.gserviceaccount.com",
          ]
        },
      }
    },
    {
      dataset_id                  = "logistics_engineering_dataset"
      layer                       = "teamspace"
      description                 = "Namespace for logistics engineering team"
      default_table_expiration_ms = null # TTL not set
      controls = {
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:logisticsengineering@uberfreight.com",
            "group:freight-data@uberfreight.com",
            "serviceAccount:sa-datafusion-all-users@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:sa-datafusion@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-logistics-engineering-d@uf-etl-d.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-logistics-engineering-n@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-logistics-engineering-p@uf-etl-p.iam.gserviceaccount.com",
          ]
        },
      }
    },
    {
      dataset_id                  = "intl_group_dataset"
      layer                       = "teamspace"
      description                 = "Namespace for international group team"
      default_table_expiration_ms = null # TTL not set
      controls = {
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:international_group_gcp_access@uberfreight.com",
            "group:freight-data@uberfreight.com",
            "serviceAccount:sa-datafusion-all-users@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:sa-datafusion@uf-data-analysis.iam.gserviceaccount.com",
          ]
        },
      }
    },
    {
      dataset_id                  = "canada_team_dataset"
      layer                       = "teamspace"
      description                 = "Namespace for canada team"
      default_table_expiration_ms = null # TTL not set
      controls = {
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:canada_gcp_access@uberfreight.com",
            "group:freight-data@uberfreight.com",
            "serviceAccount:sa-datafusion-all-users@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:sa-datafusion@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:sa-canada-gcp-team@uf-data-analysis.iam.gserviceaccount.com",
          ]
        },
      }
    },
    {
      dataset_id                  = "finops_dataset"
      layer                       = "teamspace"
      description                 = "Namespace for finops team"
      default_table_expiration_ms = null # TTL not set
      controls = {
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-fintech-finops-gcp@uberfreight.com",
            "group:freight-data@uberfreight.com",
            "serviceAccount:sa-datafusion-all-users@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:sa-datafusion@uf-data-analysis.iam.gserviceaccount.com",
          ]
        },
        "roles/bigquery.dataViewer" = {
          entities = ["serviceAccount:sa-customer-finance-team@uf-data-analysis.iam.gserviceaccount.com",
          ]
        }
      }
    },
    {
      dataset_id                  = "client_engagement_dataset"
      layer                       = "teamspace"
      description                 = "Namespace for client engagement analysts team"
      default_table_expiration_ms = null # TTL not set
      controls = {
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:client_engagement_analysts@uberfreight.com",
            "group:freight-data@uberfreight.com",
            "serviceAccount:sa-datafusion-all-users@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:sa-datafusion@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:sa-tableau-cea-team@uf-data-analysis.iam.gserviceaccount.com",
          ]
        },
      }
    },
    {
      dataset_id                  = "data_science_team_dataset"
      layer                       = "teamspace"
      description                 = "Namespace for data science team"
      default_table_expiration_ms = null # TTL not set
      controls = {
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:ufds-group@uberfreight.com",
            "group:freight-data@uberfreight.com",
            "serviceAccount:etl-sa-freight-data-science-d@uf-etl-d.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-science-n@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-science-p@uf-etl-p.iam.gserviceaccount.com",
          ]
        },
        "roles/bigquery.dataViewer" = {
          entities = ["serviceAccount:sa-tableau-data-science-team@uf-data-analysis.iam.gserviceaccount.com",
          ]
        }
      }
    },
  ]
  env         = include.gcp.locals.env
  base_labels = merge(include.common.locals.base_labels, { "env" : include.gcp.locals.env })
  bq_labels   = include.common.locals.bq_labels
}

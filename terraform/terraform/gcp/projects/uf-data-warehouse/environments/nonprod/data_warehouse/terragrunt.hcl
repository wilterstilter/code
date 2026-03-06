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
  source = "${dirname(find_in_parent_folders())}//projects/uf-data-warehouse/modules/data_warehouse"
}

# Declare dependencies
dependency "custom_roles" {
  config_path = "../custom_roles"
}
dependency "service_accounts" {
  config_path = "../service_accounts"
}

locals {
  data_analysis_project_id = "uf-data-analysis"
}

# Inputs for the terragrunt configuration
inputs = {
  project_id = include.gcp.locals.project_id
  location   = include.common.locals.region

  project_iam_bindings = {
    "roles/viewer" = {
      entities = [
        "group:freight-data@uberfreight.com",
        "group:freight-data-vendor@uberfreight.com",
      ]
    },
    "roles/bigquery.jobUser" = {
      entities = [
        "group:freight-data@uberfreight.com",
        "group:freight-data-vendor@uberfreight.com",
        "serviceAccount:wif-storage-nonprod@uf-etl-n.iam.gserviceaccount.com",
        dependency.service_accounts.outputs.service_account_member["confluent-kafka-sa"],
        dependency.service_accounts.outputs.service_account_member["ogg-cdc-sa"],
        dependency.service_accounts.outputs.service_account_member["tms-bq-schema-updater-sa"],
        dependency.service_accounts.outputs.service_account_member["bq-dataset-metrics-sa"],
        "serviceAccount:sa-hyper-create-engine@uf-data-analysis.iam.gserviceaccount.com",
        "serviceAccount:etl-sa-freight-data-n@uf-etl-n.iam.gserviceaccount.com",
        "serviceAccount:etl-sa-freight-data-d@uf-etl-d.iam.gserviceaccount.com",
      ]
    },
    "roles/bigquery.resourceViewer" = {
      entities = [
        "group:freight-data@uberfreight.com",
        "group:freight-data-vendor@uberfreight.com"
      ]
    },
    "roles/dataplex.catalogEditor" = {
      entities = [
        "group:Val-Marchevsky-all-staff@uberfreight.com"
      ]
    },
    "roles/dataplex.catalogAdmin" = {
      entities = [
        "group:freight-data@uberfreight.com",
        "group:freight-data-vendor@uberfreight.com"
      ]
    },
    "${dependency.custom_roles.outputs.custom_role_name["custom.gcs.storageBucketViewer"]}" = {
      entities = [
        dependency.service_accounts.outputs.service_account_member["ogg-cdc-sa"]
      ]
    },
    "roles/storage.objectUser" = {
      entities = [
        dependency.service_accounts.outputs.service_account_member["ogg-cdc-sa"]
      ]
    }
  }

  # Datasets configuration
  datasets = [
    {
      dataset_id                  = "paper"
      layer                       = "paper"
      description                 = "Namespace for throw-away temporary data used during development"
      default_table_expiration_ms = 864000000 # TTL set to 10 days for all tables
      controls = {
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com",
            "group:freight-data-devs@uberfreight.com",
            "serviceAccount:etl-sa-freight-data-n@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-mx-n@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:wif-storage-nonprod@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:sa-hyper-create-engine@uf-data-analysis.iam.gserviceaccount.com"
          ]
        },
        "${dependency.custom_roles.outputs.custom_role_name["custom.namespace.editor.serviceAccount"]}" = {
          entities = [
            dependency.service_accounts.outputs.service_account_member["confluent-kafka-sa"],
            dependency.service_accounts.outputs.service_account_member["tms-bq-schema-updater-sa"],
          ]
        }
      }
    },
    {
      dataset_id                  = "bronze_tms_uat"
      layer                       = "bronze"
      description                 = "Namespace for cdc data to be sinked from oracle"
      default_table_expiration_ms = null # Table never expires
      controls = {
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com"
          ]
        },
        "roles/bigquery.dataViewer" = {
          entities = [
            "group:thinktankteam@uberfreight.com",
            "group:ufds-group@uberfreight.com",
            "group:freight-data-devs@uberfreight.com",
            "group:logisticsengineering@uberfreight.com",
            "group:freight-search-eng@uberfreight.com",
            "serviceAccount:etl-sa-freight-data-n@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-science-d@uf-etl-d.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-science-n@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-logistics-engineering-n@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:uf-bq-freight-search-sa-n@${local.data_analysis_project_id}.iam.gserviceaccount.com",
            dependency.service_accounts.outputs.service_account_member["bq-dataset-metrics-sa"],
            "serviceAccount:etl-sa-enterprise-analysts-n@uf-etl-n.iam.gserviceaccount.com",
            "group:client_engagement_analysts@uberfreight.com",
            "group:canada_gcp_access@uberfreight.com",
            "group:ltldataprogram@uberfreight.com",
            "group:freight-productops@uberfreight.com",
            "group:network-dynamics-analysts@uberfreight.com",
            "serviceAccount:sa-customer-finance-team@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:sa-canada-gcp-team@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:sa-tableau-data-science-team@uf-data-analysis.iam.gserviceaccount.com",
            "group:bigcp@uberfreight.com",
            "group:tms-product@uberfreight.com",
            "serviceAccount:sa-tableau-cea-team@uf-data-analysis.iam.gserviceaccount.com",
            "group:freight-fintech-data@uberfreight.com",
          ]
        },
        "${dependency.custom_roles.outputs.custom_role_name["custom.namespace.editor.serviceAccount"]}" = {
          entities = [
            dependency.service_accounts.outputs.service_account_member["confluent-kafka-sa"],
            dependency.service_accounts.outputs.service_account_member["ogg-cdc-sa"],
            dependency.service_accounts.outputs.service_account_member["tms-bq-schema-updater-sa"],
          ]
        }
      }
    },
    {
      dataset_id                  = "silver_tms_uat"
      layer                       = "silver"
      description                 = "Namespace for silver layer tables containing TMS data from UAT environment"
      default_table_expiration_ms = null # Table never expires
      controls = {
        "roles/bigquery.dataViewer" = {
          entities = [
            "group:thinktankteam@uberfreight.com",
            "group:ufds-group@uberfreight.com",
            "group:freight-fintech-data@uberfreight.com",
            "group:c360bigqueryaccess@uberfreight.com",
            "group:DL-MLEngineering@uberfreight.com",
            "group:logisticsengineering@uberfreight.com",
            "serviceAccount:sa-hyper-create-engine@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-enterprise-analysts-n@uf-etl-n.iam.gserviceaccount.com",
            "group:client_engagement_analysts@uberfreight.com",
            "group:canada_gcp_access@uberfreight.com",
            "serviceAccount:etl-sa-freight-data-science-n@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-logistics-engineering-n@uf-etl-n.iam.gserviceaccount.com",
            "group:ltldataprogram@uberfreight.com",
            "group:freight-productops@uberfreight.com",
            "group:network-dynamics-analysts@uberfreight.com",
            "serviceAccount:sa-customer-finance-team@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:sa-canada-gcp-team@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:sa-tableau-data-science-team@uf-data-analysis.iam.gserviceaccount.com",
            "group:bigcp@uberfreight.com",
            "group:tms-product@uberfreight.com",
            "serviceAccount:sa-tableau-cea-team@uf-data-analysis.iam.gserviceaccount.com",
          ]
        },
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com",
            "group:freight-data-devs@uberfreight.com",
            "serviceAccount:wif-storage-nonprod@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-n@uf-etl-n.iam.gserviceaccount.com",
          ]
        }
      }
    },
    {
      dataset_id                  = "gold_tms_uat"
      layer                       = "gold"
      description                 = "Namespace for gold layer tables containing TMS data from UAT environment"
      default_table_expiration_ms = null # Table never expires
      controls = {
        "roles/bigquery.dataViewer" = {
          entities = [
            "group:thinktankteam@uberfreight.com",
            "group:ufds-group@uberfreight.com",
            "group:freight-fintech-data@uberfreight.com",
            "group:c360bigqueryaccess@uberfreight.com",
            "group:DL-MLEngineering@uberfreight.com",
            "group:logisticsengineering@uberfreight.com",
            "serviceAccount:sa-hyper-create-engine@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-enterprise-analysts-n@uf-etl-n.iam.gserviceaccount.com",
            "group:client_engagement_analysts@uberfreight.com",
            "group:canada_gcp_access@uberfreight.com",
            "serviceAccount:etl-sa-freight-data-science-n@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-logistics-engineering-n@uf-etl-n.iam.gserviceaccount.com",
            "group:ltldataprogram@uberfreight.com",
            "group:freight-productops@uberfreight.com",
            "group:network-dynamics-analysts@uberfreight.com",
            "serviceAccount:sa-customer-finance-team@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:sa-canada-gcp-team@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:sa-tableau-data-science-team@uf-data-analysis.iam.gserviceaccount.com",
            "group:bigcp@uberfreight.com",
            "group:tms-product@uberfreight.com",
            "serviceAccount:sa-tableau-cea-team@uf-data-analysis.iam.gserviceaccount.com",
          ]
        },
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com",
            "group:freight-data-devs@uberfreight.com",
            "serviceAccount:wif-storage-nonprod@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-n@uf-etl-n.iam.gserviceaccount.com",
          ]
        }
      }
    },
    {
      dataset_id                  = "bronze_tms_preprod"
      layer                       = "bronze"
      description                 = "Namespace for views contaiining tms prod data in bronze layer "
      default_table_expiration_ms = null # Table never expires
      controls = {
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com"
          ]
        },
        "roles/bigquery.dataViewer" = {
          entities = [
            "group:thinktankteam@uberfreight.com",
            "group:ufds-group@uberfreight.com",
            "group:logisticsengineering@uberfreight.com",
            "serviceAccount:etl-sa-enterprise-analysts-n@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-n@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-science-d@uf-etl-d.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-science-n@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-logistics-engineering-n@uf-etl-n.iam.gserviceaccount.com",
          ]
        }
      }
    },
    {
      dataset_id                  = "silver_tms_preprod"
      layer                       = "silver"
      description                 = "Namespace for silver layer tables containing TMS data from bronze prod environment"
      default_table_expiration_ms = null # Table never expires
      controls = {
        "roles/bigquery.dataViewer" = {
          entities = [
            "group:thinktankteam@uberfreight.com",
            "group:logisticsengineering@uberfreight.com",
            "serviceAccount:etl-sa-enterprise-analysts-n@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-science-n@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-logistics-engineering-n@uf-etl-n.iam.gserviceaccount.com",
          ]
        },
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com",
            "group:freight-data-devs@uberfreight.com",
            "group:ufds-group@uberfreight.com",
            "serviceAccount:wif-storage-nonprod@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-n@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:sa-hyper-create-engine@uf-data-analysis.iam.gserviceaccount.com"
          ]
        }
      }
    },
    {
      dataset_id                  = "gold_tms_preprod"
      layer                       = "gold"
      description                 = "Namespace for gold layer tables containing TMS data from bronze prod environment"
      default_table_expiration_ms = null # Table never expires
      controls = {        
        "roles/bigquery.dataViewer" = {
          entities = [
            "group:thinktankteam@uberfreight.com",
            "group:logisticsengineering@uberfreight.com",
            "serviceAccount:etl-sa-enterprise-analysts-n@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-science-n@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-logistics-engineering-n@uf-etl-n.iam.gserviceaccount.com",
          ]
        },
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com",
            "group:freight-data-devs@uberfreight.com",
            "group:ufds-group@uberfreight.com",
            "serviceAccount:wif-storage-nonprod@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-n@uf-etl-n.iam.gserviceaccount.com",
            "serviceAccount:sa-hyper-create-engine@uf-data-analysis.iam.gserviceaccount.com"
          ]
        }
      }
    },
    {
      dataset_id                  = "bronze_mexico_uat"
      layer                       = "bronze"
      description                 = "Namespace that holds bronze layer data for Mexico"
      default_table_expiration_ms = null # Table never expires
      controls = {
        "roles/bigquery.dataViewer" = {
          entities = [
            dependency.service_accounts.outputs.service_account_member["bq-dataset-metrics-sa"],
            "group:freight-data-mexico@uberfreight.com"
          ]
        },
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com",
            "serviceAccount:etl-sa-mx-n@uf-etl-n.iam.gserviceaccount.com"
          ]
        },
        "${dependency.custom_roles.outputs.custom_role_name["custom.namespace.editor.serviceAccount"]}" = {
          entities = [
            dependency.service_accounts.outputs.service_account_member["confluent-kafka-sa"]
          ]
        }
      }
    },
    {
      dataset_id                  = "silver_mexico_uat"
      layer                       = "silver"
      description                 = "Namespace that holds silver layer data for Mexico"
      default_table_expiration_ms = null # Table never expires
      controls = {
        "roles/bigquery.dataViewer" = {
          entities = [
            dependency.service_accounts.outputs.service_account_member["bq-dataset-metrics-sa"], 
          ]
        },
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com",
            "group:freight-data-mexico@uberfreight.com",
            "serviceAccount:etl-sa-mx-n@uf-etl-n.iam.gserviceaccount.com"
          ]
        },
      }
    },
    {
      dataset_id                  = "gold_mexico_uat"
      layer                       = "gold"
      description                 = "Namespace that holds gold layer data for Mexico"
      default_table_expiration_ms = null # Table never expires
      controls = {
        "roles/bigquery.dataViewer" = {
          entities = [
            dependency.service_accounts.outputs.service_account_member["bq-dataset-metrics-sa"], 
          ]
        },
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com",
            "group:freight-data-mexico@uberfreight.com",
            "serviceAccount:etl-sa-mx-n@uf-etl-n.iam.gserviceaccount.com"
          ]
        },
      }
    },
    {
      dataset_id                  = "bronze_intermodal_uat"
      layer                       = "bronze"
      description                 = "Namespace that holds intermodal data in uat/nonprod environment"
      default_table_expiration_ms = null # Table never expires
      controls = {
        "roles/bigquery.dataViewer" = {
          entities = [
            dependency.service_accounts.outputs.service_account_member["bq-dataset-metrics-sa"],
            "group:ufds-group@uberfreight.com",
            "serviceAccount:sa-tableau-data-science-team@uf-data-analysis.iam.gserviceaccount.com",
            "group:network-dynamics-analysts@uberfreight.com",
          ]
        },
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com"
          ]
        },
        "${dependency.custom_roles.outputs.custom_role_name["custom.namespace.editor.serviceAccount"]}" = {
          entities = [
            dependency.service_accounts.outputs.service_account_member["confluent-kafka-sa"],
            dependency.service_accounts.outputs.service_account_member["ogg-cdc-sa"],
            
          ]
        }
      }
    },
    {
      dataset_id                  = "silver_intermodal_uat"
      layer                       = "silver"
      description                 = "Namespace that holds intermodal data in uat/nonprod environment"
      default_table_expiration_ms = null # Table never expires
      controls = {
        "roles/bigquery.dataViewer" = {
          entities = [
            "group:thinktankteam@uberfreight.com",
            "group:ufds-group@uberfreight.com",
            "group:freight-fintech-data@uberfreight.com",
            "group:c360bigqueryaccess@uberfreight.com",
            "group:DL-MLEngineering@uberfreight.com",
            "group:logisticsengineering@uberfreight.com",
            dependency.service_accounts.outputs.service_account_member["bq-dataset-metrics-sa"],
            "group:freight-productops@uberfreight.com",
            "serviceAccount:sa-tableau-data-science-team@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-logistics-engineering-n@uf-etl-n.iam.gserviceaccount.com",
            "group:network-dynamics-analysts@uberfreight.com",
          ]
        },
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com",
            "group:ufds-group@uberfreight.com",
            "serviceAccount:sa-etl-intermodal-n@uf-etl-n.iam.gserviceaccount.com",
          ]
        }
      }
    },
        {
      dataset_id                  = "gold_intermodal_uat"
      layer                       = "gold"
      description                 = "Namespace that holds intermodal data in uat/nonprod environment"
      default_table_expiration_ms = null # Table never expires
      controls = {
        "roles/bigquery.dataViewer" = {
          entities = [
            "group:thinktankteam@uberfreight.com",
            "group:ufds-group@uberfreight.com",
            "group:freight-fintech-data@uberfreight.com",
            "group:c360bigqueryaccess@uberfreight.com",
            "group:DL-MLEngineering@uberfreight.com",
            "group:logisticsengineering@uberfreight.com",
            dependency.service_accounts.outputs.service_account_member["bq-dataset-metrics-sa"],
            "group:freight-productops@uberfreight.com",
            "serviceAccount:sa-tableau-data-science-team@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-logistics-engineering-n@uf-etl-n.iam.gserviceaccount.com",
            "group:network-dynamics-analysts@uberfreight.com",
          ]
        },
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com",
            "group:ufds-group@uberfreight.com",
            "serviceAccount:sa-etl-intermodal-n@uf-etl-n.iam.gserviceaccount.com",
          ]
        }
      }
    },
    {
      dataset_id                  = "bronze_mcleod_uat"
      layer                       = "bronze"
      description                 = "Namespace that holds MCLeod data in uat/nonprod environment"
      default_table_expiration_ms = null # Table never expires
      controls = {
        "roles/bigquery.dataViewer" = {
          entities = [
            dependency.service_accounts.outputs.service_account_member["bq-dataset-metrics-sa"],
            "group:network-dynamics-analysts@uberfreight.com",
          ]
        },
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com"
          ]
        },
        "${dependency.custom_roles.outputs.custom_role_name["custom.namespace.editor.serviceAccount"]}" = {
          entities = [
            dependency.service_accounts.outputs.service_account_member["ogg-cdc-sa"],
          ]
        }
      }
    }
  ]
  env         = include.gcp.locals.env
  base_labels = merge(include.common.locals.base_labels, { "env" : include.gcp.locals.env })
  bq_labels   = include.common.locals.bq_labels
  bqreaders = ["serviceAccount:sa-tableau-freight-data@uf-data-analysis.iam.gserviceaccount.com",
  "serviceAccount:sa-datafusion-all-users@uf-data-analysis.iam.gserviceaccount.com",
  "serviceAccount:sa-datafusion@uf-data-analysis.iam.gserviceaccount.com",
  "serviceAccount:sa-hyper-create-engine@uf-data-analysis.iam.gserviceaccount.com",
  "serviceAccount:etl-sa-freight-data-n@uf-etl-n.iam.gserviceaccount.com",
  "serviceAccount:etl-sa-freight-data-d@uf-etl-d.iam.gserviceaccount.com",
  ]
}
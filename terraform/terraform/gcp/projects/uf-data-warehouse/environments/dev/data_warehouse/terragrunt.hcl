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
  etl_project_id           = "uf-etl-d"
  data_analysis_project_id = "uf-data-analysis"
}

# Inputs for the terragrunt configuration
inputs = {
  project_id = include.gcp.locals.project_id
  location   = include.common.locals.region

  project_iam_bindings = {
    "roles/owner" = {
      entities = [
        "serviceAccount:iac-cicd@freight-infra-as-code.iam.gserviceaccount.com"
      ]
    },
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
        "group:freight-data-devs@uberfreight.com",
        "serviceAccount:iac-cicd@freight-infra-as-code.iam.gserviceaccount.com",
        "serviceAccount:wif-storage-dev@uf-etl-d.iam.gserviceaccount.com",
        dependency.service_accounts.outputs.service_account_member["security-control-test-sa"],
        dependency.service_accounts.outputs.service_account_member["uf-data-adhoc-sa"],
        "serviceAccount:hive-to-bq-sa@uf-data-warehouse-p.iam.gserviceaccount.com",
        "serviceAccount:sa-hyper-create-engine@uf-data-analysis.iam.gserviceaccount.com",
        "serviceAccount:gke-etl-dev@uf-etl-d.iam.gserviceaccount.com",
        "serviceAccount:etl-sa-freight-data-d@uf-etl-d.iam.gserviceaccount.com",
        "serviceAccount:etl-sa-mx-d@uf-etl-d.iam.gserviceaccount.com",
      ]
    },
    "roles/bigquery.resourceViewer" = {
      entities = [
        "group:freight-data@uberfreight.com",
        "group:freight-data-vendor@uberfreight.com",
        "serviceAccount:iac-cicd@freight-infra-as-code.iam.gserviceaccount.com"
      ]
    },
    "roles/bigquery.dataEditor" = {
      entities = [
        "serviceAccount:iac-cicd@freight-infra-as-code.iam.gserviceaccount.com"
      ]
    },
    "roles/storage.objectUser" = {
      entities = [
        "group:freight-data@uberfreight.com",
        "group:freight-data-vendor@uberfreight.com",
        dependency.service_accounts.outputs.service_account_member["uf-data-adhoc-sa"],
        "serviceAccount:hive-to-bq-sa@uf-data-warehouse-p.iam.gserviceaccount.com"
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
        dependency.service_accounts.outputs.service_account_member["uf-data-adhoc-sa"]
      ]
    },
    "roles/bigquery.readSessionUser" = {
      entities = [
        "serviceAccount:hive-to-bq-sa@uf-data-warehouse-p.iam.gserviceaccount.com"
      ]
    },
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
            "serviceAccount:etl-sa-freight-data-d@uf-etl-d.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-mx-d@uf-etl-d.iam.gserviceaccount.com",
            "serviceAccount:wif-storage-dev@uf-etl-d.iam.gserviceaccount.com",
            "serviceAccount:hive-to-bq-sa@uf-data-warehouse-p.iam.gserviceaccount.com",
            "serviceAccount:sa-hyper-create-engine@uf-data-analysis.iam.gserviceaccount.com",
            "serviceAccount:gke-etl-dev@uf-etl-d.iam.gserviceaccount.com"
          ]
        },
        "${dependency.custom_roles.outputs.custom_role_name["custom.namespace.editor.serviceAccount"]}" = {
          entities = [
            dependency.service_accounts.outputs.service_account_member["security-control-test-sa"],
            dependency.service_accounts.outputs.service_account_member["uf-data-adhoc-sa"]
          ]
        }
      }
    },
    {
      dataset_id                  = "bronze_tms_dev"
      layer                       = "bronze"
      description                 = "Dev environment namespace that holds bronze layer data for TMS"
      default_table_expiration_ms = null # Table never expires
      controls = {
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com", 
          ]
        },
        "roles/bigquery.dataViewer" = {
          entities = [
            "group:freight-data-devs@uberfreight.com",
            "serviceAccount:uf-bq-freight-search-sa-d@${local.data_analysis_project_id}.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-d@uf-etl-d.iam.gserviceaccount.com",
            "group:enterprisereports@uberfreight.com",
            "serviceAccount:sa-tableau-enterprise-reports@uf-data-analysis.iam.gserviceaccount.com",
          ]
        }
      }
    },
    {
      dataset_id                  = "silver_tms_dev"
      layer                       = "silver"
      description                 = "Dev environment namespace that holds silver layer data for TMS"
      default_table_expiration_ms = null # Table never expires
      controls = {
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com",
            "group:freight-data-devs@uberfreight.com",
            "serviceAccount:wif-storage-dev@uf-etl-d.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-d@uf-etl-d.iam.gserviceaccount.com",
            "serviceAccount:sa-hyper-create-engine@uf-data-analysis.iam.gserviceaccount.com"
          ]
        }
      }
    },
    {
      dataset_id                  = "gold_tms_dev"
      layer                       = "gold"
      description                 = "Dev environment namespace that holds gold layer data for TMS"
      default_table_expiration_ms = null # Table never expires
      controls = {
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com",
            "group:freight-data-devs@uberfreight.com",
            "serviceAccount:etl-sa-freight-data-d@${local.etl_project_id}.iam.gserviceaccount.com",
            "serviceAccount:wif-storage-dev@uf-etl-d.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-d@uf-etl-d.iam.gserviceaccount.com",
            "serviceAccount:sa-hyper-create-engine@uf-data-analysis.iam.gserviceaccount.com"
          ]
        }
      }
    },
    {
      dataset_id                  = "bronze_mexico_dev"
      layer                       = "bronze"
      description                 = "Dev environment namespace that holds bronze layer data for Mexico"
      default_table_expiration_ms = null # Table never expires
      controls = {
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com",
            "serviceAccount:etl-sa-mx-d@uf-etl-d.iam.gserviceaccount.com",
          ]
        }
      }
    },
    {
      dataset_id                  = "silver_mexico_dev"
      layer                       = "silver"
      description                 = "Dev environment namespace that holds silver layer data for Mexico"
      default_table_expiration_ms = null # Table never expires
      controls = {
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com",
            "serviceAccount:etl-sa-mx-d@uf-etl-d.iam.gserviceaccount.com"
          ]
        }
      }
    },
    {
      dataset_id                  = "gold_mexico_dev"
      layer                       = "gold"
      description                 = "Dev environment namespace that holds gold layer data for Mexico"
      default_table_expiration_ms = null # Table never expires
      controls = {
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com",
            "serviceAccount:etl-sa-mx-d@uf-etl-d.iam.gserviceaccount.com"
          ]
        }
      }
    },
    {
      dataset_id                  = "bronze_digital_brokerage_dev"
      layer                       = "bronze"
      description                 = "Dev environment namespace that holds bronze layer data for digital brokerage"
      default_table_expiration_ms = null # Table never expires
      controls = {
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com",
            "group:freight-data-devs@uberfreight.com",
            "serviceAccount:wif-storage-dev@uf-etl-d.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-d@uf-etl-d.iam.gserviceaccount.com",
            "serviceAccount:hive-to-bq-sa@uf-data-warehouse-p.iam.gserviceaccount.com"
          ]
        },
      }
    },
    {
      dataset_id                  = "silver_digital_brokerage_dev"
      layer                       = "silver"
      description                 = "Dev environment namespace that holds silver layer data for digital brokerage"
      default_table_expiration_ms = null # Table never expires
      controls = {
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com",
            "group:freight-data-devs@uberfreight.com",
            "serviceAccount:wif-storage-dev@uf-etl-d.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-d@uf-etl-d.iam.gserviceaccount.com",
            "serviceAccount:hive-to-bq-sa@uf-data-warehouse-p.iam.gserviceaccount.com"
          ]
        },
      }
    },
    {
      dataset_id                  = "gold_digital_brokerage_dev"
      layer                       = "gold"
      description                 = "Dev environment namespace for gold layer tables containing digital brokerage data"
      default_table_expiration_ms = null # Table never expires
      controls = {
        "roles/bigquery.dataEditor" = {
          entities = [
            "group:freight-data@uberfreight.com",
            "group:freight-data-vendor@uberfreight.com",
            "group:freight-data-devs@uberfreight.com",
            "serviceAccount:wif-storage-dev@uf-etl-d.iam.gserviceaccount.com",
            "serviceAccount:etl-sa-freight-data-d@uf-etl-d.iam.gserviceaccount.com",
            "serviceAccount:hive-to-bq-sa@uf-data-warehouse-p.iam.gserviceaccount.com"
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
    "serviceAccount:etl-sa-freight-data-d@uf-etl-d.iam.gserviceaccount.com",
  ]
}
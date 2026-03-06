# Include GCP configuration
include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

# Terraform configuration source
terraform {
  source = "../../../modules/monitoring"
}

locals {
  project_id = include.gcp.locals.project_id
}

# Inputs for the terragrunt configuration
inputs = {
  project_id = local.project_id

  emails = [
    "freight-data-alerts@uberfreight.com"
  ]

  project_ids_to_monitor = [
    "uf-etl-d",
    "uf-etl-n",
    "uf-etl-p",
    "uf-data-warehouse-d",
    "uf-data-warehouse-n",
    "uf-data-warehouse-p"
  ]

  metrics_scope = local.project_id

  composer_env_name_dev   = "composer-dev"
  composer_project_id_dev = "uf-etl-d"
  notification_channels   = ["projects/uf-bq-admin-p/notificationChannels/13071497029549002907"]

  alert_policies = [
    {
      display_name              = "Composer Database Health Alert for Dev Environment"
      documentation_content     = "Cloud Composer Database Health is degraded less than 95% in last 4 hours rolling window for Dev Environment\n"
      documentation_mime_type   = "text/markdown"
      documentation_subject     = "Cloud Composer Database Health Degraded for Dev Environment"
      filter                    = "resource.type = \"cloud_composer_environment\" AND resource.labels.project_id = \"__COMPOSER_PROJECT_ID_DEV__\" AND resource.labels.environment_name = \"__COMPOSER_ENV_NAME_DEV__\" AND metric.type = \"composer.googleapis.com/environment/database_health\""
      alignment_period          = "14400s"
      cross_series_reducer      = "REDUCE_NONE"
      per_series_aligner        = "ALIGN_FRACTION_TRUE"
      comparison                = "COMPARISON_LT"
      duration                  = "0s"
      threshold_value           = 0.95
      alert_strategy_auto_close = "604800s"
      severity                  = "CRITICAL"
    },
    {
      display_name              = "Composer Environment Health Alert for Dev Environment"
      documentation_content     = "Cloud Composer Environment Health has degraded less than 90% in last 4 hours rolling window for Dev Environment\n"
      documentation_mime_type   = "text/markdown"
      documentation_subject     = "Cloud Composer Environment Health Degraded for Dev Environment"
      filter                    = "resource.type = \"cloud_composer_environment\" AND resource.labels.project_id = \"__COMPOSER_PROJECT_ID_DEV__\" AND resource.labels.environment_name = \"__COMPOSER_ENV_NAME_DEV__\" AND metric.type = \"composer.googleapis.com/environment/healthy\""
      alignment_period          = "14400s"
      cross_series_reducer      = "REDUCE_NONE"
      per_series_aligner        = "ALIGN_FRACTION_TRUE"
      comparison                = "COMPARISON_LT"
      duration                  = "0s"
      threshold_value           = 0.9
      alert_strategy_auto_close = "604800s"
      severity                  = "CRITICAL"
    },
    {
      display_name              = "Cloud Composer Web Server Alert for Dev Environment"
      documentation_content     = "Cloud Composer Web Server Health has degraded less than 90% in last 4 hours rolling window for Dev Environment\n"
      documentation_mime_type   = "text/markdown"
      documentation_subject     = "Cloud Composer WebServer Health Degraded for Dev Environment"
      filter                    = "resource.type = \"cloud_composer_environment\" AND resource.labels.project_id = \"__COMPOSER_PROJECT_ID_DEV__\" AND resource.labels.environment_name = \"__COMPOSER_ENV_NAME_DEV__\" AND metric.type = \"composer.googleapis.com/environment/web_server/health\""
      alignment_period          = "14400s"
      cross_series_reducer      = "REDUCE_NONE"
      per_series_aligner        = "ALIGN_FRACTION_TRUE"
      comparison                = "COMPARISON_LT"
      duration                  = "0s"
      threshold_value           = 0.9
      alert_strategy_auto_close = "604800s"
      severity                  = "CRITICAL"
    },
    {
      display_name              = "Cloud Composer Database CPU Usage Alert for Dev Environment"
      documentation_content     = "Cloud Composer Database CPU Usage is more than 80% on average in last 12 hours window for Dev Environment"
      documentation_mime_type   = "text/markdown"
      documentation_subject     = "Cloud Composer Database CPU Usage for Dev Environment"
      filter                    = "resource.type = \"cloud_composer_environment\" AND resource.labels.project_id = \"__COMPOSER_PROJECT_ID_DEV__\" AND resource.labels.environment_name = \"__COMPOSER_ENV_NAME_DEV__\" AND metric.type = \"composer.googleapis.com/environment/database/cpu/utilization\""
      alignment_period          = "43200s"
      cross_series_reducer      = "REDUCE_NONE"
      per_series_aligner        = "ALIGN_MEAN"
      comparison                = "COMPARISON_GT"
      duration                  = "0s"
      threshold_value           = 0.8
      alert_strategy_auto_close = "604800s"
      severity                  = "CRITICAL"
    },
    {
      display_name              = "Cloud Composer Database Memory Usage Alert for Dev Environment"
      documentation_content     = "Cloud Composer Database Memory Usage is more than 80% on average in last 12 hours window for Dev Environment"
      documentation_mime_type   = "text/markdown"
      documentation_subject     = "Cloud Composer Database Memory Usage for Dev Environment"
      filter                    = "resource.type = \"cloud_composer_environment\" AND resource.labels.project_id = \"__COMPOSER_PROJECT_ID_DEV__\" AND resource.labels.environment_name = \"__COMPOSER_ENV_NAME_DEV__\" AND metric.type = \"composer.googleapis.com/environment/database/memory/utilization\""
      alignment_period          = "43200s"
      cross_series_reducer      = "REDUCE_NONE"
      per_series_aligner        = "ALIGN_MEAN"
      comparison                = "COMPARISON_GT"
      duration                  = "0s"
      threshold_value           = 0.8
      alert_strategy_auto_close = "604800s"
      severity                  = "CRITICAL"
    }
  ]
}

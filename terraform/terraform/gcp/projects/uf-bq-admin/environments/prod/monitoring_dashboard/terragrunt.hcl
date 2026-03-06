# Include GCP configuration
include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

# Terraform configuration source
terraform {
  source = "../../../modules/monitoring_dashboard"
}

inputs = {
  project_id = include.gcp.locals.project_id
  views = {
    "current_assignments" = {
      dataset_id = "uf_bq_monitoring"
      table_id   = "current_assignments"
      query      = file("sql_queries/current_assignments.sql")
    },
    "daily_commitments" = {
      dataset_id = "uf_bq_monitoring"
      table_id   = "daily_commitments"
      query      = file("sql_queries/daily_commitments.sql")
    },
    "daily_utilization" = {
      dataset_id = "uf_bq_monitoring"
      table_id   = "daily_utilization"
      query      = file("sql_queries/daily_utilization.sql")
    },
    "hourly_utilization" = {
      dataset_id = "uf_bq_monitoring"
      table_id   = "hourly_utilization"
      query      = file("sql_queries/hourly_utilization.sql")
    },
    "job_analyser_slow" = {
      dataset_id = "uf_bq_monitoring"
      table_id   = "job_analyser_slow"
      query      = file("sql_queries/job_analyser_slow.sql")
    },
    "job_comparision_statistics" = {
      dataset_id = "uf_bq_monitoring"
      table_id   = "job_comparision_statistics"
      query      = file("sql_queries/job_comparision_statistics.sql")
    },
    "job_concurrency_comparisions_slow" = {
      dataset_id = "uf_bq_monitoring"
      table_id   = "job_concurrency_comparisions_slow"
      query      = file("sql_queries/job_concurrency_comparisions_slow.sql")
    },
    "job_error" = {
      dataset_id = "uf_bq_monitoring"
      table_id   = "job_error"
      query      = file("sql_queries/job_error.sql")
    },
    "job_execution" = {
      dataset_id = "uf_bq_monitoring"
      table_id   = "job_execution"
      query      = file("sql_queries/job_execution.sql")
    },
    "reservation_utilization_month" = {
      dataset_id = "uf_bq_monitoring"
      table_id   = "reservation_utilization_month"
      query      = file("sql_queries/reservation_utilization_month.sql")
    },
    "reservation_utilization_week" = {
      dataset_id = "uf_bq_monitoring"
      table_id   = "reservation_utilization_week"
      query      = file("sql_queries/reservation_utilization_week.sql")
    }
  }
}

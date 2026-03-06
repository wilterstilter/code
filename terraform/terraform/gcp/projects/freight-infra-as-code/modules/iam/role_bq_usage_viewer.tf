module "role_bq_usage_viewer" {
  source  = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version = "~> 7.7.1"

  target_level = "org"
  target_id    = var.organization_id
  role_id      = "bqUsageViewer"
  title        = "BigQuery Usage Viewer"
  description  = "Allows read only access to org wide BQ usages"
  permissions = [
    "bigquery.bireservations.get",
    "bigquery.capacityCommitments.get",
    "bigquery.capacityCommitments.list",
    "bigquery.config.get",
    "bigquery.connections.list",
    "bigquery.datasets.get",
    "bigquery.jobs.get",
    "bigquery.jobs.list",
    "bigquery.jobs.listAll",
    "bigquery.jobs.listExecutionMetadata",
    "bigquery.models.getMetadata",
    "bigquery.models.list",
    "bigquery.reservationAssignments.list",
    "bigquery.reservationAssignments.search",
    "bigquery.reservationGroups.get",
    "bigquery.reservationGroups.list",
    "bigquery.reservations.get",
    "bigquery.reservations.list",
    "bigquery.reservations.listFailoverDatasets",
    "bigquery.savedqueries.list",
    "bigquery.transfers.get",
    "bigquery.routines.get",
    "bigquery.routines.list",
    "bigquery.tables.get",
    "bigquery.tables.getIamPolicy",
    "bigquery.tables.list",
  ]
}

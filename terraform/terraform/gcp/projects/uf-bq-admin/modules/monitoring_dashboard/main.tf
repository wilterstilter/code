resource "google_bigquery_table" "view" {
  for_each            = var.views
  dataset_id          = each.value.dataset_id
  table_id            = each.value.table_id
  project             = var.project_id
  deletion_protection = false

  view {
    query          = each.value.query
    use_legacy_sql = false
  }

  lifecycle {
    ignore_changes = [
      encryption_configuration # managed by google_bigquery_dataset.main.default_encryption_configuration
    ]
  }
}

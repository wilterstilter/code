# Dataset/Namespace creation for BigQuery
resource "google_bigquery_dataset" "datasets" {
  for_each                    = { for dataset in var.datasets : dataset.dataset_id => dataset }
  dataset_id                  = each.value.dataset_id
  friendly_name               = "${upper(each.value.dataset_id)} Dataset - ${each.value.layer}"
  description                 = each.value.description
  location                    = var.region
  default_table_expiration_ms = each.value.default_table_expiration_ms
  max_time_travel_hours       = 72
  is_case_insensitive         = each.value.is_case_insensitive
  labels = merge(var.bq_labels, var.base_labels, {
    "env" : var.env
  })
}

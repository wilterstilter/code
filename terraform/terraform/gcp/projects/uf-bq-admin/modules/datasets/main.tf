# Dataset/Namespace creation for BigQuery
resource "google_bigquery_dataset" "datasets" {
  for_each                    = { for dataset in var.datasets : dataset.dataset_id => dataset }
  dataset_id                  = each.value.dataset_id
  friendly_name               = "${upper(each.value.dataset_id)} Dataset - ${each.value.layer}"
  description                 = each.value.description
  location                    = each.value.location
  default_table_expiration_ms = each.value.default_table_expiration_ms
  max_time_travel_hours       = 72
  is_case_insensitive         = each.value.is_case_insensitive
  labels = merge(var.bq_labels, var.base_labels, {
    "env" : var.env
  })
}

# Permission set up for datasets/namespaces created in bigquery for different roles and entities
locals {
  permissions = flatten([
    for dataset in var.datasets : [
      for role, control in dataset.controls : {
        dataset_id     = dataset.dataset_id,
        control_role   = role,
        control_entity = control.entities
      }
    ]
  ])
}

# BigQuery dataset IAM bindings
resource "google_bigquery_dataset_iam_binding" "namespace_binding" {
  for_each = {
    for p in local.permissions :
    "${p.dataset_id}-${p.control_role}" => p
  }
  dataset_id = each.value.dataset_id
  role       = each.value.control_role
  members    = each.value.control_entity
  depends_on = [google_bigquery_dataset.datasets]
}

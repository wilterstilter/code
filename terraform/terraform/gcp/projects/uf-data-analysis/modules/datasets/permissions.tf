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

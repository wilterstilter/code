locals {
  bucket_permissions = flatten([
    for b in var.buckets : [
      for role, control in b.controls : {
        bucket_name = b.name
        role        = role
        members     = control.entities
      }
    ]
  ])
}

resource "google_storage_bucket_iam_binding" "bucket_binding" {
  for_each = {
    for p in local.bucket_permissions :
    "${p.bucket_name}-${p.role}" => p
  }

  bucket  = each.value.bucket_name
  role    = each.value.role
  members = each.value.members

  depends_on = [google_storage_bucket.buckets]
}

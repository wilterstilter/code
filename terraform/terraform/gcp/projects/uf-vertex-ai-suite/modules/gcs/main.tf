resource "google_storage_bucket" "buckets" {
  for_each = { for b in var.buckets : b.name => b }

  name          = each.value.name
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  project                     = var.project_id

  versioning {
    enabled = true
  }

}

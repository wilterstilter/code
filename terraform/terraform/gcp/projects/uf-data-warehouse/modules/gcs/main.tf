resource "google_storage_bucket" "buckets" {
  for_each = toset(var.buckets)

  name          = each.key
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  versioning {
    enabled = true
  }
}
# Reference existing bucket when create_bucket = false
data "google_storage_bucket" "existing_bucket" {
  count   = var.create_bucket ? 0 : 1
  name    = var.bucket_name
  project = var.project_id
}

# Create new bucket when create_bucket = true
resource "google_storage_bucket" "cloud_storage_bucket" {
  count         = var.create_bucket ? 1 : 0
  project       = var.project_id
  name          = var.bucket_name
  location      = var.location
  storage_class = var.storage_class

  uniform_bucket_level_access = true
  force_destroy               = var.allow_destroy && var.force_destroy

  versioning {
    enabled = var.enable_versioning
  }

  soft_delete_policy {
    retention_duration_seconds = 604800 # 7 days
  }

  labels = merge(
    {
      managed-by = "terraform"
    },
    var.bucket_labels
  )

}

# GCS Bucket for shared access across GKE clusters
resource "google_storage_bucket" "cloud_storage_bucket" {
  count         = var.create_bucket ? 1 : 0
  project       = var.project_id
  name          = var.bucket_name
  location      = var.location
  storage_class = var.storage_class

  uniform_bucket_level_access = true
  force_destroy               = var.force_destroy

  versioning {
    enabled = var.enable_versioning
  }

  labels = {
    managed-by = "terraform"
    purpose    = "parcel-api-edge-svc-shared-storage"
  }

  lifecycle {
    prevent_destroy = true
  }
}
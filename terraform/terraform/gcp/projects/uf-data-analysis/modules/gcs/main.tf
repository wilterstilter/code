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

resource "google_project_iam_binding" "bucket_users" {
  project = var.project_id
  role    = "roles/storage.objectUser"
  members = var.bucket_users
}

resource "google_project_iam_binding" "bucket_viewers" {
  project = var.project_id
  role    = "roles/storage.bucketViewer"
  members = var.bucket_viewers
}

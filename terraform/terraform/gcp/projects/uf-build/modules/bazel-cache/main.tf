resource "google_storage_bucket" "default" {
  name                        = "uf-bzl-${var.name}"
  location                    = var.region
  force_destroy               = true
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "service_accounts" {
  for_each = toset(var.service_accounts)

  bucket = google_storage_bucket.default.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${each.key}"
}

resource "google_storage_bucket_iam_member" "grous" {
  for_each = toset(var.groups)

  bucket = google_storage_bucket.default.name
  role   = "roles/storage.objectAdmin"
  member = "group:${each.key}"
}

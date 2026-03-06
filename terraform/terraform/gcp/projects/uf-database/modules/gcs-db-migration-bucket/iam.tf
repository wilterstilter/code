# IAM Resources for GCS Migration Module
# Service account and permissions for on-prem to GCS data migration

#------------------------------------------------------------------------------
# Service Account for On-Prem Data Upload
# This SA will be used from on-prem to upload data to GCS
#------------------------------------------------------------------------------

resource "google_service_account" "migration_uploader" {
  project      = var.project_id
  account_id   = "sa-migration-uploader"
  display_name = "Migration Data Uploader"
  description  = "Service account for uploading migration data from on-prem to GCS. Minimal permissions following least privilege principle."
}

#------------------------------------------------------------------------------
# Bucket-Level IAM Binding for Upload Service Account
# Grant only the permissions needed for uploading data
#------------------------------------------------------------------------------

# Option 1: Storage Object Creator - Can only create objects (most restrictive)
resource "google_storage_bucket_iam_member" "migration_uploader_creator" {
  count = var.uploader_permission_level == "creator" ? 1 : 0

  bucket = google_storage_bucket.migration.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.migration_uploader.email}"
}

# Option 2: Storage Object Admin - Can create, read, update, delete objects
resource "google_storage_bucket_iam_member" "migration_uploader_admin" {
  count = var.uploader_permission_level == "admin" ? 1 : 0

  bucket = google_storage_bucket.migration.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.migration_uploader.email}"
}

# Additional: Storage Legacy Bucket Reader - Allows listing bucket contents
resource "google_storage_bucket_iam_member" "migration_uploader_reader" {
  count = var.enable_bucket_listing ? 1 : 0

  bucket = google_storage_bucket.migration.name
  role   = "roles/storage.legacyBucketReader"
  member = "serviceAccount:${google_service_account.migration_uploader.email}"
}

#------------------------------------------------------------------------------
# Service Account Key for On-Prem Authentication
# This key will be downloaded and used from on-prem systems
# WARNING: Keys should be rotated regularly and stored securely
#------------------------------------------------------------------------------

resource "google_service_account_key" "migration_uploader_key" {
  count = var.create_service_account_key ? 1 : 0

  service_account_id = google_service_account.migration_uploader.name
  public_key_type    = "TYPE_X509_PEM_FILE"

  # Keys expire after 90 days as a security best practice
  # Commented out as rotation needs manual process
  # keepers = {
  #   rotation_time = "${var.key_rotation_time}"
  # }
}

#------------------------------------------------------------------------------
# Service Account for Cloud SQL to Read Migration Data
# CloudSQL instance needs to read data from this bucket
#------------------------------------------------------------------------------

resource "google_service_account" "migration_reader" {
  count = var.create_cloudsql_reader_sa ? 1 : 0

  project      = var.project_id
  account_id   = "sa-migration-reader"
  display_name = "Migration Data Reader"
  description  = "Service account for Cloud SQL to read migration data from GCS bucket"
}

# Grant Storage Object Viewer permissions to read migration data
resource "google_storage_bucket_iam_member" "migration_reader" {
  count = var.create_cloudsql_reader_sa ? 1 : 0

  bucket = google_storage_bucket.migration.name
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.migration_reader[0].email}"
}

#------------------------------------------------------------------------------
# IAM Bindings for Additional Members (DB Team, Admins, etc.)
#------------------------------------------------------------------------------

locals {
  # Create a map of member-role combinations for additional access
  additional_access_bindings = flatten([
    for member in var.additional_bucket_admins : [
      {
        member = member
        role   = "roles/storage.admin" # FULL admin - can manage bucket config, objects, IAM
      }
    ]
  ])

  additional_viewer_bindings = flatten([
    for member in var.additional_bucket_viewers : [
      {
        member = member
        role   = "roles/storage.objectViewer"
      }
    ]
  ])
}

# Grant admin access to additional members (e.g., DB team)
resource "google_storage_bucket_iam_member" "additional_admins" {
  for_each = { for idx, binding in local.additional_access_bindings : idx => binding }

  bucket = google_storage_bucket.migration.name
  role   = "roles/storage.admin" # FULL bucket admin access
  member = each.value.member
}

# Grant viewer access to additional members
resource "google_storage_bucket_iam_member" "additional_viewers" {
  for_each = { for idx, binding in local.additional_viewer_bindings : idx => binding }

  bucket = google_storage_bucket.migration.name
  role   = each.value.role
  member = each.value.member
}

#------------------------------------------------------------------------------
# Project-Level Viewer Access
# Grants project viewer role so users can navigate Cloud Console UI
# This allows listing buckets in the project (storage.buckets.list)
#------------------------------------------------------------------------------

resource "google_project_iam_member" "bucket_admins_project_viewer" {
  for_each = var.grant_project_viewer ? toset(var.additional_bucket_admins) : toset([])

  project = var.project_id
  role    = "roles/viewer"
  member  = each.value
}

resource "google_project_iam_member" "bucket_viewers_project_viewer" {
  for_each = var.grant_project_viewer ? toset(var.additional_bucket_viewers) : toset([])

  project = var.project_id
  role    = "roles/viewer"
  member  = each.value
}


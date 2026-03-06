# Secret Manager Integration for GCS Migration Module
# Stores service account keys securely in Secret Manager

#------------------------------------------------------------------------------
# Store Service Account Key in Secret Manager
#------------------------------------------------------------------------------

resource "google_secret_manager_secret" "uploader_key" {
  count = var.create_service_account_key ? 1 : 0

  project   = var.project_id
  secret_id = "sa-migration-uploader-key"

  replication {
    auto {}
  }

  labels = merge(
    var.labels,
    {
      purpose    = "db-migration"
      sa_name    = "migration-uploader"
      managed_by = "terraform"
    }
  )
}

# Store the service account key as a secret version
resource "google_secret_manager_secret_version" "uploader_key" {
  count = var.create_service_account_key ? 1 : 0

  secret      = google_secret_manager_secret.uploader_key[0].id
  secret_data = base64decode(google_service_account_key.migration_uploader_key[0].private_key)
}

#------------------------------------------------------------------------------
# IAM Access to Secret Manager Secret
#------------------------------------------------------------------------------

# Grant the DB team and other authorized users access to the secret
resource "google_secret_manager_secret_iam_member" "uploader_key_accessors" {
  for_each = var.create_service_account_key ? toset(var.secret_key_accessors) : toset([])

  project   = var.project_id
  secret_id = google_secret_manager_secret.uploader_key[0].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = each.value
}

# Grant viewer permissions to see the secret exists (but not read the value)
resource "google_secret_manager_secret_iam_member" "uploader_key_viewers" {
  for_each = var.create_service_account_key ? toset(var.secret_key_viewers) : toset([])

  project   = var.project_id
  secret_id = google_secret_manager_secret.uploader_key[0].secret_id
  role      = "roles/secretmanager.secretViewer"
  member    = each.value
}

#------------------------------------------------------------------------------
# Optional: Store Cloud SQL Reader Key in Secret Manager
#------------------------------------------------------------------------------

resource "google_secret_manager_secret" "reader_key" {
  count = var.create_cloudsql_reader_sa && var.create_cloudsql_reader_key ? 1 : 0

  project   = var.project_id
  secret_id = "sa-migration-reader-key"

  replication {
    auto {}
  }

  labels = merge(
    var.labels,
    {
      purpose    = "db-migration"
      sa_name    = "migration-reader"
      managed_by = "terraform"
    }
  )
}

# Create key for reader SA if needed
resource "google_service_account_key" "migration_reader_key" {
  count = var.create_cloudsql_reader_sa && var.create_cloudsql_reader_key ? 1 : 0

  service_account_id = google_service_account.migration_reader[0].name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_secret_manager_secret_version" "reader_key" {
  count = var.create_cloudsql_reader_sa && var.create_cloudsql_reader_key ? 1 : 0

  secret      = google_secret_manager_secret.reader_key[0].id
  secret_data = base64decode(google_service_account_key.migration_reader_key[0].private_key)
}


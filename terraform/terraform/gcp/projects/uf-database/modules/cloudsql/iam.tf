# IAM Resources for Cloud SQL Module
# Service accounts and permissions for Cloud SQL operations

#------------------------------------------------------------------------------
# Cloud SQL Service Agent
# This creates/ensures the Google-managed Cloud SQL service agent exists
# The service agent is auto-created when Cloud SQL Admin API is enabled
#------------------------------------------------------------------------------

resource "google_project_service_identity" "cloudsql_sa" {
  provider = google-beta
  project  = var.project_id
  service  = "sqladmin.googleapis.com"
}

#------------------------------------------------------------------------------
# Service Account for Cloud SQL Instance Operations
#------------------------------------------------------------------------------

resource "google_service_account" "cloudsql" {
  project      = var.project_id
  account_id   = "sa-cloudsql-${var.instance_name}"
  display_name = "Service Account for Cloud SQL ${var.instance_name}"
  description  = "Service account for Cloud SQL instance operations for ${var.instance_name}"
}

#------------------------------------------------------------------------------
# Service Account for Cloud SQL Administration
#------------------------------------------------------------------------------

resource "google_service_account" "cloudsql_admin" {
  project      = var.project_id
  account_id   = "sa-cloudsql-admin-${var.instance_name}"
  display_name = "Service Account for Cloud SQL Admin ${var.instance_name}"
  description  = "Service account for Cloud SQL administration and management operations for ${var.instance_name}"
}

#------------------------------------------------------------------------------
# IAM Bindings for Admin Service Account
#------------------------------------------------------------------------------

# Grant Database Migration Admin role
resource "google_project_iam_member" "cloudsql_admin_datamigration" {
  project = var.project_id
  role    = "roles/datamigration.admin"
  member  = "serviceAccount:${google_service_account.cloudsql_admin.email}"
}

# Grant Storage Admin role
resource "google_project_iam_member" "cloudsql_admin_storage" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.cloudsql_admin.email}"
}

# Grant Cloud SQL Editor role
resource "google_project_iam_member" "cloudsql_admin_editor" {
  project = var.project_id
  role    = "roles/cloudsql.editor"
  member  = "serviceAccount:${google_service_account.cloudsql_admin.email}"
}

# Grant Cloud SQL Studio User role
resource "google_project_iam_member" "cloudsql_admin_studio" {
  project = var.project_id
  role    = "roles/cloudsql.studioUser"
  member  = "serviceAccount:${google_service_account.cloudsql_admin.email}"
}

# Grant Secret Manager Secret Accessor role to access database credentials
resource "google_project_iam_member" "cloudsql_admin_secrets" {
  project = var.project_id
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.cloudsql_admin.email}"
}

#------------------------------------------------------------------------------
# Shared VPC IAM - Required for Cloud SQL to use Shared VPC networking
# Uses the service identity to ensure the service agent exists first
#------------------------------------------------------------------------------

# Grant Cloud SQL service agent access to the Shared VPC host project
# This is required for Cloud SQL to create network resources
resource "google_project_iam_member" "cloudsql_network_user" {
  project = var.host_project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:${google_project_service_identity.cloudsql_sa.email}"
}

# For PSC, the Cloud SQL service agent needs to manage PSC connections
resource "google_project_iam_member" "cloudsql_psc_service_agent" {
  count = var.connectivity_type == "PSC" ? 1 : 0

  project = var.host_project_id
  role    = "roles/servicenetworking.serviceAgent"
  member  = "serviceAccount:${google_project_service_identity.cloudsql_sa.email}"
}

#------------------------------------------------------------------------------
# DB Admin Access - IAM bindings for database administrators
# Grants connectivity and viewing WITHOUT infrastructure modification rights
#------------------------------------------------------------------------------

locals {
  db_admin_roles = [
    "roles/cloudsql.client",              # Connect to database
    "roles/cloudsql.viewer",              # View instance in Console (read-only)
    "roles/cloudsql.studioUser",          # Use Cloud SQL Studio
    "roles/secretmanager.secretAccessor", # Read credentials from Secret Manager
    "roles/secretmanager.viewer"
  ]

  # Create a map of member-role combinations
  db_admin_bindings = {
    for pair in setproduct(var.db_admins, local.db_admin_roles) :
    "${pair[0]}-${pair[1]}" => {
      member = pair[0]
      role   = pair[1]
    }
  }
}

resource "google_project_iam_member" "db_admin" {
  for_each = local.db_admin_bindings

  project = var.project_id
  role    = each.value.role
  member  = each.value.member
}

#------------------------------------------------------------------------------
# DB Import Admin Access - IAM bindings for users who need to import/export data
# Uses a custom role with ONLY import/export permissions (least privilege)
#------------------------------------------------------------------------------

# Custom role for import/export operations only
resource "google_project_iam_custom_role" "cloudsql_importer" {
  count = length(var.db_import_admins) > 0 ? 1 : 0

  project     = var.project_id
  role_id     = "cloudsql_data_importer_${replace(var.instance_name, "-", "_")}"
  title       = "Cloud SQL Data Importer (${var.instance_name})"
  description = "Minimal permissions for importing/exporting data to Cloud SQL instance ${var.instance_name}"

  permissions = [
    "cloudsql.instances.import", # Import data from GCS
    "cloudsql.instances.export", # Export data to GCS
    "cloudsql.instances.get",    # View instance details (required for import/export)
    "cloudsql.backups.create",   # Create backup before import (safety)
    "cloudsql.backups.get",      # View backup status
  ]
}

# Grant the custom role to users who need import access
resource "google_project_iam_member" "db_import_admin" {
  for_each = toset(var.db_import_admins)

  project = var.project_id
  role    = google_project_iam_custom_role.cloudsql_importer[0].id
  member  = each.value
}

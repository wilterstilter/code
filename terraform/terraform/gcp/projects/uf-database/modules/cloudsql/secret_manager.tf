# Secret Manager resources for database credentials

# Store root password in Secret Manager (SQL Server only)
resource "google_secret_manager_secret" "root_password" {
  count = can(regex("^SQLSERVER_", var.database_version)) ? 1 : 0

  project   = var.project_id
  secret_id = "cloudsql-${var.instance_name}-root-password"

  labels = merge(var.labels, {
    database_instance = var.instance_name
    credential_type   = "root-password"
  })

  replication {
    auto {}
  }

  depends_on = [google_sql_database_instance.instance]
}

resource "google_secret_manager_secret_version" "root_password" {
  count = can(regex("^SQLSERVER_", var.database_version)) ? 1 : 0

  secret      = google_secret_manager_secret.root_password[0].id
  secret_data = random_password.root_password[0].result
}

# Generate random password for database users if not provided
resource "random_password" "db_passwords" {
  for_each = { for k, v in var.users : k => v if v.password == null || v.password == "" }

  length  = 32
  special = true
  # SQL Server password requirements
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
}

# Create secrets for database usernames
resource "google_secret_manager_secret" "db_usernames" {
  for_each = var.users

  project   = var.project_id
  secret_id = "cloudsql-${var.instance_name}-${each.key}-username"

  labels = merge(var.labels, {
    database_instance = var.instance_name
    credential_type   = "username"
  })

  replication {
    auto {}
  }

  depends_on = [google_sql_database_instance.instance]
}

# Store the username in Secret Manager
resource "google_secret_manager_secret_version" "db_username_versions" {
  for_each = var.users

  secret      = google_secret_manager_secret.db_usernames[each.key].id
  secret_data = each.key
}

# Create secrets for database passwords
resource "google_secret_manager_secret" "db_passwords" {
  for_each = var.users

  project   = var.project_id
  secret_id = "cloudsql-${var.instance_name}-${each.key}-password"

  labels = merge(var.labels, {
    database_instance = var.instance_name
    credential_type   = "password"
  })

  replication {
    auto {}
  }

  depends_on = [google_sql_database_instance.instance]
}

# Store the password in Secret Manager
resource "google_secret_manager_secret_version" "db_password_versions" {
  for_each = var.users

  secret      = google_secret_manager_secret.db_passwords[each.key].id
  secret_data = each.value.password != null && each.value.password != "" ? each.value.password : random_password.db_passwords[each.key].result
}

# Grant Cloud SQL service account access to username secrets
resource "google_secret_manager_secret_iam_member" "cloudsql_username_accessor" {
  for_each = var.users

  project   = var.project_id
  secret_id = google_secret_manager_secret.db_usernames[each.key].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloudsql.email}"
}

# Grant Cloud SQL service account access to password secrets
resource "google_secret_manager_secret_iam_member" "cloudsql_password_accessor" {
  for_each = var.users

  project   = var.project_id
  secret_id = google_secret_manager_secret.db_passwords[each.key].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloudsql.email}"
}

# Grant Cloud SQL admin service account access to username secrets
resource "google_secret_manager_secret_iam_member" "cloudsql_admin_username_accessor" {
  for_each = var.users

  project   = var.project_id
  secret_id = google_secret_manager_secret.db_usernames[each.key].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloudsql_admin.email}"
}

# Grant Cloud SQL admin service account access to password secrets
resource "google_secret_manager_secret_iam_member" "cloudsql_admin_password_accessor" {
  for_each = var.users

  project   = var.project_id
  secret_id = google_secret_manager_secret.db_passwords[each.key].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.cloudsql_admin.email}"
}

# Cloud SQL Instance Outputs

#------------------------------------------------------------------------------
# Instance Information
#------------------------------------------------------------------------------

output "instance_name" {
  description = "The name of the Cloud SQL instance"
  value       = google_sql_database_instance.instance.name
}

output "instance_connection_name" {
  description = "The connection name of the instance to be used in connection strings"
  value       = google_sql_database_instance.instance.connection_name
}

output "instance_self_link" {
  description = "The URI of the created instance"
  value       = google_sql_database_instance.instance.self_link
}

#------------------------------------------------------------------------------
# Network/Connection Information
#------------------------------------------------------------------------------

output "connectivity_type" {
  description = "The type of private connectivity used (PSA or PSC)"
  value       = var.connectivity_type
}

# PSA Outputs
output "instance_private_ip_address" {
  description = "The private IP address assigned to the instance (PSA only)"
  value       = var.connectivity_type == "PSA" ? google_sql_database_instance.instance.private_ip_address : null
}

output "instance_first_ip_address" {
  description = "The first IP address assigned to the instance"
  value       = google_sql_database_instance.instance.first_ip_address
}

# PSC Outputs
output "psc_service_attachment_link" {
  description = "The PSC service attachment URI for the Cloud SQL instance (PSC only)"
  value       = var.connectivity_type == "PSC" ? google_sql_database_instance.instance.psc_service_attachment_link : null
}

output "psc_endpoint_ip" {
  description = "The private IP address of the PSC endpoint to use for connections (PSC only)"
  value       = var.connectivity_type == "PSC" ? google_compute_address.psc_endpoint_ip[0].address : null
}

output "psc_endpoint_name" {
  description = "The name of the PSC forwarding rule/endpoint (PSC only)"
  value       = var.connectivity_type == "PSC" ? google_compute_forwarding_rule.psc_endpoint[0].name : null
}

# Unified connection endpoint - use this for connecting to the database
output "connection_endpoint" {
  description = "The IP address to use for connecting to the database (works for both PSA and PSC)"
  value       = var.connectivity_type == "PSC" ? google_compute_address.psc_endpoint_ip[0].address : google_sql_database_instance.instance.private_ip_address
}

#------------------------------------------------------------------------------
# Database Information
#------------------------------------------------------------------------------

output "database_names" {
  description = "List of database names created"
  value       = [for db in google_sql_database.databases : db.name]
}

#------------------------------------------------------------------------------
# Service Account Information
#------------------------------------------------------------------------------

output "cloudsql_service_agent_email" {
  description = "Email of the Cloud SQL service agent (Google-managed)"
  value       = google_project_service_identity.cloudsql_sa.email
}

output "cloudsql_admin_service_account_email" {
  description = "Email of the service account for Cloud SQL administration and management"
  value       = google_service_account.cloudsql_admin.email
}

output "cloudsql_service_account_email" {
  description = "Email of the service account for Cloud SQL operations"
  value       = google_service_account.cloudsql.email
}

#------------------------------------------------------------------------------
# Secret Manager Information
#------------------------------------------------------------------------------

output "secret_ids" {
  description = "Map of username to Secret Manager secret IDs containing passwords"
  value = {
    for k, v in google_secret_manager_secret.db_passwords : k => v.id
  }
  sensitive = true
}

output "root_password_secret" {
  description = "Secret Manager secret name for the root password (SQL Server only)"
  value       = can(regex("^SQLSERVER_", var.database_version)) ? google_secret_manager_secret.root_password[0].secret_id : null
}

output "secret_names" {
  description = "Map of username to Secret Manager secret names (username and password)"
  value = {
    for k, v in var.users : k => {
      username_secret = google_secret_manager_secret.db_usernames[k].secret_id
      password_secret = google_secret_manager_secret.db_passwords[k].secret_id
    }
  }
}

#------------------------------------------------------------------------------
# Connection String Helpers
#------------------------------------------------------------------------------

output "connection_info" {
  description = "Connection information for applications"
  value = {
    host              = var.connectivity_type == "PSC" ? google_compute_address.psc_endpoint_ip[0].address : google_sql_database_instance.instance.private_ip_address
    port              = can(regex("^SQLSERVER_", var.database_version)) ? 1433 : (can(regex("^POSTGRES_", var.database_version)) ? 5432 : 3306)
    instance_name     = google_sql_database_instance.instance.name
    connection_name   = google_sql_database_instance.instance.connection_name
    connectivity_type = var.connectivity_type
  }
}

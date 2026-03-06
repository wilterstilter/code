# Cloud SQL Instance Module for GCP with Shared VPC
# Supports both PSA (Private Service Access) and PSC (Private Service Connect)

# Generate a random suffix for the instance name to avoid conflicts on recreation
resource "random_id" "db_name_suffix" {
  byte_length = 4
}

# Generate root password for SQL Server (required)
resource "random_password" "root_password" {
  count = can(regex("^SQLSERVER_", var.database_version)) ? 1 : 0

  length      = 32
  special     = true
  min_lower   = 1
  min_upper   = 1
  min_numeric = 1
  min_special = 1
}

# Create Cloud SQL instance
resource "google_sql_database_instance" "instance" {
  project          = var.project_id
  name             = "${var.instance_name}-${random_id.db_name_suffix.hex}"
  database_version = var.database_version
  region           = var.region

  # Root password - required for SQL Server
  root_password = can(regex("^SQLSERVER_", var.database_version)) ? random_password.root_password[0].result : null

  # Deletion protection
  deletion_protection = var.deletion_protection

  settings {
    tier              = var.tier
    availability_type = var.availability_type
    disk_type         = var.disk_type
    disk_size         = var.disk_size
    disk_autoresize   = var.disk_autoresize
    edition           = var.edition # Enterprise Plus for 99.99% SLA

    # Data cache for Enterprise Plus
    dynamic "data_cache_config" {
      for_each = var.data_cache_enabled ? [1] : []
      content {
        data_cache_enabled = true
      }
    }

    # Backup configuration for 99.99% SLA
    backup_configuration {
      enabled                        = var.backup_enabled
      point_in_time_recovery_enabled = var.point_in_time_recovery_enabled
      start_time                     = var.backup_start_time
      transaction_log_retention_days = var.transaction_log_retention_days

      backup_retention_settings {
        retained_backups = var.retained_backups
        retention_unit   = "COUNT"
      }
    }

    # IP configuration - supports both PSA and PSC
    ip_configuration {
      ipv4_enabled = var.ipv4_enabled

      # PSA (Private Service Access) configuration
      # Only set when using PSA connectivity
      private_network    = var.connectivity_type == "PSA" ? var.network : null
      allocated_ip_range = var.connectivity_type == "PSA" ? var.psa_allocated_ip_range_name : null

      # Note: Private path for Google Services is NOT supported on SQL Server
      enable_private_path_for_google_cloud_services = can(regex("^SQLSERVER_", var.database_version)) ? false : var.enable_private_path_for_google_cloud_services
      ssl_mode                                      = var.ssl_mode
      require_ssl                                   = var.require_ssl

      # PSC (Private Service Connect) configuration
      # Only set when using PSC connectivity
      dynamic "psc_config" {
        for_each = var.connectivity_type == "PSC" ? [1] : []
        content {
          psc_enabled               = true
          allowed_consumer_projects = var.psc_allowed_consumer_projects
        }
      }

      # Authorized networks (if public IP is enabled)
      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          name  = authorized_networks.value.name
          value = authorized_networks.value.cidr
        }
      }
    }

    # Maintenance window
    maintenance_window {
      day          = var.maintenance_window_day
      hour         = var.maintenance_window_hour
      update_track = var.maintenance_window_update_track
    }

    # Insights configuration
    insights_config {
      query_insights_enabled  = var.query_insights_enabled
      query_plans_per_minute  = var.query_plans_per_minute
      query_string_length     = var.query_string_length
      record_application_tags = var.record_application_tags
    }

    # Database flags
    dynamic "database_flags" {
      for_each = var.database_flags
      content {
        name  = database_flags.value.name
        value = database_flags.value.value
      }
    }

    # User labels
    user_labels = var.labels
  }

  # Lifecycle management
  lifecycle {
    ignore_changes = [
      settings[0].disk_size, # Allow disk to grow
    ]
  }

  depends_on = [
    # Only depend on PSA connection when using PSA
    google_service_networking_connection.private_vpc_connection
  ]
}

#------------------------------------------------------------------------------
# PSA (Private Service Access) Resources
# Only created when connectivity_type = "PSA"
#------------------------------------------------------------------------------

# Allocate IP range for Private Service Access (PSA)
# Note: For Shared VPC, this must be created in the HOST project
resource "google_compute_global_address" "private_ip_address" {
  count = var.connectivity_type == "PSA" && var.psa_create_ip_allocation ? 1 : 0

  project       = var.host_project_id # Must be in host project where VPC is
  name          = "cloudsql-${var.instance_name}-psa"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = var.psa_ip_range_prefix_length
  address       = var.psa_ip_address
  network       = var.network
}

# Create Service Networking Connection for PSA
# Note: Only ONE connection can exist per VPC. If one already exists, 
# set psa_create_connection = false and provide psa_allocated_ip_range_name
resource "google_service_networking_connection" "private_vpc_connection" {
  count = var.connectivity_type == "PSA" && var.psa_create_connection ? 1 : 0

  network = var.network
  service = "servicenetworking.googleapis.com"
  reserved_peering_ranges = var.psa_create_ip_allocation ? [
    google_compute_global_address.private_ip_address[0].name
  ] : [var.psa_allocated_ip_range_name]

  depends_on = [google_compute_global_address.private_ip_address]
}

#------------------------------------------------------------------------------
# PSC (Private Service Connect) Endpoint Resources
# Only created when connectivity_type = "PSC"
#------------------------------------------------------------------------------

# Get the PSC service attachment URI from the Cloud SQL instance
# The service attachment is automatically created when psc_config is enabled
locals {
  psc_service_attachment_link = var.connectivity_type == "PSC" ? try(
    google_sql_database_instance.instance.psc_service_attachment_link, null
  ) : null
}

# Create PSC endpoint in the Shared VPC (host project)
# This allows clients in the VPC to connect to Cloud SQL via a private IP
resource "google_compute_address" "psc_endpoint_ip" {
  count = var.connectivity_type == "PSC" ? 1 : 0

  project      = var.host_project_id
  name         = "cloudsql-${var.instance_name}-psc-ip"
  region       = var.region
  address_type = "INTERNAL"
  subnetwork   = var.psc_subnet
  address      = var.psc_endpoint_ip_address # Optional: specify a specific IP
}

resource "google_compute_forwarding_rule" "psc_endpoint" {
  count = var.connectivity_type == "PSC" ? 1 : 0

  project               = var.host_project_id
  name                  = "cloudsql-${var.instance_name}-psc-endpoint"
  region                = var.region
  network               = var.network
  ip_address            = google_compute_address.psc_endpoint_ip[0].id
  load_balancing_scheme = ""
  target                = local.psc_service_attachment_link

  # Allow global access so clients from any region can connect
  allow_psc_global_access = var.psc_allow_global_access

  depends_on = [google_sql_database_instance.instance]
}

#------------------------------------------------------------------------------
# Database and User Resources
#------------------------------------------------------------------------------

# Create databases
resource "google_sql_database" "databases" {
  for_each = toset(var.databases)

  project   = var.project_id
  name      = each.value
  instance  = google_sql_database_instance.instance.name
  charset   = var.database_charset
  collation = var.database_collation
}

# Create users with passwords from Secret Manager
resource "google_sql_user" "users" {
  for_each = var.users

  project  = var.project_id
  name     = each.key
  instance = google_sql_database_instance.instance.name
  # Use password from Secret Manager
  password = each.value.password != null && each.value.password != "" ? each.value.password : random_password.db_passwords[each.key].result
  type     = each.value.type

  # For BUILT_IN users (SQL Server native authentication)
  dynamic "password_policy" {
    for_each = each.value.type == "BUILT_IN" && each.value.password_policy != null ? [1] : []
    content {
      allowed_failed_attempts      = each.value.password_policy.allowed_failed_attempts
      password_expiration_duration = each.value.password_policy.password_expiration_duration
      enable_failed_attempts_check = each.value.password_policy.enable_failed_attempts_check
      enable_password_verification = each.value.password_policy.enable_password_verification
    }
  }

  depends_on = [
    google_secret_manager_secret_version.db_password_versions
  ]
}

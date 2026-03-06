# Variables for Cloud SQL Module
# Supports both PSA (Private Service Access) and PSC (Private Service Connect)

#------------------------------------------------------------------------------
# Project Configuration
#------------------------------------------------------------------------------

variable "project_id" {
  type        = string
  description = "The project ID where the Cloud SQL instance will be created (Service Project)"
}

variable "host_project_id" {
  type        = string
  description = "The project ID of the host project where the Shared VPC is located"
}

#------------------------------------------------------------------------------
# Instance Configuration
#------------------------------------------------------------------------------

variable "instance_name" {
  type        = string
  description = "The name of the Cloud SQL instance"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]*[a-z0-9]$", var.instance_name))
    error_message = "Instance name must start with a lowercase letter, contain only lowercase letters, numbers, and hyphens, and end with a lowercase letter or number."
  }
}

variable "database_version" {
  type        = string
  description = "The database version (e.g., POSTGRES_15, MYSQL_8_0, SQLSERVER_2019_STANDARD)"

  validation {
    condition     = can(regex("^(POSTGRES_|MYSQL_|SQLSERVER_)", var.database_version))
    error_message = "Database version must be a valid Cloud SQL version (e.g., POSTGRES_15, MYSQL_8_0)."
  }
}

variable "edition" {
  type        = string
  description = "The edition of the instance: ENTERPRISE, ENTERPRISE_PLUS. Use ENTERPRISE_PLUS for 99.99% SLA."
  default     = "ENTERPRISE_PLUS"

  validation {
    condition     = contains(["ENTERPRISE", "ENTERPRISE_PLUS"], var.edition)
    error_message = "Edition must be either ENTERPRISE or ENTERPRISE_PLUS."
  }
}

variable "region" {
  type        = string
  description = "The GCP region for the Cloud SQL instance"
  default     = "us-south1"
}

variable "tier" {
  type        = string
  description = "The machine type/tier for the instance (e.g., db-f1-micro, db-n1-standard-1, db-custom-2-7680)"
  default     = "db-n1-standard-1"
}

variable "availability_type" {
  type        = string
  description = "Availability type: REGIONAL (HA) or ZONAL (single zone). Use REGIONAL for 99.99% SLA."
  default     = "REGIONAL"

  validation {
    condition     = contains(["REGIONAL", "ZONAL"], var.availability_type)
    error_message = "Availability type must be either REGIONAL or ZONAL."
  }
}

variable "disk_type" {
  type        = string
  description = "The type of disk: PD_SSD or PD_HDD"
  default     = "PD_SSD"

  validation {
    condition     = contains(["PD_SSD", "PD_HDD"], var.disk_type)
    error_message = "Disk type must be either PD_SSD or PD_HDD."
  }
}

variable "disk_size" {
  type        = number
  description = "The size of the disk in GB"
  default     = 10

  validation {
    condition     = var.disk_size >= 10
    error_message = "Disk size must be at least 10 GB."
  }
}

variable "disk_autoresize" {
  type        = bool
  description = "Enable automatic disk resize"
  default     = true
}

variable "deletion_protection" {
  type        = bool
  description = "Enable deletion protection for the instance"
  default     = false
}

variable "data_cache_enabled" {
  type        = bool
  description = "Enable data cache (available with Enterprise Plus edition)"
  default     = true
}

variable "require_ssl" {
  type        = bool
  description = "Require SSL for connections"
  default     = true
}

#------------------------------------------------------------------------------
# Network Configuration - Common
#------------------------------------------------------------------------------

variable "connectivity_type" {
  type        = string
  description = "Type of private connectivity: PSA (Private Service Access) or PSC (Private Service Connect). PSC is recommended for Shared VPC."
  default     = "PSC"

  validation {
    condition     = contains(["PSA", "PSC"], var.connectivity_type)
    error_message = "Connectivity type must be either PSA or PSC."
  }
}

variable "network" {
  type        = string
  description = "The VPC network self-link (from the host project for Shared VPC)"
}

variable "ipv4_enabled" {
  type        = bool
  description = "Enable public IPv4 address. Should be false for private-only access."
  default     = false
}

variable "enable_private_path_for_google_cloud_services" {
  type        = bool
  description = "Enable private path for Google Cloud services"
  default     = true
}

variable "ssl_mode" {
  type        = string
  description = "SSL mode for connections"
  default     = "ENCRYPTED_ONLY"

  validation {
    condition = contains([
      "ALLOW_UNENCRYPTED_AND_ENCRYPTED",
      "ENCRYPTED_ONLY",
      "TRUSTED_CLIENT_CERTIFICATE_REQUIRED"
    ], var.ssl_mode)
    error_message = "SSL mode must be valid"
  }
}

variable "authorized_networks" {
  type = list(object({
    name = string
    cidr = string
  }))
  description = "List of authorized networks (only used if ipv4_enabled = true)"
  default     = []
}

#------------------------------------------------------------------------------
# PSA (Private Service Access) Configuration
# Used when connectivity_type = "PSA"
#------------------------------------------------------------------------------

variable "psa_create_ip_allocation" {
  type        = bool
  description = "Whether to create a new IP allocation for PSA. Set to false if using an existing allocation."
  default     = false
}

variable "psa_ip_address" {
  type        = string
  description = "Starting IP address for PSA range (e.g., '10.227.132.0'). Only used if psa_create_ip_allocation = true."
  default     = null
}

variable "psa_ip_range_prefix_length" {
  type        = number
  description = "Prefix length for PSA IP range (minimum /24 recommended). Only used if psa_create_ip_allocation = true."
  default     = 24
}

variable "psa_create_connection" {
  type        = bool
  description = "Whether to create the Service Networking Connection. Set to false if a connection already exists for this VPC."
  default     = false
}

variable "psa_allocated_ip_range_name" {
  type        = string
  description = "Name of an existing PSA allocated IP range to use. Required if connectivity_type = PSA and psa_create_ip_allocation = false."
  default     = null
}

#------------------------------------------------------------------------------
# PSC (Private Service Connect) Configuration
# Used when connectivity_type = "PSC"
#------------------------------------------------------------------------------

variable "psc_allowed_consumer_projects" {
  type        = list(string)
  description = "List of project IDs allowed to connect to the Cloud SQL instance via PSC. Include both the service project and any other projects that need access."
  default     = []
}

variable "psc_subnet" {
  type        = string
  description = "The subnet self-link or ID in the host project where the PSC endpoint will be created. Must be a regular subnet (not a PSC-purpose subnet)."
  default     = null
}

variable "psc_endpoint_ip_address" {
  type        = string
  description = "Optional: Specific IP address for the PSC endpoint. If not specified, an IP will be auto-allocated from the subnet."
  default     = null
}

variable "psc_allow_global_access" {
  type        = bool
  description = "Allow PSC endpoint to be accessed from any region"
  default     = true
}

#------------------------------------------------------------------------------
# Backup Configuration
#------------------------------------------------------------------------------

variable "backup_enabled" {
  type        = bool
  description = "Enable automated backups"
  default     = true
}

variable "point_in_time_recovery_enabled" {
  type        = bool
  description = "Enable point-in-time recovery (required for 99.99% SLA)"
  default     = true
}

variable "backup_start_time" {
  type        = string
  description = "Start time for the backup window (HH:MM format in UTC)"
  default     = "03:00"

  validation {
    condition     = can(regex("^([0-1][0-9]|2[0-3]):[0-5][0-9]$", var.backup_start_time))
    error_message = "Backup start time must be in HH:MM format (24-hour UTC)."
  }
}

variable "transaction_log_retention_days" {
  type        = number
  description = "Number of days to retain transaction logs for point-in-time recovery"
  default     = 7

  validation {
    condition     = var.transaction_log_retention_days >= 1 && var.transaction_log_retention_days <= 7
    error_message = "Transaction log retention days must be between 1 and 7."
  }
}

variable "retained_backups" {
  type        = number
  description = "Number of backups to retain"
  default     = 7

  validation {
    condition     = var.retained_backups >= 1 && var.retained_backups <= 365
    error_message = "Retained backups must be between 1 and 365."
  }
}

#------------------------------------------------------------------------------
# Maintenance Configuration
#------------------------------------------------------------------------------

variable "maintenance_window_day" {
  type        = number
  description = "Day of week for maintenance (1-7, where 1 is Monday and 7 is Sunday)"
  default     = 7

  validation {
    condition     = var.maintenance_window_day >= 1 && var.maintenance_window_day <= 7
    error_message = "Maintenance window day must be between 1 and 7."
  }
}

variable "maintenance_window_hour" {
  type        = number
  description = "Hour of day for maintenance (0-23 in UTC)"
  default     = 3

  validation {
    condition     = var.maintenance_window_hour >= 0 && var.maintenance_window_hour <= 23
    error_message = "Maintenance window hour must be between 0 and 23."
  }
}

variable "maintenance_window_update_track" {
  type        = string
  description = "Maintenance update track: stable or canary"
  default     = "stable"

  validation {
    condition     = contains(["stable", "canary"], var.maintenance_window_update_track)
    error_message = "Maintenance window update track must be either stable or canary."
  }
}

#------------------------------------------------------------------------------
# Query Insights Configuration
#------------------------------------------------------------------------------

variable "query_insights_enabled" {
  type        = bool
  description = "Enable Query Insights"
  default     = true
}

variable "query_plans_per_minute" {
  type        = number
  description = "Number of query plans to capture per minute"
  default     = 5

  validation {
    condition     = var.query_plans_per_minute >= 0 && var.query_plans_per_minute <= 20
    error_message = "Query plans per minute must be between 0 and 20."
  }
}

variable "query_string_length" {
  type        = number
  description = "Maximum query string length to capture"
  default     = 1024

  validation {
    condition     = var.query_string_length >= 256 && var.query_string_length <= 4500
    error_message = "Query string length must be between 256 and 4500."
  }
}

variable "record_application_tags" {
  type        = bool
  description = "Record application tags in Query Insights"
  default     = false
}

#------------------------------------------------------------------------------
# Database Flags
#------------------------------------------------------------------------------

variable "database_flags" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "List of database flags to set"
  default     = []
}

#------------------------------------------------------------------------------
# Labels
#------------------------------------------------------------------------------

variable "labels" {
  type        = map(string)
  description = "Labels to apply to the Cloud SQL instance"
  default     = {}
}

#------------------------------------------------------------------------------
# Database and User Configuration
#------------------------------------------------------------------------------

variable "databases" {
  type        = list(string)
  description = "List of database names to create"
  default     = []
}

variable "database_charset" {
  type        = string
  description = "Character set for databases. Set to null for SQL Server (auto-configured by GCP)."
  default     = null
}

variable "database_collation" {
  type        = string
  description = "Collation for databases. For SQL Server use SQL_Latin1_General_CP1_CI_AS, or null to let GCP auto-configure."
  default     = null
}

variable "users" {
  type = map(object({
    password = string
    type     = string # BUILT_IN or CLOUD_IAM_USER
    password_policy = optional(object({
      allowed_failed_attempts      = number
      password_expiration_duration = string
      enable_failed_attempts_check = bool
      enable_password_verification = bool
    }))
  }))
  description = "Map of database users to create. Passwords will be auto-generated if null."
  default     = {}
  # Note: Not marking as sensitive to allow use in for_each loops
}

#------------------------------------------------------------------------------
# DB Admin Access Configuration
#------------------------------------------------------------------------------

variable "db_admins" {
  type        = list(string)
  description = "List of users/groups who need DB connectivity access. Format: 'user:email@domain.com' or 'group:group@domain.com'. Grants: cloudsql.client, cloudsql.viewer, cloudsql.studioUser, secretmanager.secretAccessor"
  default     = []
}

variable "db_import_admins" {
  type        = list(string)
  description = "List of users/groups who need to import/export data. Format: 'user:email@domain.com' or 'group:group@domain.com'. Grants ONLY: cloudsql.instances.import, cloudsql.instances.export, cloudsql.instances.get, cloudsql.backups.create/get (minimal permissions)"
  default     = []
}

# Cloud SQL with Private Service Connect (PSC) for 99.99% SLA
# Uses Shared VPC networking from freight-network-host project

# Include GCP configuration
include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

# Include common configuration
include "common" {
  path   = find_in_parent_folders("common.hcl")
  expose = true
}

# Dependency on VPC to get subnet information
dependency "vpc" {
  config_path = "../../../../freight-network-host/environments/dev/vpc"
}

# Terraform configuration source
terraform {
  source = "${dirname(find_in_parent_folders())}//projects/uf-database/modules/cloudsql"
}

# Inputs for the Cloud SQL instance
inputs = {
  #----------------------------------------------------------------------------
  # Project Configuration
  #----------------------------------------------------------------------------
  project_id      = "uf-database-d"
  host_project_id = "freight-network-host-d"

  #----------------------------------------------------------------------------
  # Instance Configuration - 99.99% SLA Requirements
  # - Enterprise Plus edition
  # - REGIONAL availability (HA across zones)
  # - Point-in-time recovery enabled
  # - Automated backups enabled
  #----------------------------------------------------------------------------
  instance_name    = "mssql-dev-01"
  database_version = "SQLSERVER_2022_ENTERPRISE"
  edition          = "ENTERPRISE_PLUS"  # Required for 99.99% SLA
  region           = "us-south1"
  tier             = "db-perf-optimized-N-4"  # 4 vCPU, 32 GB RAM

  # High Availability (Multiple zones) - Required for 99.99% SLA
  availability_type = "REGIONAL"

  #----------------------------------------------------------------------------
  # Storage Configuration
  #----------------------------------------------------------------------------
  disk_type          = "PD_SSD"
  disk_size          = 1024  # 1 TB
  disk_autoresize    = true
  data_cache_enabled = true  # Enterprise Plus feature for better performance

  # Deletion Protection (false for dev, set to true for prod)
  deletion_protection = false

  #----------------------------------------------------------------------------
  # Network Configuration - PSC (Private Service Connect)
  # PSC is recommended for Shared VPC because:
  # - No VPC peering complexity
  # - Consumer controls the endpoint IP
  # - More secure - traffic stays within your VPC
  # - Easier to manage with Shared VPC
  #----------------------------------------------------------------------------
  connectivity_type = "PSC"

  # Shared VPC network from host project
  network = dependency.vpc.outputs.network_id

  # PSC Configuration
  # The PSC endpoint will be created in the host project's db subnet
  psc_allowed_consumer_projects = [
    "uf-database-d",         # This service project
    "freight-network-host-d" # Host project (if needed)
  ]

  # Use the existing db subnet for PSC endpoint
  # This subnet was created in the shared VPC for database resources
  psc_subnet = dependency.vpc.outputs["tmobile-ptms-db-dev"]["us-south1"].self_link

  # Optional: Specify a specific IP for the PSC endpoint within the subnet
  # The subnet 10.227.131.0/27 has IPs from .1 to .30 available
  psc_endpoint_ip_address = "10.227.131.10"

  # Allow global access so clients from any region can connect
  psc_allow_global_access = true

  # Disable public IP - internal only
  ipv4_enabled = false

  # Enable private path for Google Cloud services (for backups, etc.)
  enable_private_path_for_google_cloud_services = true

  # SSL Configuration
  ssl_mode    = "ENCRYPTED_ONLY"
  require_ssl = true

  #----------------------------------------------------------------------------
  # Backup Configuration - Required for 99.99% SLA
  #----------------------------------------------------------------------------
  backup_enabled                 = true
  point_in_time_recovery_enabled = true  # Required for 99.99% SLA
  backup_start_time              = "03:00"  # 3 AM UTC
  transaction_log_retention_days = 7
  retained_backups               = 14  # Must be > transaction_log_retention_days

  #----------------------------------------------------------------------------
  # Maintenance Window
  #----------------------------------------------------------------------------
  maintenance_window_day          = 7  # Sunday
  maintenance_window_hour         = 2  # 2 AM UTC
  maintenance_window_update_track = "stable"

  #----------------------------------------------------------------------------
  # Query Insights
  #----------------------------------------------------------------------------
  query_insights_enabled  = true
  query_plans_per_minute  = 5
  query_string_length     = 1024
  record_application_tags = false

  #----------------------------------------------------------------------------
  # SQL Server Database Flags
  #----------------------------------------------------------------------------
  database_flags = [
    {
      name  = "contained database authentication"
      value = "on"
    }
  ]

  #----------------------------------------------------------------------------
  # Databases to Create
  #----------------------------------------------------------------------------
  # Databases are managed outside Terraform (created via SQL Server tools)
  databases = []

  #----------------------------------------------------------------------------
  # Database Users
  # Passwords will be auto-generated and stored in Secret Manager
  #----------------------------------------------------------------------------
  users = {
    app_user = {
      password = null  # Will be auto-generated and stored in Secret Manager
      type     = "BUILT_IN"
      # SQL Server password policy
      password_policy = {
        allowed_failed_attempts      = 5
        password_expiration_duration = "2592000s"  # 30 days
        enable_failed_attempts_check = true
        enable_password_verification = true
      }
    }
  }

  #----------------------------------------------------------------------------
  # DB Admin Access
  # Users/groups who need to connect to the database
  # Grants: cloudsql.client, cloudsql.viewer, cloudsql.studioUser, secretmanager.secretAccessor
  # NOTE: For SQL Server admin roles (sysadmin), grant INSIDE the database - see README
  #----------------------------------------------------------------------------
  db_admins = [
     #"group:freight-sql-dba@uberfreight.com",
     "user:mukhtiar.singh@uberfreight.com",
  ]
  
  #----------------------------------------------------------------------------
  # DB Import Admin Access - For Data Migration
  # Users/groups who need to import/export data (e.g., for database migration)
  # Grants ONLY: import, export, view instance, create backup (minimal permissions)
  # Remove after migration is complete for security
  #----------------------------------------------------------------------------
  db_import_admins = [
     "user:mukhtiar.singh@uberfreight.com",  # Temporary for migration
  ]

  #----------------------------------------------------------------------------
  # Labels - Following Uber Freight's standards
  #----------------------------------------------------------------------------
  labels = {
    team                  = "database"
    layer                 = "data"
    managed_by            = "infra-as-code"
    env                   = include.gcp.locals.env
  }
}

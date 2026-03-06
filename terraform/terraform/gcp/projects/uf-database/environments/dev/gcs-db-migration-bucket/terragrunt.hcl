# GCS Bucket for Database Migration - Intermediate Storage
# Used for transferring data from on-prem to Cloud SQL

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

# Terraform configuration source
terraform {
  source = "${dirname(find_in_parent_folders())}//projects/uf-database/modules/gcs-db-migration-bucket"
}

# Inputs for the GCS migration bucket
inputs = {
  #----------------------------------------------------------------------------
  # Project Configuration
  #----------------------------------------------------------------------------
  project_id    = "uf-database-d"
  bucket_suffix = "db-migration"
  
  #----------------------------------------------------------------------------
  # Bucket Location & Storage
  # Use same region as Cloud SQL for lower egress costs
  #----------------------------------------------------------------------------
  location      = "us-south1"
  storage_class = "STANDARD"
  
  # Allow bucket deletion even if it contains objects (safe for dev)
  # Set to true for dev/test, false for production
  force_destroy = true
  
  # Enable versioning for data protection
  enable_versioning = true
  
  #----------------------------------------------------------------------------
  # Lifecycle Management - Automatic Cost Optimization
  # Adjust these based on your migration timeline
  #----------------------------------------------------------------------------
  lifecycle_rules = [
    {
      # Move to cheaper storage after 14 days
      action = {
        type          = "SetStorageClass"
        storage_class = "NEARLINE"
      }
      condition = {
        age = 14
      }
    },
    {
      # Auto-delete after 60 days (adjust based on retention needs)
      action = {
        type = "Delete"
      }
      condition = {
        age = 60
      }
    }
  ]
  
  #----------------------------------------------------------------------------
  # Folder Structure for Organization
  # Keep it simple - just one folder for migration data
  #----------------------------------------------------------------------------
  folder_structure = [
    "raw-data",  # Raw exports from on-prem to upload here
  ]
  
  #----------------------------------------------------------------------------
  # IAM Configuration - Upload Service Account
  # This SA will be used from on-prem to upload data
  #----------------------------------------------------------------------------
  
  #----------------------------------------------------------------------------
  # Service Account Configuration
  # DISABLED: Not needed since users will authenticate with their own credentials
  # Service accounts were only needed for on-prem key-based authentication
  #----------------------------------------------------------------------------
  
  # Don't create service account - users will use their own GCP credentials
  uploader_permission_level = "admin"  # Not used when SA disabled, but required by module
  enable_bucket_listing = true         # Not used when SA disabled, but required by module
  create_service_account_key = false
  secret_key_accessors = []
  secret_key_viewers = []
  create_cloudsql_reader_sa = false
  
  #----------------------------------------------------------------------------
  # Bucket Access - Direct User Access (No Service Account)
  # 
  # These users will authenticate with their own GCP credentials
  # 
  # Setup for on-prem team:
  # 1. Install gcloud SDK: https://cloud.google.com/sdk/docs/install
  # 2. Authenticate: gcloud auth login user@uberfreight.com
  # 3. Set project: gcloud config set project uf-database-d
  # 4. Upload: gsutil cp file.sql gs://uf-database-d-db-migration/raw-data/
  # 
  # See: modules/gcs-db-migration-bucket/ONPREM_UPLOAD_GUIDE.md for details
  #----------------------------------------------------------------------------
  
  # Users who can upload and manage migration data
  additional_bucket_admins = [
    "user:mukhtiar.singh@uberfreight.com",
    # Add on-prem DB team members with @uberfreight.com emails:
    # "user:onprem-dba-1@uberfreight.com",
    # "user:onprem-dba-2@uberfreight.com",
    # Or use a group:
    # "group:freight-sql-dba@uberfreight.com",
  ]
  
  # Users who can view (read-only) migration data
  additional_bucket_viewers = [
    # "group:freight-platform-team@uberfreight.com",
  ]
  
  #----------------------------------------------------------------------------
  # Encryption (Optional)
  # Leave null for Google-managed encryption
  # Uncomment to use Customer-Managed Encryption Keys (CMEK)
  #----------------------------------------------------------------------------
  # kms_key_name = "projects/uf-database-d/locations/us-south1/keyRings/db-migration/cryptoKeys/bucket-key"
  
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


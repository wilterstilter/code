# GCS Database Migration Bucket Module

This Terraform module creates a Google Cloud Storage (GCS) bucket specifically designed for database migration scenarios, where data needs to be transferred from on-premises systems to Cloud SQL via an intermediate storage layer.

## Purpose

This module provides:
- **GCS Bucket**: Secure, cost-effective intermediate storage for migration data
- **Upload Service Account**: Dedicated SA with minimal permissions for on-prem data uploads
- **Reader Service Account** (optional): Separate SA for Cloud SQL to read migration data
- **IAM Management**: Least-privilege access controls following security best practices
- **Lifecycle Management**: Automatic cost optimization through storage class transitions
- **Service Account Key**: For authentication from on-prem systems

## Architecture

```
On-Premises Database
       ↓
   [Export Data]
       ↓
   Upload SA Key → GCS Bucket (Intermediate Storage)
                        ↓
                  Cloud SQL Import
                        ↓
                  Cloud SQL Instance
```

## Security Features

- **Least Privilege**: Upload SA has only the permissions needed (objectCreator or objectAdmin)
- **Bucket-Level IAM**: Permissions scoped only to this bucket, not project-wide
- **Uniform Bucket Access**: Uses modern IAM instead of legacy ACLs
- **Encryption**: Supports both Google-managed and customer-managed encryption keys (CMEK)
- **Versioning**: Protects against accidental overwrites/deletions
- **Service Account Keys**: Can be rotated and revoked independently

## Usage

### Basic Example

```hcl
module "db_migration_bucket" {
  source = "../modules/gcs-db-migration-bucket"

  project_id    = "uf-database-d"
  bucket_suffix = "db-migration"
  location      = "us-south1"

  # Grant your DB team access
  additional_bucket_admins = [
    "group:freight-sql-dba@uberfreight.com",
    "user:mukhtiar.singh@uberfreight.com"
  ]

  labels = {
    team        = "data-platform"
    environment = "dev"
    purpose     = "database-migration"
  }
}
```

### Advanced Example with Custom Lifecycle

```hcl
module "db_migration_bucket" {
  source = "../modules/gcs-db-migration-bucket"

  project_id    = "uf-database-d"
  bucket_suffix = "db-migration"
  location      = "us-south1"
  
  # Security: Most restrictive - upload only, no read/delete
  uploader_permission_level = "creator"
  enable_bucket_listing     = false
  
  # Custom lifecycle for large migrations
  lifecycle_rules = [
    {
      action = {
        type          = "SetStorageClass"
        storage_class = "NEARLINE"
      }
      condition = {
        age = 7  # Move to cheaper storage after 7 days
      }
    },
    {
      action = {
        type = "Delete"
      }
      condition = {
        age = 30  # Delete after 30 days
      }
    }
  ]
  
  # Organized folder structure
  folder_structure = [
    "raw-exports",
    "transformed-data",
    "validation-scripts",
    "error-logs",
    "backups"
  ]
  
  # Additional access
  additional_bucket_admins = [
    "group:freight-sql-dba@uberfreight.com"
  ]
  
  additional_bucket_viewers = [
    "group:freight-platform-team@uberfreight.com"
  ]
  
  labels = {
    team                  = "data-platform"
    env                   = "dev"
    cost_center           = "cc14512"
    managed_by            = "terraform"
    migration_source      = "onprem-mssql"
    migration_target      = "cloudsql-mssql"
  }
}
```

### With CMEK (Customer-Managed Encryption Key)

```hcl
module "db_migration_bucket" {
  source = "../modules/gcs-db-migration-bucket"

  project_id   = "uf-database-d"
  location     = "us-south1"
  kms_key_name = "projects/uf-database-d/locations/us-south1/keyRings/db-migration/cryptoKeys/bucket-key"
  
  # ... other variables
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | GCP project ID | `string` | n/a | yes |
| bucket_suffix | Suffix for bucket name | `string` | `"db-migration"` | no |
| location | Bucket location | `string` | `"US"` | no |
| storage_class | Storage class (STANDARD, NEARLINE, etc.) | `string` | `"STANDARD"` | no |
| force_destroy | Allow bucket deletion with objects | `bool` | `false` | no |
| enable_versioning | Enable object versioning | `bool` | `true` | no |
| uploader_permission_level | Permission level: creator or admin | `string` | `"admin"` | no |
| enable_bucket_listing | Allow listing bucket contents | `bool` | `true` | no |
| create_service_account_key | Create SA key for on-prem | `bool` | `true` | no |
| create_cloudsql_reader_sa | Create separate reader SA | `bool` | `false` | no |
| lifecycle_rules | Lifecycle rules for cost management | `list(object)` | See variables.tf | no |
| folder_structure | Folder paths to create | `list(string)` | See variables.tf | no |
| additional_bucket_admins | Additional admin members | `list(string)` | `[]` | no |
| additional_bucket_viewers | Additional viewer members | `list(string)` | `[]` | no |
| labels | Resource labels | `map(string)` | `{}` | no |
| kms_key_name | KMS key for encryption | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| bucket_name | Name of the bucket |
| bucket_url | Bucket URL (gs://...) |
| uploader_service_account_email | Email of upload SA |
| uploader_service_account_key | Private key (sensitive) |
| reader_service_account_email | Email of reader SA (if created) |
| usage_instructions | Instructions for using the bucket |

## Service Account Key Management

### Where is the Service Account Key Stored?

The service account key is **stored in Terraform state** as a sensitive output. It is **base64-encoded** and marked as sensitive to prevent accidental exposure in logs.

### Retrieving the Service Account Key for On-Prem Use

You have three options to get the key credentials:

#### Option 1: Extract from Terraform Output (Recommended)

```bash
# Navigate to your terragrunt directory
cd /path/to/environments/dev/gcs-db-migration-bucket

# Extract and decode the key to a JSON file
terragrunt output -raw uploader_service_account_key | base64 -d > migration-key.json

# Secure the file (important!)
chmod 600 migration-key.json

# Verify the key is valid JSON
cat migration-key.json | jq .
```

#### Option 2: Download from GCP Console

If you prefer not to extract from Terraform state, or if you need to rotate keys:

1. Go to [GCP Console → IAM & Admin → Service Accounts](https://console.cloud.google.com/iam-admin/serviceaccounts)
2. Select project: `uf-database-d`
3. Find service account: `sa-migration-uploader@uf-database-d.iam.gserviceaccount.com`
4. Click **Keys** tab → **Add Key** → **Create new key**
5. Select **JSON** format → **Create**
6. Save the downloaded file securely

#### Option 3: Create New Key via gcloud CLI

```bash
gcloud iam service-accounts keys create migration-key.json \
  --iam-account=sa-migration-uploader@uf-database-d.iam.gserviceaccount.com \
  --project=uf-database-d
```

### Security Best Practices for Service Account Keys

⚠️ **Important Security Considerations:**

1. **Store keys securely**: Never commit keys to git or expose in logs
2. **Limit key access**: Only share with personnel who need to perform the migration
3. **Rotate keys regularly**: Create new keys every 90 days and delete old ones
4. **Delete after migration**: Remove keys once migration is complete
5. **Use secret management**: Consider storing in HashiCorp Vault, AWS Secrets Manager, etc.
6. **Monitor usage**: Enable Cloud Audit Logs to track key usage

### Key Rotation Process

```bash
# 1. Create new key
gcloud iam service-accounts keys create new-migration-key.json \
  --iam-account=sa-migration-uploader@uf-database-d.iam.gserviceaccount.com

# 2. Update on-prem systems to use new key
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/new-migration-key.json

# 3. Test new key
gsutil ls gs://uf-database-d-db-migration/

# 4. List existing keys
gcloud iam service-accounts keys list \
  --iam-account=sa-migration-uploader@uf-database-d.iam.gserviceaccount.com

# 5. Delete old key (after confirming new key works)
gcloud iam service-accounts keys delete OLD_KEY_ID \
  --iam-account=sa-migration-uploader@uf-database-d.iam.gserviceaccount.com
```

## On-Premises Usage

### Step 1: Retrieve Service Account Key

Use one of the methods above to obtain `migration-key.json`

### Step 2: Set Up Authentication

```bash
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/migration-key.json
```

### Step 3: Upload Data

Using gsutil:
```bash
# Single file
gsutil cp database_export.sql gs://uf-database-d-db-migration/raw-data/

# Multiple files
gsutil -m cp -r /export/directory/* gs://uf-database-d-db-migration/raw-data/

# With compression
gzip database_export.sql
gsutil cp database_export.sql.gz gs://uf-database-d-db-migration/raw-data/
```

Using gcloud:
```bash
gcloud storage cp database_export.sql gs://uf-database-d-db-migration/raw-data/
```

### Step 4: Verify Upload

```bash
gsutil ls -lh gs://uf-database-d-db-migration/raw-data/
```

## Cloud SQL Import

Once data is in GCS, import to Cloud SQL:

```bash
# SQL Server
gcloud sql import sql mssql-dev-01 \
  gs://uf-database-d-db-migration/raw-data/database_export.sql \
  --database=test_db

# With BAK file (SQL Server backup)
gcloud sql import bak mssql-dev-01 \
  gs://uf-database-d-db-migration/raw-data/database.bak \
  --database=test_db
```

## Migration Workflow

1. **Export on-prem database**
   ```bash
   # SQL Server example
   sqlcmd -S localhost -U sa -P password -Q "BACKUP DATABASE MyDB TO DISK = '/backup/mydb.bak'"
   ```

2. **Upload to GCS using this module's service account**
   ```bash
   gsutil cp /backup/mydb.bak gs://uf-database-d-db-migration/raw-data/
   ```

3. **Import to Cloud SQL**
   ```bash
   gcloud sql import bak mssql-dev-01 gs://uf-database-d-db-migration/raw-data/mydb.bak --database=MyDB
   ```

4. **Validate migration**
   - Connect to Cloud SQL
   - Run validation queries
   - Check row counts, data integrity

5. **Clean up**
   ```bash
   # Delete data from bucket after successful migration
   gsutil rm -r gs://uf-database-d-db-migration/raw-data/*
   
   # Or let lifecycle policies auto-delete
   ```

## Security Best Practices

1. **Rotate Service Account Keys Regularly**
   ```bash
   # Disable old key
   gcloud iam service-accounts keys disable KEY_ID --iam-account=sa-migration-uploader@PROJECT.iam.gserviceaccount.com
   
   # Create new key
   gcloud iam service-accounts keys create new-key.json --iam-account=sa-migration-uploader@PROJECT.iam.gserviceaccount.com
   ```

2. **Use VPN or Private Connectivity** for data transfer from on-prem

3. **Enable Cloud Audit Logs** to monitor bucket access

4. **Delete bucket after migration** to prevent security/cost issues

5. **Use most restrictive permissions**:
   - `uploader_permission_level = "creator"` (write-only)
   - `enable_bucket_listing = false` (no list permissions)

## Cost Optimization

- **Lifecycle rules**: Automatically transition to cheaper storage classes
- **Compression**: Compress data before upload (gzip, bzip2)
- **Delete after migration**: Don't keep data longer than needed
- **Choose appropriate location**: Use regional bucket near Cloud SQL for lower egress costs

## Troubleshooting

### Issue: Permission Denied

```bash
# Check SA has correct permissions
gcloud storage buckets get-iam-policy gs://BUCKET_NAME

# Verify key is valid
gcloud auth activate-service-account --key-file=migration-key.json
gcloud auth list
```

### Issue: Upload Timeout

```bash
# Use resumable uploads for large files
gsutil -o GSUtil:parallel_composite_upload_threshold=150M cp large_file.bak gs://bucket/
```

### Issue: Cloud SQL Import Fails

- Ensure file format is correct (SQL script or BAK file)
- Check Cloud SQL service account has Storage Object Viewer role on bucket
- Verify database exists in Cloud SQL
- Check Cloud SQL logs for detailed error messages

## Related Documentation

- [Cloud SQL Import/Export](https://cloud.google.com/sql/docs/sqlserver/import-export)
- [GCS Best Practices](https://cloud.google.com/storage/docs/best-practices)
- [Database Migration Service](https://cloud.google.com/database-migration)

## Support

For issues or questions, contact:
- Data Platform Team: data-platform@uberfreight.com
- Infrastructure Team: infra-as-code@uberfreight.com


# Cloud SQL Enterprise Plus Module

This module creates a fully configured Cloud SQL instance with Enterprise Plus edition for **99.99% SLA** support.

## Features

### High Availability & SLA
- ✅ **Enterprise Plus Edition** - 99.99% uptime SLA
- ✅ **Regional Availability** - Multi-zone deployment
- ✅ **Data Cache** - Enhanced performance with Enterprise Plus
- ✅ **Automated Backups** - Point-in-time recovery enabled
- ✅ **SSL/TLS Encryption** - Required for all connections

### Security
- ✅ **Secret Manager Integration** - Automatic password generation and secure storage
- ✅ **Private IP Only** - No public IP exposure
- ✅ **Shared VPC** - Network isolation with dedicated subnet
- ✅ **Service Accounts** - Dedicated SAs for CloudSQL and Database Migration

### Database Migration Support
A dedicated service account is created with the following roles:
- `roles/datamigration.admin` - Database Migration Admin
- `roles/storage.admin` - Storage Admin
- `roles/cloudsql.editor` - Cloud SQL Editor
- `roles/cloudsql.studioUser` - Cloud SQL Studio User
- `roles/secretmanager.secretAccessor` - Access to database credentials

## Architecture

### Network Configuration
The instance uses the `tmobile-ptms-db-dev` subnet from the Shared VPC:
- **Dev Subnet**: `10.227.131.0/27` (us-south1)
- **QA Subnet**: `10.227.131.32/27` (us-south1)

### Secret Management
Database passwords are:
1. Auto-generated with strong complexity requirements
2. Stored in Google Secret Manager
3. Accessible only by authorized service accounts
4. Versioned for audit and rollback

## Files Structure

```
modules/cloudsql/
├── main.tf        # Core Cloud SQL instance configuration
├── iam.tf         # Service accounts and IAM roles
├── secrets.tf     # Secret Manager integration
├── variables.tf   # Input variables
└── outputs.tf     # Module outputs
```

## Usage

```hcl
dependency "vpc" {
  config_path = "../../../../freight-network-host/environments/dev/vpc"
}

inputs = {
  # Instance Configuration
  instance_name    = "mssql-dev-01"
  database_version = "SQLSERVER_2022_ENTERPRISE_CU19_GDR"
  edition          = "ENTERPRISE_PLUS"  # 99.99% SLA
  region           = "us-south1"
  tier             = "db-perf-optimized-N-4"
  
  # High Availability
  availability_type = "REGIONAL"
  
  # Network - using dedicated database subnet
  network            = dependency.vpc.outputs.network_id
  private_ip_address = split("/", dependency.vpc.outputs.tmobile-ptms-db-dev["us-south1"].ip_cidr_range)[0]
  ip_range_prefix_length = tonumber(split("/", dependency.vpc.outputs.tmobile-ptms-db-dev["us-south1"].ip_cidr_range)[1])
  
  # Security
  ssl_mode    = "ENCRYPTED_ONLY"
  require_ssl = true
  
  # Users - passwords auto-generated
  users = {
    app_user = {
      password = null  # Auto-generated
      type     = "BUILT_IN"
      password_policy = {
        allowed_failed_attempts      = 5
        password_expiration_duration = "2592000s"
        enable_failed_attempts_check = true
        enable_password_verification = true
      }
    }
  }
}
```

## 99.99% SLA Requirements

To achieve 99.99% SLA, the following are configured:

1. **Edition**: `ENTERPRISE_PLUS` (required)
2. **Availability Type**: `REGIONAL` (multi-zone deployment)
3. **Automated Backups**: Enabled with point-in-time recovery
4. **Maintenance Window**: Configured to minimize disruption
5. **Private Network**: Reduces network-related failures

## IAM Access Levels

### DB Admins (`db_admins`)
Users who need to **connect** to the database:
- ✅ Connect via Cloud SQL Auth Proxy
- ✅ View instance metadata
- ✅ Use Cloud SQL Studio
- ✅ Read database passwords from Secret Manager
- ❌ Cannot import/export data
- ❌ Cannot modify instance settings

```hcl
db_admins = [
  "user:dba@company.com",
  "group:database-team@company.com"
]
```

### DB Import Admins (`db_import_admins`)
Users who need to **import/export data** (e.g., for migrations):
- ✅ Import data from GCS (`gcloud sql import`)
- ✅ Export data to GCS (`gcloud sql export`)
- ✅ View instance details
- ✅ Create backups (safety measure)
- ❌ **Cannot** modify instance settings
- ❌ **Cannot** restart instance
- ❌ **Cannot** create/delete databases
- ⚠️ **Grant temporarily for migrations, then remove**

**Uses a custom IAM role with minimal permissions** (least privilege principle)

```hcl
db_import_admins = [
  "user:migration-user@company.com"  # Remove after migration
]
```

## Accessing Database Passwords

Passwords are stored in Secret Manager with the naming pattern:
```
cloudsql-{instance_name}-{username}-password
```

To retrieve a password:

```bash
# Using gcloud
gcloud secrets versions access latest \
  --secret="cloudsql-mssql-dev-01-app_user-password" \
  --project="uf-database-d"

# Using Terraform output
terraform output -json secret_names
```

## Service Accounts

### Cloud SQL Service Account
- **Name**: `sa-cloudsql-{instance_name}`
- **Purpose**: Cloud SQL instance operations
- **Permissions**: Secret Manager access for credentials

### Database Migration Service Account
- **Name**: `sa-db-migration-{instance_name}`
- **Purpose**: Database migration operations
- **Roles**:
  - Database Migration Admin
  - Storage Admin
  - Cloud SQL Editor
  - Cloud SQL Studio User
  - Secret Manager Secret Accessor

## Monitoring & Maintenance

### Query Insights
- Enabled by default
- Captures query plans and execution statistics
- Helps identify performance bottlenecks

### Maintenance Window
- **Day**: Sunday (day 7)
- **Time**: 2:00 AM UTC
- **Duration**: 2 hours
- **Track**: Stable (production-ready updates)

### Backup Configuration
- **Automated Backups**: Daily
- **Point-in-Time Recovery**: 7 days
- **Start Time**: 3:00 AM UTC
- **Retained Backups**: 7 snapshots

## Important Notes

⚠️ **Enterprise Plus Pricing**: Enterprise Plus edition has additional costs but provides 99.99% SLA
⚠️ **Regional Deployment**: Requires resources in multiple zones (additional cost)
⚠️ **Deletion Protection**: Enable for production environments
⚠️ **Password Rotation**: Passwords should be rotated regularly via Secret Manager

## Outputs

The module provides the following outputs:

- `instance_name` - Cloud SQL instance name
- `instance_connection_name` - Connection string for clients
- `instance_ip_address` - Private IP address
- `database_migration_service_account_email` - Migration SA email
- `secret_names` - Map of username to secret names
- `secret_ids` - Map of username to secret IDs (sensitive)

## Support

For issues or questions:
- **Team**: Data Platform
- **Cost Center**: cc14512
- **Point of Contact**: data-platform@uberfreight.com

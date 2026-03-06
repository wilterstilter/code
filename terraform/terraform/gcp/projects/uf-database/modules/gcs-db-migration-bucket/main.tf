# GCS Bucket for Database Migration
# Intermediate storage for on-prem to Cloud SQL migration

#------------------------------------------------------------------------------
# GCS Bucket for Migration Data
#------------------------------------------------------------------------------

resource "google_storage_bucket" "migration" {
  project       = var.project_id
  name          = "${var.project_id}-${var.bucket_suffix}"
  location      = var.location
  storage_class = var.storage_class

  # Force destroy allows bucket deletion even if it contains objects
  # Set to false for production to prevent accidental data loss
  force_destroy = var.force_destroy

  # Uniform bucket-level access (recommended over legacy ACLs)
  uniform_bucket_level_access = true

  # Enable versioning for data protection
  versioning {
    enabled = var.enable_versioning
  }

  # Lifecycle rules to manage costs
  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      action {
        type          = lifecycle_rule.value.action.type
        storage_class = lookup(lifecycle_rule.value.action, "storage_class", null)
      }
      condition {
        age                = lookup(lifecycle_rule.value.condition, "age", null)
        created_before     = lookup(lifecycle_rule.value.condition, "created_before", null)
        num_newer_versions = lookup(lifecycle_rule.value.condition, "num_newer_versions", null)
        with_state         = lookup(lifecycle_rule.value.condition, "with_state", null)
        matches_prefix     = lookup(lifecycle_rule.value.condition, "matches_prefix", null)
        matches_suffix     = lookup(lifecycle_rule.value.condition, "matches_suffix", null)
      }
    }
  }

  # Encryption with Google-managed keys (or CMEK if needed)
  # Only specify encryption block if a custom KMS key is provided
  dynamic "encryption" {
    for_each = var.kms_key_name != null ? [1] : []
    content {
      default_kms_key_name = var.kms_key_name
    }
  }

  # Labels for organization and cost tracking
  labels = merge(
    var.labels,
    {
      purpose = "database-migration"
      module  = "gcs-migration"
    }
  )
}

#------------------------------------------------------------------------------
# Bucket Folders for Organization
#------------------------------------------------------------------------------

# Create logical folders for organization
resource "google_storage_bucket_object" "folders" {
  for_each = toset(var.folder_structure)

  bucket  = google_storage_bucket.migration.name
  name    = "${each.value}/"
  content = " " # Empty content, just creates a "folder" marker
}


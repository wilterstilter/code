include "gcp" {
    path = find_in_parent_folders()
    expose = true
}
terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-compute/modules/storage-bucket"
}

include "common" {
  path = find_in_parent_folders("common.hcl")
  expose = true
}

inputs = {
  project_id        = "uf-compute-n"
  bucket_name       = "ptms-tmob-fsms-uat" # bucket will exist per env for project
  location          = "US"                 # multi-region bucket
  storage_class     = "STANDARD"
  enable_versioning = false
  force_destroy     = false
  create_bucket     = true
  create_sa         = false

  # NEW service account for FSMS
  # service_account_id           = "ptms-tmob-fsms-gcs-sa"
  # service_account_display_name = "PTMS TMOB FSMS GCS Access"
    
  bucket_labels = {
    purpose = "ptms-tmob-fsms-shared-storage"
  }
}
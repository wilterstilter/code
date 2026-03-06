include "gcp" {
    path = find_in_parent_folders()
    expose = true
}
terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-compute/modules/cloud-storage"
}

include "common" {
  path = find_in_parent_folders("common.hcl")
  expose = true
}

inputs = {
  project_id        = "uf-compute-d"
  bucket_name       = "parcel-api-edge-bucket"
  location          = "US"       # multi-region bucket
  storage_class     = "STANDARD"
  enable_versioning = true
  force_destroy     = false
  create_bucket     = false   # Set to false when the bucket already exists and should not be created
  create_sa         = true
  k8s_namespace     = "uf-dev"
  k8s_service_account_name = "ptms-sa"
}

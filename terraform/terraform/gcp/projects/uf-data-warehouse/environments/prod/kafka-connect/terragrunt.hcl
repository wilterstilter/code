# Include GCP configuration
include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "${dirname(find_in_parent_folders())}/../common/terragrunt-delete"
}

include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path   = "${get_terragrunt_dir()}/../common.hcl"
  expose = true
}

terraform {
  source = "../../modules/object_storage"
}

locals {
  common_vars = include.common.locals
}

inputs = {
  compartment_id     = local.common_vars.compartment_id
  namespace          = local.common_vars.namespace
  region             = local.common_vars.region
  bucket_name        = "poc-gh-actions-test-bucket"
  storage_tier       = "Standard"
  tags               = merge(local.common_vars.common_tags, { Component = "object-storage" })
}


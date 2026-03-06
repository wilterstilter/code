include "root" {
  path = find_in_parent_folders()
}

include "common" {
  path   = "${get_terragrunt_dir()}/../common.hcl"
  expose = true
}

terraform {
  source = "../../modules/iam"
}

locals {
  common_vars = include.common.locals
}

inputs = {
  compartment_id = local.common_vars.compartment_id
  region         = local.common_vars.region

  # IAM Policy - Tests GitHub Actions authentication to OCI
  policies = [
    {
      name        = "poc-github-actions-policy-test"
      description = "Test policy for GitHub Actions OCI authentication POC"
      statements = [
        "allow group gh-actions-ci to read all-resources in compartment id ${local.common_vars.compartment_id}",
        "allow group gh-actions-ci to manage instance-family in compartment id ${local.common_vars.compartment_id}",
        "allow group gh-actions-ci to manage virtual-network-family in compartment id ${local.common_vars.compartment_id}"
      ]
    }
  ]

  tags = local.common_vars.common_tags
}


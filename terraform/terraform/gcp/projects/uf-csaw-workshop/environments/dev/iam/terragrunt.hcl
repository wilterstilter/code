include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../../modules/iam"
}

# Inputs for the terragrunt configuration
inputs = {
  project_id = include.gcp.locals.project_id

  project_iam_bindings = {
    "roles/owner" = {
      entities = [
        "user:sakshi@uberfreight.com"
      ]
    }
  }
}

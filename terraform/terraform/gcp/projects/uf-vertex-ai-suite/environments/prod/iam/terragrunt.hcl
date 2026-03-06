include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../../modules/iam"
}


locals {
  project_id     = include.gcp.locals.project_id
}

# Inputs for the terragrunt configuration
inputs = {
  project_id          = local.project_id

  project_iam_bindings = {
    "roles/viewer" = {
      entities = [
        "group:freight-data@uberfreight.com",
      ]
    },
    "roles/compute.admin" = {
      entities = [
        "group:freight-data@uberfreight.com",
      ]
    },
    "roles/iam.serviceAccountUser" = {
      entities = [
        "group:freight-data@uberfreight.com",
      ]
    },
    "roles/storage.objectUser" = {
      entities = [
        "group:freight-data@uberfreight.com",
      ]
    },
    "roles/storage.objectViewer" = {
      entities = [
        "group:ufds-group@uberfreight.com",
      ]
    },
    "roles/logging.admin" = {
      entities = [
        "group:freight-data@uberfreight.com"
      ]
    },
    "roles/monitoring.admin" = {
      entities = [
        "group:freight-data@uberfreight.com"
      ]
    },
  }
}

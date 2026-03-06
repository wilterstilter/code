include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../../modules/secrets"
}

locals {
  project_id = include.gcp.locals.project_id
}

inputs = {
  project_id = local.project_id

  base_labels = {
    env  = include.gcp.locals.env
    team = "freight-data"
  }

  # Combine metadata and secret value into a single map "secrets"
  secrets = {
    "salesforce-credentials-dev" = {
      secret_data               = null # Manage value outside Terraform if needed
      labels                    = { env = include.gcp.locals.env }
      accessor_service_accounts = [
        "etl-sa-freight-data-d@uf-etl-d.iam.gserviceaccount.com"
      ]
      accessor_groups = []
      editor_groups   = [
        "freight-data@uberfreight.com",
        "freight-data-vendor@uberfreight.com"
      ]
      admin_groups = []
    }
  }
}

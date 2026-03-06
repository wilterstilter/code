include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../../modules/slot_reservations"
}


# Inputs for the terragrunt configuration
inputs = {
  project_id = include.gcp.locals.project_id
  location   = "us-south1"
  reservations = []
}

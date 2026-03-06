# Include GCP configuration
include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

# Terraform configuration source
terraform {
  source = "../../../modules/compute_instance"
}

# Inputs for the Compute Instance
inputs = {
  project_id    = include.gcp.locals.project_id
  region        = "us-south1"
  network       = "projects/freight-network-host-p/global/networks/prod"
  subnetwork    = "projects/freight-network-host-p/regions/us-south1/subnetworks/us-south1-composer-network"
  machine_type  = "n2-standard-2"
  disk_size_gb  = 20
  num_instances = 1
  zone          = "us-south1-a"
  hostname      = "db-connect-test-vm-prod"
}

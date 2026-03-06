
# Include GCP configuration
include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

# Include common configuration
include "common" {
  path   = find_in_parent_folders("common.hcl")
  expose = true
}

terraform {
  source = "${dirname(find_in_parent_folders())}//projects/uf-data-warehouse/modules/cdc"
}

dependency "vpc" {
  config_path = "../../../../freight-network-host/environments/prod/vpc"
}

inputs = {
  project_id = include.gcp.locals.project_id
  network    = dependency.vpc.outputs.network_id
  serviceAccount = "confluent-kafka-sa@${include.gcp.locals.project_id}.iam.gserviceaccount.com"
  subnetwork = "projects/freight-network-host-p/regions/us-south1/subnetworks/us-south1-kafka-connect"
  kc_image   = "us-docker.pkg.dev/uf-build-p/docker-internal/confluent/custom/cp-kafka-connect:latest"
  mig_configs = {}
}

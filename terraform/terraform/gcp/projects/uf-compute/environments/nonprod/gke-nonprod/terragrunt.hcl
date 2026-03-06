include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-compute/modules/gke"
}

include "common" {
    path = find_in_parent_folders("common.hcl")
    expose = true
}

dependency "vpc" {
  config_path = "../../../../freight-network-host/environments/nonprod/vpc"
}

inputs = {
  project_id                  = "uf-compute-n"
  project_number              = "242747481816"
  name                        = "gke-nonprod"
  region                      = "us-south1"
  network                     = dependency.vpc.outputs.network_id
  network_project_id          = "freight-network-host-n"
  subnetwork                  = dependency.vpc.outputs.gke_subnet_nonprod["us-south1"].self_link
  maintenance_recurrence      = "FREQ=WEEKLY;BYDAY=SA,SU,MO"
  maintenance_start_time      = "2024-10-10T02:00:00Z"  # 9 PM UTC
  maintenance_end_time        = "2024-10-10T06:00:00Z"
  sync_repo                   = "https://github.com/uber-freight-internal/gke-cs.git"
  sync_branch                 = "staging"
  policy_dir                  = "staging"
  secret_type                 = "token"
  master_ipv4_cidr_block      = "10.217.0.16/28"
  configmanagement_feature_exists = false
  configmanagement_feature_membership_exists = false
  mesh_feature_exists             = false
  
  master_authorized_networks  = [
    "10.1.0.0/16",
    "10.2.0.0/16",
    "10.230.0.0/16",
    "10.231.0.0/16"
  ]
  group                       = "sg-az-gcp-devops@uberfreight.com"
  cluster_labels              = {
    "environment"             = "nonprod"
    "team"                    = "platform"
  }
  zones                       = [
    "us-south1-a",
    "us-south1-b",
    "us-south1-c",
  ]
}
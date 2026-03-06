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
  config_path = "../../../../freight-network-host/environments/dev/vpc"
}

inputs = {
  project_id                  = "uf-compute-d"
  project_number              = "698267957744"
  name                        = "gke-dev-ptms"
  region                      = "us-east4"
  network                     = dependency.vpc.outputs.network_id
  network_project_id          = "freight-network-host-d"
  subnetwork                  = dependency.vpc.outputs.gke_subnet_dev_ptms["us-east4"].self_link
  maintenance_recurrence      = "FREQ=WEEKLY;BYDAY=SA,SU,MO"
  maintenance_start_time      = "2024-10-10T02:00:00Z"  # 9 PM UTC
  maintenance_end_time        = "2024-10-10T06:00:00Z"
  sync_repo                   = "https://github.com/uber-freight-internal/gke-cs.git"
  sync_branch                 = "test" # use test branch of gke-cs repo
  policy_dir                  = "dev"  # use dev folder
  secret_type                 = "token"
  master_ipv4_cidr_block      = "10.225.1.0/28"
  configmanagement_feature_exists = true
  configmanagement_feature_membership_exists = true
  mesh_feature_exists             = true
  mesh_feature_membership_exists  = true

  # master CIDR
  master_authorized_networks  = [
    "10.1.0.0/16",
    "10.2.0.0/16",
    "10.230.0.0/16",
    "10.231.0.0/16",
    "10.247.1.0/24"
  ]
  group                       = "sg-az-gcp-devops@uberfreight.com"
  cluster_labels              = {
    "team"                    = "platform"
    "host"                    = "gke-dev-ptms"
    "env"                     = "dev-ptms"
    "service"                 = "gke-cluster"
    "region"                  = "us-east4"
  }
  zones                       = [
    "us-east4-a",
    "us-east4-b",
    "us-east4-c",
  ]
}
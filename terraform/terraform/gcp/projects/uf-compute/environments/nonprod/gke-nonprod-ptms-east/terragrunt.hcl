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
  name                        = "gke-nonprod-ptms-east"
  region                      = "us-east4"
  network                     = dependency.vpc.outputs.network_id
  network_project_id          = "freight-network-host-n"
  subnetwork                  = dependency.vpc.outputs.gke_subnet_nonprod_ptms_east4["us-east4"].self_link
  maintenance_recurrence      = "FREQ=WEEKLY;BYDAY=SA,SU,MO"
  maintenance_start_time      = "2024-10-10T02:00:00Z"  # 9 PM UTC
  maintenance_end_time        = "2024-10-10T06:00:00Z"
  sync_repo                   = "https://github.com/uber-freight-internal/gke-cs.git"
  sync_branch                 = "uat"
  policy_dir                  = "uat"
  secret_type                 = "token"
  master_ipv4_cidr_block      = "10.220.17.0/28"
  configmanagement_feature_exists = true
  configmanagement_feature_membership_exists = true
  mesh_feature_exists             = true
  mesh_feature_membership_exists  = true
  
  master_authorized_networks  = [
    "10.1.0.0/16",
    "10.2.0.0/16",
    "10.230.0.0/16",
    "10.231.0.0/16"
  ]
  group                       = "sg-az-gcp-devops@uberfreight.com"
  cluster_labels              = {
    "team"                    = "platform"
    "host"                    = "gke-nonprod-ptms-east"
    "env"                     = "nonprod-ptms-east"
    "service"                 = "gke-cluster"
    "region"                  = "us-east4"
  }
  zones                       = [
    "us-east4-a",
    "us-east4-b",
    "us-east4-c",
  ]
}
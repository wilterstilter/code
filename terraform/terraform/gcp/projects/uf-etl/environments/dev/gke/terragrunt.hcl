include "gcp" {
  path = find_in_parent_folders()
  expose = true
}

terraform {
  source = "../../../modules/gke"
}

inputs = {
  project_id                  = "uf-etl-d"  # Same as Composer
  project_number              = "694102367060"
  name                        = "gke-etl-dev"
  region                      = "us-south1"  # Same as Composer
  network                     = "projects/freight-network-host-d/global/networks/dev"  # Same as Composer
  network_project_id          = "freight-network-host-d"  # Same as Composer
  subnetwork                  = "projects/freight-network-host-d/regions/us-south1/subnetworks/us-south1-composer-network-d"  # Same as Composer
  maintenance_recurrence      = "FREQ=DAILY"
  maintenance_start_time      = "2024-10-10T03:00:00Z"  # 3 AM UTC
  maintenance_end_time        = "2024-10-10T07:00:00Z"  # 7 AM UTC
  master_ipv4_cidr_block      = "10.227.8.0/28"  # CIDR block for private master (outside composer subnet)
  master_authorized_networks  = [
    "10.1.0.0/16",
    "10.2.0.0/16",
    "10.230.0.0/16",
    "10.231.0.0/16",
    "10.227.0.0/23"   # Composer network range (where nodes will run)
  ]
  zones                       = [
    "us-south1-a",
    "us-south1-b",
    "us-south1-c",
  ]
  
  # Workload Identity binding for ETL KSA
  workload_identity_service_account = "etl-sa-freight-data-d@uf-etl-d.iam.gserviceaccount.com"
  workload_identity_ksa_name        = "gke-etl-ksa"
  workload_identity_ksa_namespace   = "default"
}

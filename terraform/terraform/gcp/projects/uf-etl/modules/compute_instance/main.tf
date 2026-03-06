resource "google_service_account" "compute-sa" {
  project      = var.project_id
  account_id   = "compute-sa"
  display_name = "GCE Service Account for test compute instance."
}

module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "~> 13.0"

  region       = var.region
  project_id   = var.project_id
  network      = var.network
  subnetwork   = var.subnetwork
  machine_type = var.machine_type
  service_account = {
    email = google_service_account.compute-sa.email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
  disk_size_gb = var.disk_size_gb
  disk_type    = "pd-ssd"
  auto_delete  = true
}

module "compute_instance" {
  source  = "terraform-google-modules/vm/google//modules/compute_instance"
  version = "~> 13.0"

  region              = var.region
  zone                = var.zone
  subnetwork          = var.subnetwork
  num_instances       = var.num_instances
  hostname            = var.hostname
  instance_template   = module.instance_template.self_link
  deletion_protection = false
}

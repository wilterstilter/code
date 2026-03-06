resource "google_service_account" "kafka_connect" {
  project      = var.project_id
  account_id   = "kafka-connect-${var.name}"
  display_name = "Kafka-Connect GCE Service Account for pool ${var.name}"
}

resource "google_project_iam_member" "log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.kafka_connect.email}"
}

resource "google_project_iam_member" "metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.kafka_connect.email}"
}

module "gce-container" {
  source           = "terraform-google-modules/container-vm/google"
  version          = "3.1.1"
  cos_image_family = "stable"
  cos_image_name   = "cos-stable-113-18244-85-65" # Pin underlying image to specific stable version as VMs are recreating everytime this project is checked for changes by terraform
  cos_project      = "cos-cloud"
  container = {
    image = var.kc_image
    env   = local.kc_env_list
  }
  restart_policy = var.restart_policy
}

module "mig_template" {
  source       = "terraform-google-modules/vm/google//modules/instance_template"
  version      = "11.1.0"
  project_id   = var.project_id
  region       = local.region
  network      = var.network
  subnetwork   = var.subnetwork
  machine_type = var.machine_type
  service_account = {
    email = google_service_account.kafka_connect.email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
  disk_size_gb         = var.disk_size_gb
  disk_type            = "pd-ssd"
  auto_delete          = true
  name_prefix          = "kc-${var.name}"
  source_image_project = "cos-cloud"
  source_image         = reverse(split("/", module.gce-container.source_image))[0]
  metadata = merge(var.kc_additional_metadata, {
    "gce-container-declaration" = module.gce-container.metadata_value
    "google-logging-enabled"    = "true"
    "cos-update-strategy"       = "update_disabled" # Disable COS updates. Enable once the broker issue is resolved
  })
  tags = [
    "kc-${var.name}",
    "confluent-cloud"
  ]
  labels = {
    container-vm = module.gce-container.vm_container_label
  }
}

module "mig" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "11.1.0"
  project_id        = var.project_id
  hostname          = "kc-${var.name}"
  region            = local.region
  instance_template = module.mig_template.self_link
  target_size       = var.kc_target_size
  update_policy = [{
    type                           = "PROACTIVE"
    instance_redistribution_type   = "PROACTIVE"
    minimal_action                 = "RESTART"
    most_disruptive_allowed_action = "REPLACE"
    max_surge_fixed                = 0
    max_surge_percent              = null
    max_unavailable_fixed          = 4
    max_unavailable_percent        = null
    min_ready_sec                  = 100
    replacement_method             = "SUBSTITUTE"
  }]
}

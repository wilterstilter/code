locals {
  subnet_components = split("/", var.subnetwork)
  region            = local.subnet_components[index(local.subnet_components, "regions") + 1]
}

module "gce_container" {
  source           = "terraform-google-modules/container-vm/google"
  version          = "3.1.1"
  cos_image_family = "stable"
  cos_image_name   = "cos-stable-113-18244-85-65" # Pin underlying image to specific stable version as VMs are recreating everytime this project is checked for changes by terraform
  cos_project      = "cos-cloud"
  restart_policy   = var.restart_policy
  container = {
    image = var.kc_image
    env = [
      for key, value in var.global_kafka_connect_env : {
        name  = key
        value = value
      }
    ]
  }
}

module "mig_templates" {
  for_each = var.mig_configs

  source               = "terraform-google-modules/vm/google//modules/instance_template"
  version              = "11.1.0"
  project_id           = var.project_id
  region               = local.region
  network              = var.network
  subnetwork           = var.subnetwork
  machine_type         = each.value.machine_type != null ? each.value.machine_type : var.machine_type
  disk_size_gb         = each.value.disk_size_gb != null ? each.value.disk_size_gb : var.disk_size_gb
  disk_type            = "pd-ssd"
  auto_delete          = true
  name_prefix          = "cdc-${each.key}"
  source_image_project = "cos-cloud"
  source_image         = reverse(split("/", module.gce_container.source_image))[0]
  service_account = {
    email  = var.service_account #google_service_account.kafka_connect.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  metadata = merge(var.global_kc_additional_metadata, each.value.additional_metadata, {
    "gce-container-declaration" = module.gce_container.metadata_value
    "google-logging-enabled"    = "true"
    "cos-update-strategy"       = "update_disabled" # Disable COS updates. Enable once the broker issue is resolved
  })
  tags = concat(["cdc-${each.key}", "confluent-cloud"], each.value.tags)
  labels = merge({
    container-vm = module.gce_container.vm_container_label
  }, each.value.labels)
}

module "migs" {
  for_each = var.mig_configs

  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "11.1.0"
  project_id        = var.project_id
  hostname          = "cdc-${each.key}"
  region            = local.region
  instance_template = module.mig_templates[each.key].self_link
  target_size       = each.value.target_size != null ? each.value.target_size : var.kc_target_size
  named_ports       = each.value.named_ports

  update_policy = [
    {
      type                           = "PROACTIVE"
      instance_redistribution_type   = "PROACTIVE"
      minimal_action                 = "RESTART"
      most_disruptive_allowed_action = "REPLACE"
      max_surge_fixed                = 0
      max_surge_percent              = null
      max_unavailable_fixed          = each.value.max_unavailable != null ? each.value.max_unavailable : 4
      max_unavailable_percent        = null
      min_ready_sec                  = 100
      replacement_method             = "SUBSTITUTE"
    }
  ]
}

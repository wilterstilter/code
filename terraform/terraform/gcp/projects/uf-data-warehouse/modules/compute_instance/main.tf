
# Generic SA for this pool
resource "google_service_account" "compute_instance" {
  project      = var.project_id
  account_id   = "compute-instance-${var.name}"
  display_name = "compute-instance GCE Service Account for pool ${var.name}"
}

resource "google_project_iam_member" "log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.compute_instance.email}"
}

resource "google_project_iam_member" "metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.compute_instance.email}"
}

module "gce_container" {
  for_each = var.instances
  source   = "terraform-google-modules/container-vm/google"
  version  = "3.1.1"

  # OS
  cos_image_name   = coalesce(try(each.value.cos_image_name, null), var.cos_image_name)
  cos_image_family = try(each.value.cos_image_name, null) == null ? try(each.value.cos_image_family, var.cos_image_family) : null
  cos_project      = coalesce(try(each.value.cos_project, null), var.cos_project)

  container = {
    # image = coalesce(try(each.value.container_image, null), var.container_image)
    # env = [for k, v in try(each.value.env, {}) : { name = k, value = v }]
  }

  restart_policy = var.restart_policy
}

resource "google_compute_instance" "vm" {
  for_each = var.instances
  project  = var.project_id
  zone     = coalesce(try(each.value.zone, null), var.zone)

  name         = coalesce(try(each.value.name, null), each.key)
  machine_type = coalesce(try(each.value.machine_type, null), var.machine_type)

  tags = distinct(
    concat(
      ["pool-${var.name}"],                  # <- note ${}
      coalesce(var.default_tags, []),        # <- never null
      coalesce(try(each.value.tags, []), []) # <- never null
    )
  )

  labels = merge(
    var.default_labels,
    try(each.value.labels, {}),
    { "container-vm" = module.gce_container[each.key].vm_container_label }
  )

  boot_disk {
    initialize_params {
      image = module.gce_container[each.key].source_image
      size  = coalesce(try(each.value.disk_size_gb, null), var.disk_size_gb)
      type  = coalesce(try(each.value.disk_type, null), var.disk_type)
    }
    auto_delete = true
  }

  network_interface {
    subnetwork         = coalesce(try(each.value.subnetwork, null), var.subnetwork)
    subnetwork_project = try(each.value.subnetwork_project, null)

    dynamic "alias_ip_range" {
      for_each = tolist(coalesce(try(each.value.alias_ip_ranges, []), []))
      content {
        ip_cidr_range         = alias_ip_range.value.ip_cidr_range
        subnetwork_range_name = try(alias_ip_range.value.subnetwork_range_name, null)
      }
    }

    dynamic "access_config" {
      for_each = try(each.value.assign_public_ip, false) ? [1] : []
      content {}
    }
  }

  service_account {
    email  = google_service_account.compute_instance.email
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }

  metadata = merge(
    var.additional_metadata,
    try(each.value.metadata, {}),
    {
      "gce-container-declaration" = module.gce_container[each.key].metadata_value
      "google-logging-enabled"    = "true"
      "cos-update-strategy"       = "update_disabled"
    }
  )

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
  }

  allow_stopping_for_update = true
  deletion_protection       = coalesce(each.value.deletion_protection, false)
}

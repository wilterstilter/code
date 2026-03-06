# main.tf

# This resource creates GCP Compute Instances optimized for Windows Server 2025 workloads.
# Enhanced to support multiple VMs with high availability features.

# Data source to get the latest image from the image family
# We only need one lookup per unique zone since the image is the same
data "google_compute_image" "os_image" {
  count   = var.boot_disk == null || try(var.boot_disk.initialize_params.image, null) == null ? 1 : 0
  family  = local.image_family
  project = local.image_project
}

# Data disks - created for each VM instance based on data_disks variable
resource "google_compute_disk" "data_disks" {
  for_each = merge([
    for inst in var.instances : {
      # Use instance-specific data_disks if provided, otherwise use module-level data_disks
      for idx, disk in(inst.data_disks != null ? inst.data_disks : var.data_disks) :
      "${inst.name}-${idx}" => merge(disk, {
        vm_name = inst.name
        zone    = inst.zone
        index   = idx
      })
    }
  ]...)

  name                      = each.value.name != null ? each.value.name : "${lower(trimspace(each.value.vm_name))}-datadisk-${each.value.index}"
  project                   = var.project_id
  zone                      = each.value.zone
  type                      = each.value.type != null ? each.value.type : "pd-balanced"
  size                      = each.value.size
  labels                    = each.value.labels != null ? each.value.labels : {}
  physical_block_size_bytes = each.value.physical_block_size_bytes != null ? each.value.physical_block_size_bytes : 4096

  # Encryption configuration
  dynamic "disk_encryption_key" {
    for_each = each.value.kms_key_self_link != null ? [1] : []
    content {
      kms_key_self_link = each.value.kms_key_self_link
    }
  }
}

# Compute Instances - one for each entry in var.instances
resource "google_compute_instance" "vms" {
  for_each = local.instances_map

  name         = lower(trimspace(each.value.name))
  machine_type = each.value.machine_type != null ? each.value.machine_type : var.machine_type
  zone         = each.value.zone
  project      = var.project_id

  # Tags - use instance-specific tags if provided, otherwise use default
  tags = each.value.tags != null ? each.value.tags : var.tags

  # Metadata - same for all instances
  metadata = local.metadata_with_startup

  # Labels - use instance-specific labels if provided, otherwise merge with defaults
  labels = each.value.labels != null ? merge(var.labels, each.value.labels) : var.labels

  # Allow stopping for updates
  allow_stopping_for_update = var.allow_stopping_for_update

  # Deletion protection
  deletion_protection = var.deletion_protection

  # Boot disk configuration
  dynamic "boot_disk" {
    for_each = [local.final_boot_disk_config]
    content {
      auto_delete = try(boot_disk.value.auto_delete, true)
      device_name = try(boot_disk.value.device_name, null)
      mode        = try(boot_disk.value.mode, null)

      # Disk encryption key
      disk_encryption_key_raw = try(boot_disk.value.disk_encryption_key_raw, null)
      kms_key_self_link       = try(boot_disk.value.kms_key_self_link, null)

      # Initialize params block
      dynamic "initialize_params" {
        for_each = try(boot_disk.value.initialize_params, null) != null ? [boot_disk.value.initialize_params] : []
        content {
          image                  = try(initialize_params.value.image, null)
          labels                 = try(initialize_params.value.labels, null)
          type                   = try(initialize_params.value.type, null)
          size                   = try(initialize_params.value.size, null)
          resource_manager_tags  = try(initialize_params.value.resource_manager_tags, null)
          provisioned_iops       = try(initialize_params.value.provisioned_iops, null)
          provisioned_throughput = try(initialize_params.value.provisioned_throughput, null)
        }
      }

      # Source for existing disks
      source = try(boot_disk.value.source, null)
    }
  }

  # Dynamic block for additional attached disks (for pre-existing disks)
  dynamic "attached_disk" {
    for_each = var.attached_disks
    content {
      source                  = attached_disk.value.source
      device_name             = attached_disk.value.device_name != null ? attached_disk.value.device_name : null
      mode                    = attached_disk.value.mode != null ? attached_disk.value.mode : "READ_WRITE"
      disk_encryption_key_raw = attached_disk.value.disk_encryption_key_raw
      kms_key_self_link       = attached_disk.value.kms_key_self_link
    }
  }

  # Dynamic block for data disks created by this module for this specific VM
  dynamic "attached_disk" {
    for_each = {
      for key, disk in google_compute_disk.data_disks :
      key => disk if startswith(key, "${each.value.name}-")
    }
    content {
      source      = attached_disk.value.self_link
      device_name = try(var.data_disks[tonumber(split("-", attached_disk.key)[length(split("-", attached_disk.key)) - 1])].device_name, "data-disk-${split("-", attached_disk.key)[length(split("-", attached_disk.key)) - 1]}")
      mode        = try(var.data_disks[tonumber(split("-", attached_disk.key)[length(split("-", attached_disk.key)) - 1])].mode, "READ_WRITE")
      disk_encryption_key_raw = try(
        var.data_disks[tonumber(split("-", attached_disk.key)[length(split("-", attached_disk.key)) - 1])].disk_encryption_key_raw,
        null
      )
      kms_key_self_link = try(
        var.data_disks[tonumber(split("-", attached_disk.key)[length(split("-", attached_disk.key)) - 1])].kms_key_self_link,
        null
      )
    }
  }

  # Network interfaces - use instance-specific if provided, otherwise use default
  dynamic "network_interface" {
    for_each = each.value.network_interfaces != null ? each.value.network_interfaces : var.network_interfaces

    content {
      network            = try(network_interface.value.network, null)
      subnetwork         = network_interface.value.subnetwork
      subnetwork_project = try(network_interface.value.subnetwork_project, null)
      network_ip         = try(network_interface.value.network_ip, null)
      nic_type           = try(network_interface.value.nic_type, null)
      stack_type         = try(network_interface.value.stack_type, null)
      queue_count        = try(network_interface.value.queue_count, null)

      # Dynamic block for alias IP ranges
      dynamic "alias_ip_range" {
        for_each = try(network_interface.value.alias_ip_range, null) != null ? [network_interface.value.alias_ip_range] : []
        content {
          ip_cidr_range         = alias_ip_range.value.ip_cidr_range
          subnetwork_range_name = try(alias_ip_range.value.subnetwork_range_name, null)
        }
      }
    }
  }

  # Service account
  dynamic "service_account" {
    for_each = local.service_account_email != null ? [1] : []
    content {
      email = local.service_account_email
      scopes = var.create_service_account && var.service_account_config != null ? [
        "https://www.googleapis.com/auth/cloud-platform"
      ] : (var.service_account != null ? var.service_account.scopes : [])
    }
  }

  # Scheduling options
  dynamic "scheduling" {
    for_each = var.scheduling != null ? [var.scheduling] : []
    content {
      automatic_restart           = try(scheduling.value.automatic_restart, true)
      on_host_maintenance         = try(scheduling.value.on_host_maintenance, "MIGRATE")
      preemptible                 = try(scheduling.value.preemptible, false)
      provisioning_model          = try(scheduling.value.provisioning_model, null)
      instance_termination_action = try(scheduling.value.instance_termination_action, null)

      dynamic "max_run_duration" {
        for_each = try(scheduling.value.max_run_duration_seconds, null) != null ? [scheduling.value.max_run_duration_seconds] : []
        content {
          seconds = max_run_duration.value
        }
      }

      dynamic "node_affinities" {
        for_each = try(scheduling.value.node_affinities, [])
        content {
          key      = node_affinities.value.key
          operator = node_affinities.value.operator
          values   = node_affinities.value.values
        }
      }

      dynamic "on_instance_stop_action" {
        for_each = try(scheduling.value.on_instance_stop_action, null) != null ? [scheduling.value.on_instance_stop_action] : []
        content {
          discard_local_ssd = try(on_instance_stop_action.value.discard_local_ssd, null)
        }
      }
    }
  }

  # Shielded instance config
  dynamic "shielded_instance_config" {
    for_each = var.shielded_instance_config != null ? [var.shielded_instance_config] : []
    content {
      enable_secure_boot          = try(shielded_instance_config.value.enable_secure_boot, false)
      enable_vtpm                 = try(shielded_instance_config.value.enable_vtpm, true)
      enable_integrity_monitoring = try(shielded_instance_config.value.enable_integrity_monitoring, true)
    }
  }

  # Advanced machine features
  dynamic "advanced_machine_features" {
    for_each = var.advanced_machine_features != null ? [var.advanced_machine_features] : []
    content {
      enable_nested_virtualization = try(advanced_machine_features.value.enable_nested_virtualization, false)
      threads_per_core             = try(advanced_machine_features.value.threads_per_core, null)
      visible_core_count           = try(advanced_machine_features.value.visible_core_count, null)
    }
  }

  # Guest accelerators (GPUs)
  dynamic "guest_accelerator" {
    for_each = var.guest_accelerators
    content {
      type  = guest_accelerator.value.type
      count = guest_accelerator.value.count
    }
  }

  # Resource policies
  resource_policies = var.resource_policies

  # Enable display device
  enable_display = var.enable_display

  # Confidential instance config
  dynamic "confidential_instance_config" {
    for_each = var.confidential_instance_config != null ? [var.confidential_instance_config] : []
    content {
      enable_confidential_compute = confidential_instance_config.value.enable_confidential_compute
    }
  }

  # Lifecycle rules
  lifecycle {
    ignore_changes = [
      metadata,
      labels,
      tags,
      boot_disk[0].guest_os_features,
    ]
  }
}

# Unmanaged Instance Groups - one per unique zone when enabled
resource "google_compute_instance_group" "instance_groups" {
  for_each = local.instance_groups

  name        = each.value.name
  zone        = each.value.zone
  project     = var.project_id
  description = "Unmanaged instance group for zone ${each.value.zone}"

  instances = each.value.instances

  dynamic "named_port" {
    for_each = var.instance_group_named_ports
    content {
      name = named_port.value.name
      port = named_port.value.port
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [google_compute_instance.vms]
}

# locals.tf

locals {
  # OS type normalization
  os_type_normalized = lower(trimspace(var.os_type))

  # Determine if this is a Windows or Linux deployment
  is_windows = contains(["windows2025", "windows"], local.os_type_normalized)
  is_linux   = !local.is_windows

  # OS-specific configuration map for 2 approved OSes
  os_config = {
    windows2025 = {
      image_family  = "windows-2025"
      image_project = "windows-cloud"
      disk_size     = 100
      disk_type     = "hyperdisk-balanced"
      metadata_key  = "windows-startup-script-ps1"
      os_label      = "windows-2025"
    }
    linux = {
      image_family  = "rhel-10"
      image_project = "rhel-cloud"
      disk_size     = 50
      disk_type     = "hyperdisk-balanced"
      metadata_key  = "startup-script"
      os_label      = "rhel-10"
    }
  }

  selected_os_config = local.is_windows ? local.os_config.windows2025 : (
    local.is_linux ? local.os_config.linux : null
  )

  image_family      = local.selected_os_config.image_family
  image_project     = local.selected_os_config.image_project
  default_disk_size = local.selected_os_config.disk_size
  default_disk_type = local.selected_os_config.disk_type
  metadata_key      = local.selected_os_config.metadata_key
  os_label          = local.selected_os_config.os_label

  # Boot disk configuration with OS-specific defaults
  boot_disk_config = var.boot_disk != null ? var.boot_disk : {
    auto_delete             = true
    device_name             = null
    mode                    = null
    disk_encryption_key_raw = null
    kms_key_self_link       = null
    initialize_params = {
      image = null # Will be set via data source lookup
      type  = local.default_disk_type
      size  = local.default_disk_size
      labels = {
        os = local.os_label
      }
      resource_manager_tags  = null
      provisioned_iops       = null
      provisioned_throughput = null
    }
    source = null
  }

  # Resolved image URL - use data source if no custom image specified
  resolved_image = var.boot_disk != null && try(var.boot_disk.initialize_params.image, null) != null ? (
    var.boot_disk.initialize_params.image
    ) : (
    try(data.google_compute_image.os_image[0].self_link, null)
  )

  # Final boot disk config with resolved image
  final_boot_disk_config = merge(
    local.boot_disk_config,
    {
      initialize_params = merge(
        local.boot_disk_config.initialize_params,
        {
          image = local.resolved_image
        }
      )
    }
  )

  # Determine the appropriate startup script key and content
  startup_script_content = try(var.startup_script, "")

  # Build metadata map with OS-specific key
  metadata_with_startup = local.startup_script_content != "" ? merge(
    var.metadata,
    {
      (local.metadata_key) = local.startup_script_content
    }
  ) : var.metadata

  # Create a map of instances keyed by name for easier lookups
  instances_map = { for idx, inst in var.instances : inst.name => merge(inst, { index = idx }) }

  # Extract unique zones from instances for image data source
  unique_zones = distinct([for inst in var.instances : inst.zone])

  # Group instances by zone for instance group creation
  instances_by_zone = {
    for zone in local.unique_zones : zone => [
      for inst in var.instances : inst.name if inst.zone == zone
    ]
  }

  # Generate instance group map when enabled
  instance_groups = var.create_instance_groups ? {
    for zone in local.unique_zones : zone => {
      name      = "${var.instance_group_name_prefix}-${zone}"
      zone      = zone
      instances = [for inst_name in local.instances_by_zone[zone] : google_compute_instance.vms[inst_name].self_link]
    }
  } : {}

  service_account_email = var.create_service_account && var.service_account_config != null ? (
    try(google_service_account.vm_service_account[0].email, null)
    ) : (
    var.service_account != null ? var.service_account.email : null
  )

}

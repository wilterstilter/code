# outputs.tf

# Outputs for multiple VM instances and instance groups

# All instances map with comprehensive details
output "instances" {
  description = "Map of all VM instances with their details, keyed by instance name."
  value = {
    for name, vm in google_compute_instance.vms : name => {
      instance_id          = vm.instance_id
      self_link            = vm.self_link
      name                 = vm.name
      zone                 = vm.zone
      machine_type         = vm.machine_type
      current_status       = vm.current_status
      cpu_platform         = vm.cpu_platform
      internal_ip          = try(vm.network_interface[0].network_ip, null)
      boot_disk            = try(vm.boot_disk[0].source, null)
      labels               = vm.labels
      tags_fingerprint     = vm.tags_fingerprint
      metadata_fingerprint = vm.metadata_fingerprint
    }
  }
}

# Instance IDs list
output "instance_ids" {
  description = "List of server-assigned unique identifiers of all instances."
  value       = [for vm in google_compute_instance.vms : vm.instance_id]
}

# Instance self links list
output "instance_self_links" {
  description = "List of self links of all instances."
  value       = [for vm in google_compute_instance.vms : vm.self_link]
}

# Instance names list
output "instance_names" {
  description = "List of names of all instances."
  value       = [for vm in google_compute_instance.vms : vm.name]
}

# Instance zones map
output "instance_zones" {
  description = "Map of instance names to their zones."
  value       = { for name, vm in google_compute_instance.vms : name => vm.zone }
}

# Internal IPs map
output "instance_internal_ips" {
  description = "Map of instance names to their internal (private) IP addresses."
  value = {
    for name, vm in google_compute_instance.vms : name => try(vm.network_interface[0].network_ip, null)
  }
}

# OS information
output "os_type" {
  description = "The operating system type deployed (windows2025 or rhel10)."
  value       = local.is_windows ? "windows2025" : "rhel10"
}

output "os_label" {
  description = "The OS label used for resource tagging."
  value       = local.os_label
}

output "image_family" {
  description = "The image family used for the boot disks."
  value       = local.image_family
}

# Data disks information
output "data_disks" {
  description = "Map of all data disks created by this module with their details."
  value = {
    for key, disk in google_compute_disk.data_disks : key => {
      self_link = disk.self_link
      id        = disk.id
      name      = disk.name
      size      = disk.size
      type      = disk.type
      zone      = disk.zone
    }
  }
}

output "data_disk_count" {
  description = "Total number of data disks created by this module."
  value       = length(google_compute_disk.data_disks)
}

# Instance Groups outputs
output "instance_groups" {
  description = "Map of unmanaged instance groups (if created) with their details, keyed by zone."
  value = var.create_instance_groups ? {
    for zone, ig in google_compute_instance_group.instance_groups : zone => {
      id        = ig.id
      self_link = ig.self_link
      name      = ig.name
      zone      = ig.zone
      size      = ig.size
      instances = ig.instances
    }
  } : {}
}

output "instance_group_self_links" {
  description = "List of self links of all instance groups (if created). Useful for load balancer backend configuration."
  value       = var.create_instance_groups ? [for ig in google_compute_instance_group.instance_groups : ig.self_link] : []
}

output "instance_groups_by_zone" {
  description = "Map of zones to their instance group self links (if created)."
  value = var.create_instance_groups ? {
    for zone, ig in google_compute_instance_group.instance_groups : zone => ig.self_link
  } : {}
}

# Summary outputs
output "total_instance_count" {
  description = "Total number of VM instances created."
  value       = length(google_compute_instance.vms)
}

output "unique_zones" {
  description = "List of unique zones where instances are deployed."
  value       = local.unique_zones
}

output "instances_by_zone" {
  description = "Map showing which instances are in each zone."
  value       = local.instances_by_zone
}

output "high_availability_enabled" {
  description = "Whether high availability features (instance groups) are enabled."
  value       = var.create_instance_groups
}

# User-managed service account outputs
output "service_account_email" {
  description = "Email of the user-managed service account (if created) or the provided service account email."
  value       = local.service_account_email
}

output "service_account_created" {
  description = "Whether a user-managed service account was created by this module."
  value       = var.create_service_account && var.service_account_config != null
}

output "service_account_name" {
  description = "Full resource name of the created user-managed service account (if created)."
  value       = var.create_service_account && var.service_account_config != null ? google_service_account.vm_service_account[0].name : null
}

output "service_account_unique_id" {
  description = "Unique ID of the created user-managed service account (if created)."
  value       = var.create_service_account && var.service_account_config != null ? google_service_account.vm_service_account[0].unique_id : null
}
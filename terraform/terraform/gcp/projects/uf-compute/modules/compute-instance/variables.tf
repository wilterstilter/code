# variables.tf

# This file defines all the input variables for the GCP Windows VM module.
# Enhanced to support multiple VMs with high availability features.

# List of VM instances to create
variable "instances" {
  description = "(Required) List of VM instances to create. Each instance can have its own zone/region configuration."
  type = list(object({
    name         = string           # (Required) The name of the VM instance
    zone         = string           # (Required) The GCP zone where the instance will be created (e.g., us-central1-a)
    machine_type = optional(string) # (Optional) Machine type override - uses var.machine_type if not specified
    network_interfaces = optional(list(object({
      network            = optional(string)
      subnetwork         = string
      subnetwork_project = optional(string)
      network_ip         = optional(string)
      nic_type           = optional(string)
      stack_type         = optional(string)
      queue_count        = optional(number)
      alias_ip_range = optional(object({
        ip_cidr_range         = string
        subnetwork_range_name = optional(string)
      }))
    })))                            # (Optional) Network interfaces override - uses var.network_interfaces if not specified
    tags   = optional(list(string)) # (Optional) Tags override - uses var.tags if not specified
    labels = optional(map(string))  # (Optional) Labels override - uses var.labels if not specified
    data_disks = optional(list(object({
      name                      = optional(string)
      type                      = optional(string)
      size                      = number
      labels                    = optional(map(string))
      physical_block_size_bytes = optional(number)
      disk_encryption_key_raw   = optional(string)
      kms_key_self_link         = optional(string)
      device_name               = optional(string)
      mode                      = optional(string)
    }))) # (Optional) Data disks override - uses var.data_disks if not specified
  }))

  validation {
    condition     = length(var.instances) > 0
    error_message = "At least one instance must be defined."
  }
}

# Operating System type selection
variable "os_type" {
  description = "(Required) The operating system to deploy. Valid values: 'windows2025' (or 'windows') for Windows Server 2025 Datacenter, 'el10' / 'rhel10' / 'linux' for Red Hat Enterprise Linux 10."
  type        = string
  nullable    = false

  validation {
    condition     = contains(["windows2025", "windows", "el10", "rhel10", "linux"], lower(trimspace(var.os_type)))
    error_message = <<EOT
The provided os_type "${var.os_type}" is invalid.
Supported values are:
  - For Windows Server 2025: "windows2025" or "windows"
  - For RHEL 10:            "el10", "rhel10", or "linux"
EOT
  }
}

# Optional startup script (OS-specific key determined automatically)
variable "startup_script" {
  description = "(Optional) Startup script for the instance. For Windows, provide PowerShell script. For Linux, provide bash script. The appropriate metadata key (windows-startup-script-ps1 or startup-script) is set automatically based on os_type."
  type        = string
  default     = ""
}

# Default machine type (can be overridden per instance)
variable "machine_type" {
  description = "(Required) Default machine type for instances (e.g., e2-medium, n2-standard-4). Can be overridden per instance."
  type        = string
}

# The project ID where the resources will be created
variable "project_id" {
  description = "(Optional) The ID of the GCP project where the VMs will be created. If not provided, the provider project is used."
  type        = string
  default     = null
}

# The boot disk configuration
variable "boot_disk" {
  description = "(Optional) Boot disk configuration. If not provided, defaults are automatically set based on os_type: Windows Server 2025 (100GB, pd-balanced) or RHEL 10 (50GB, pd-balanced)."
  type = object({
    auto_delete             = optional(bool)
    device_name             = optional(string)
    mode                    = optional(string)
    disk_encryption_key_raw = optional(string)
    kms_key_self_link       = optional(string)
    initialize_params = optional(object({
      image                  = optional(string)
      type                   = optional(string)
      size                   = optional(number)
      labels                 = optional(map(string))
      resource_manager_tags  = optional(map(string))
      provisioned_iops       = optional(number)
      provisioned_throughput = optional(number)
    }))
    source = optional(string)
  })
  default = null
}

# Additional attached disks (for pre-existing disks)
variable "attached_disks" {
  description = "(Optional) A list of pre-existing disks to attach to the instance. Use this for disks created outside this module."
  type = list(object({
    source                  = string
    device_name             = optional(string)
    mode                    = optional(string)
    disk_encryption_key_raw = optional(string)
    kms_key_self_link       = optional(string)
  }))
  default = []
}

# Data disks configuration - creates disks and attaches them automatically
variable "data_disks" {
  description = "(Optional) List of data disks to create and attach to each instance. Can be 0, 1, or multiple disks. Each disk will be created and attached automatically. Recommended: 500GB for standard Windows workloads."
  type = list(object({
    name                      = optional(string) # Defaults to {vm_name}-data-disk-{index}
    type                      = optional(string) # pd-standard, pd-balanced, pd-ssd
    size                      = number           # Size in GB (required)
    labels                    = optional(map(string))
    physical_block_size_bytes = optional(number)
    disk_encryption_key_raw   = optional(string)
    kms_key_self_link         = optional(string)
    device_name               = optional(string) # Defaults to data-disk-{index}
    mode                      = optional(string) # READ_WRITE or READ_ONLY
  }))
  default = []
}

# Default network interface configuration (can be overridden per instance)
variable "network_interfaces" {
  description = "(Optional) Default network interface configurations for instances. NOTE: For security, public IPs are not supported. Can be overridden per instance."
  type = list(object({
    network            = optional(string)
    subnetwork         = string
    subnetwork_project = optional(string)
    network_ip         = optional(string)
    nic_type           = optional(string)
    stack_type         = optional(string)
    queue_count        = optional(number)
    alias_ip_range = optional(object({
      ip_cidr_range         = string
      subnetwork_range_name = optional(string)
    }))
  }))
  default = []
}

# Default tags (can be overridden per instance)
variable "tags" {
  description = "(Optional) Default network tags to apply to instances for firewall rules. Can be overridden per instance."
  type        = list(string)
  default     = []
}

# Metadata to provide to the instances
variable "metadata" {
  description = "(Optional) Metadata key/value pairs. Common keys for Windows: windows-startup-script-ps1, windows-startup-script-cmd, sysprep-specialize-script-ps1."
  type        = map(string)
  default     = {}
}

# Default labels (can be overridden per instance)
variable "labels" {
  description = "(Optional) Default labels to assign to instances for organization and cost tracking. Can be overridden per instance."
  type        = map(string)
  default     = {}
}

# The service account configuration
variable "service_account" {
  description = "(Optional) The service account to attach to the instances. Recommended for production Windows VMs."
  type = object({
    email  = string
    scopes = list(string)
  })
  default = null
}

# Allow stopping for updates
variable "allow_stopping_for_update" {
  description = "(Optional) If true, allows Terraform to stop the instance to update its properties. Useful for Windows updates and configuration changes."
  type        = bool
  default     = true
}

# Deletion protection
variable "deletion_protection" {
  description = "(Optional) Enable deletion protection on instances to prevent accidental deletion."
  type        = bool
  default     = false
}

# Scheduling configuration
variable "scheduling" {
  description = "(Optional) The scheduling strategy for the instances. Important for Windows maintenance windows."
  type = object({
    automatic_restart           = optional(bool)
    on_host_maintenance         = optional(string)
    preemptible                 = optional(bool)
    provisioning_model          = optional(string)
    instance_termination_action = optional(string)
    max_run_duration_seconds    = optional(number)
    node_affinities = optional(list(object({
      key      = string
      operator = string
      values   = list(string)
    })))
    on_instance_stop_action = optional(object({
      discard_local_ssd = optional(bool)
    }))
  })
  default = null
}

# Shielded instance configuration
variable "shielded_instance_config" {
  description = "(Optional) The shielded VM configuration. Recommended for Windows security: enable vTPM and integrity monitoring."
  type = object({
    enable_secure_boot          = optional(bool)
    enable_vtpm                 = optional(bool)
    enable_integrity_monitoring = optional(bool)
  })
  default = {
    enable_secure_boot          = false
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
}

# Advanced machine features
variable "advanced_machine_features" {
  description = "(Optional) Advanced machine features for CPU configuration and nested virtualization (useful for Hyper-V on Windows)."
  type = object({
    enable_nested_virtualization = optional(bool)
    threads_per_core             = optional(number)
    visible_core_count           = optional(number)
  })
  default = null
}

# Guest accelerators (GPUs)
variable "guest_accelerators" {
  description = "(Optional) A list of guest accelerator cards to attach to the instances. Useful for GPU-accelerated Windows workloads."
  type = list(object({
    type  = string
    count = number
  }))
  default = []
}

# Resource policies
variable "resource_policies" {
  description = "(Optional) A list of resource policy URLs to attach to the instances (e.g., backup schedules)."
  type        = list(string)
  default     = []
}

# Enable display device
variable "enable_display" {
  description = "(Optional) Enable virtual display device. Useful for Windows GUI troubleshooting and RDP sessions."
  type        = bool
  default     = false
}

# Confidential instance configuration
variable "confidential_instance_config" {
  description = "(Optional) The confidential instance configuration for sensitive Windows workloads."
  type = object({
    enable_confidential_compute = bool
  })
  default = null
}

# Instance Group Configuration
variable "create_instance_groups" {
  description = "(Optional) Enable creation of unmanaged instance groups. When true, creates one instance group per unique zone containing all VMs in that zone. Required for load balancer backends and 99.99% SLA requirements."
  type        = bool
  default     = false
}

variable "instance_group_name_prefix" {
  description = "(Optional) Prefix for instance group names. Instance groups will be named as '{prefix}-{zone}'. Defaults to 'ig'."
  type        = string
  default     = "ig"
}

variable "instance_group_named_ports" {
  description = "(Optional) Named ports for the instance groups. Required for certain load balancer configurations."
  type = list(object({
    name = string
    port = number
  }))
  default = []
}

# User-managed service account creation configuration
variable "create_service_account" {
  description = "(Optional) Whether to create a new user-managed service account for the VMs. If false, you must provide an existing service account via var.service_account."
  type        = bool
  default     = false
}

variable "service_account_config" {
  description = "(Optional) Configuration for creating a user-managed service account. Only used if create_service_account is true."
  type = object({
    account_id   = string           # The service account ID (6-30 chars, lowercase, digits, hyphens)
    display_name = string           # Display name for the service account
    description  = optional(string) # Description of the service account
    project_roles = optional(list(string), [
      "roles/logging.logWriter",
      "roles/monitoring.metricWriter"
    ]) # IAM roles to grant at the project level
  })
  default = null

  validation {
    condition = var.service_account_config == null || (
      can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.service_account_config.account_id))
    )
    error_message = "Service account ID must be 6-30 characters, start with lowercase letter, and contain only lowercase letters, digits, and hyphens."
  }
}

# Storage bucket configuration
variable "storage_bucket_name" {
  description = "(Optional) Name of the Cloud Storage bucket to grant the service account access to. Required if VMs need to mount storage via rclone."
  type        = string
  default     = null
}

variable "storage_bucket_role" {
  description = "(Optional) IAM role to grant the service account on the storage bucket."
  type        = string
  default     = "roles/storage.objectAdmin" # Full read/write for rclone
}
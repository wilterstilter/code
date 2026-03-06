variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "name" {
  type        = string
  description = "The name of the kafka connect pool"
}

variable "subnetwork" {
  type        = string
  description = "Subnet self link"
}

variable "zone" {
  type        = string
  description = "default zone for the VMs"
  default     = "us-south1-a"
}

variable "machine_type" {
  description = "The machine type used for VMs"
  type        = string
  default     = "n2-standard-2"
}

variable "disk_size_gb" {
  description = "The default VMs disk size in Gb"
  type        = number
  default     = 50
}

variable "disk_type" {
  description = "The default VMs disk type"
  type        = string
  default     = "pd-ssd"
}

variable "restart_policy" {
  type        = string
  description = "The desired Docker restart policy for the runner image"
  default     = "always"
}

variable "cos_project" {
  type        = string
  description = "GCP project that hosts the Container-Optimized OS (COS) images used for the VM boot disk. Typically 'cos-cloud'."
  default     = "cos-cloud"
}

variable "cos_image_family" {
  type        = string
  description = "COS image family to track when not pinning an exact image (e.g., 'stable', 'lts', 'beta')."
  default     = "stable"
}

variable "cos_image_name" {
  description = "Exact COS image name to pin the VM. When set, this overrides cos_image_family; when null, the latest from the family is used."
  type        = string
  default     = "cos-stable-113-18244-85-65"
}

variable "additional_metadata" {
  type        = map(string)
  description = "Extra instance metadata to merge into the VM (key/value)."
  default     = {}
}

variable "default_tags" {
  type        = list(string)
  description = "Default tags to apply for VMs"
  default     = []
}

variable "default_labels" {
  type        = map(string)
  description = "Default labels to apply for VMs"
  default     = {}
}

# variable "container_image" { type        = string description = "Docker image (include SHA if not using latest)" default     = null}

variable "instances" {
  description = "One object per VM with overrides."
  type = map(object({
    zone = optional(string)
    name = string

    machine_type = optional(string)
    disk_size_gb = optional(number)
    disk_type    = optional(string)

    deletion_protection = optional(bool)

    container_image = optional(string)
    env             = optional(map(string))

    metadata = optional(map(string))
    tags     = optional(list(string))
    labels   = optional(map(string))

    cos_project      = optional(string)
    cos_image_family = optional(string)
    cos_image_name   = optional(string)

    network            = optional(string)
    subnetwork         = optional(string)
    subnetwork_project = optional(string)
    network_ip         = optional(string)
    alias_ip_ranges = optional(list(object({
      ip_cidr_range         = string
      subnetwork_range_name = optional(string)
    })))
  }))
}

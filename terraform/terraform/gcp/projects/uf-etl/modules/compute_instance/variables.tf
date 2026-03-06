variable "project_id" {
  description = "The GCP project"
  type        = string
}

variable "region" {
  description = "The GCP region to create and test resources in"
  type        = string
  default     = "us-south1"
}

variable "zone" {
  description = "The GCP zone to create resources in"
  type        = string
  default     = null
}

variable "network" {
  type        = string
  description = "VPC self link"
}

variable "subnetwork" {
  description = "The subnetwork selflink to host the compute instances in"
  type        = string
}

variable "num_instances" {
  description = "Number of instances to create"
  type        = string
}

variable "machine_type" {
  description = "The machine type used for VMs"
  type        = string
  default     = "n2-standard-2"
}

variable "disk_size_gb" {
  description = "The OS disk size in Gb"
  type        = number
  default     = 20
}

variable "hostname" {
  description = "The hostname of the VM"
  type        = string
  default     = ""
}
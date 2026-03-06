variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "network" {
  type        = string
  description = "VPC self link"
}

variable "subnetwork" {
  type        = string
  description = "Subnet self link"
}

variable "machine_type" {
  description = "The default machine type used for VMs if not specified in mig_configs"
  type        = string
  default     = "n2-standard-2"
}

variable "disk_size_gb" {
  description = "The default OS disk size in Gb if not specified in mig_configs"
  type        = number
  default     = 50
}

variable "kc_image" {
  type        = string
  description = "Kafka-connect Docker image (include SHA if not using latest)"
}

variable "kc_target_size" {
  description = "The default target number of running instances for kafka connect managed instance groups if not specified in mig_configs"
  type        = number
  default     = 2
}

variable "global_kc_additional_metadata" {
  type        = map(any)
  description = "Additional metadata to attach to all instances"
  default     = {}
}

variable "global_kafka_connect_env" {
  description = "Global Kafka connect env variables to be applied to all MIGs"
  type        = map(string)
  default     = {}
}

variable "restart_policy" {
  type        = string
  description = "The desired Docker restart policy for the runner image"
  default     = "always"
}

variable "service_account" {
  type        = string
  description = "Service account to be used by the MIG instances"
  default     = "confluent-kafka-sa@uf-data-warehouse-p.iam.gserviceaccount.com"
}

variable "mig_configs" {
  type = map(object({
    target_size         = optional(number)
    machine_type        = optional(string)
    disk_size_gb        = optional(number)
    additional_metadata = optional(map(any), {})
    named_ports         = optional(list(object({ name = string, port = number })), [])
    labels              = optional(map(string), {})
    tags                = optional(list(string), [])
    max_unavailable     = optional(number)
    env                 = optional(map(string), {}) # Environment variables specific to this MIG (not implemented in this version)
  }))
  description = "Map of MIG configurations, where the key is the MIG name."
}
variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "name" {
  type        = string
  description = "The name of the kafka connect pool"
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
  description = "The machine type used for VMs"
  type        = string
  default     = "n2-standard-2"
}

variable "disk_size_gb" {
  description = "The OS disk size in Gb"
  type        = number
  default     = 50
}

variable "kc_image" {
  type        = string
  description = "Kafka-connect Docker image (include SHA if not using latest)"
}

variable "kc_target_size" {
  description = "The target number of running instances for kafka connect managed instance group"
  type        = number
  default     = 2
}

variable "kc_additional_metadata" {
  type        = map(any)
  description = "Additional metadata to attach to the instance"
  default     = {}
}

variable "kafka_connect_env" {
  description = "Kafka connect env variables input map"
  type        = map(string)
}

variable "restart_policy" {
  type        = string
  description = "The desired Docker restart policy for the runner image"
  default     = "always"
}

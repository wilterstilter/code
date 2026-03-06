variable "project_id" {
  type        = string
  description = "Project ID"
}

variable "name" {
  type        = string
  description = "The name of the runner pool"
}

variable "region" {
  type        = string
  description = "Region to deploy virtual machines"
}

variable "network" {
  type        = string
  description = "VPC self link"
}

variable "subnetwork" {
  type        = string
  description = "Subnet self link"
}

variable "additional_metadata" {
  type        = map(any)
  description = "Additional metadata to attach to the instance"
  default     = {}
}

variable "gh_url" {
  type        = string
  description = "Repo or org URL for the Github Action"
}

variable "gh_token" {
  type        = string
  description = "Github token that is used for generating Self Hosted Runner Token"
}

variable "gh_pool" {
  type        = string
  default     = "Default"
  description = "Github Runners worker pool name"
}

variable "image" {
  type        = string
  description = "The github runner image"
}

variable "cos_source_image" {
  type        = string
  description = "The cos source image"
}

variable "restart_policy" {
  type        = string
  description = "The desired Docker restart policy for the runner image"
  default     = "always"
}

variable "dind" {
  type        = bool
  description = "Flag to determine whether to expose dockersock "
  default     = false
}

variable "min_replicas" {
  type        = number
  description = "The minimum number of runner instances"
  default     = 2
}

variable "max_replicas" {
  type        = number
  description = "The maximum number of runner instances"
  default     = 15
}

variable "cooldown_period" {
  description = "The number of seconds that the autoscaler should wait before it starts collecting information from a new instance."
  type        = number
  default     = 60
}

variable "machine_type" {
  description = "The machine type used for VMs"
  type        = string
  default     = "n2-standard-2"
}

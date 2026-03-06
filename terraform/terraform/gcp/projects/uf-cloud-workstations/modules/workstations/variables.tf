variable "project_id" {
  type        = string
  description = "Project Unique ID"
}

variable "name" {
  type        = string
  description = "Name of the cluster. This will be appended after the region."
}

variable "region" {
  type        = string
  description = "Refers to the region the workspace cluster will be deployed"
  default     = "us-west-8"
}

variable "replica_zones" {
  type        = list(string)
  description = "Refers to replication zones in the region chosen i.e. ['us-west-8-a', 'us-west-8-b'] in the us-west-8 region"
  default     = []
}

variable "network_id" {
  type        = string
  description = "Refers to the network id to be used when creating cluster"
}

variable "subnet_id" {
  type        = string
  description = "Refers to the network id to be used when creating cluster"
}

variable "labels" {
  type        = map(string)
  description = "Refers to the labels used in resource mapping"
}

variable "psc_ip" {
  type        = string
  description = "Private Service Connect IP address for the Workstation Gateway"
  default     = ""
}

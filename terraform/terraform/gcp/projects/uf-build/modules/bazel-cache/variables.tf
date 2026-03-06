variable "name" {
  type        = string
  description = "The name of the runner pool"
}

variable "region" {
  type        = string
  description = "Region to deploy virtual machines"
}

variable "service_accounts" {
  type        = list(string)
  description = "Service accounts that will have read/write access"
}

variable "groups" {
  type        = list(string)
  description = "Groups that will have read/write access"
}

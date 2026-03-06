variable "project_id" {
  type        = string
  description = "Project Unique name - like uf-bq-admin"
  nullable    = false
  sensitive   = false
}

variable "project_iam_bindings" {
  type = map(object({
    entities = list(string)
  }))
  default = {}
}

variable "service_account_iam_bindings" {
  type = map(object({
    entities = list(string)
  }))
  default = {}
}

variable "looker_service_account" {
  type        = string
  description = "Name of the service account on which binding has to be done."
  default     = ""
}

variable "looker_sa_project_id" {
  type        = string
  description = "Name of the project in which the service account resides."
  default     = ""
}
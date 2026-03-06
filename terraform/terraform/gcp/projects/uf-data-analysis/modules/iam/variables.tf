variable "project_id" {
  type        = string
  description = "Project Unique name - like uf-etl"
  nullable    = false
  sensitive   = false
}

variable "project_iam_bindings" {
  type = map(object({
    entities = list(string)
  }))
}

variable "service_account_iam_bindings" {
  type = map(object({
    entities = list(string)
  }))
  default = {}
}

variable "uf_freight_search_service_account" {
  type        = string
  description = "Name of the service account on which binding has to be done."
  default     = ""
}

variable "uf_freight_search_sa_project_id" {
  type        = string
  description = "Name of the project in which the service account resides."
  default     = ""
}

variable "bqviewers" {
  type        = list(string)
  description = "List of metadata viewers to be added to the project."
  default     = []
}

variable "bqreaders" {
  type        = list(string)
  description = "List of data readers to be added to the project."
  default     = []
}

variable "gemini_users" {
  type        = list(string)
  description = "List of gemini code assist users to be added to the project."
  default     = []
}

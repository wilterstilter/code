variable "project_id" {
  type        = string
  description = "Project Unique Name"
}

variable "custom_roles" {
  type    = list(string)
  default = []
}

variable "max_request_duration" {
  type        = string
  description = "Time Duation"
}

variable "entitlement_id" {
  type        = string
  description = "PAM Entitlement ID"
}

variable "eligible_requesters" {
  type        = list(string)
  description = "List of users/groups who can request access"
}

variable "approvers" {
  type        = list(string)
  description = "List of users/groups who can approve requests"
}

variable "parent_type" {
  type        = string
  description = "Name of Resource type like Project/Folder/Organization"
}

variable "parent_id" {
  type        = string
  description = "Name of Project/Folder/Organisation"
}

variable "role_bindings" {
  description = "List of roles to bind"
  type        = list(string)
}

variable "auto_approval" {
  description = "Whether to auto-approve the PAM role (true = auto-approve, false = require manual approval)"
  type        = bool
  default     = false
}

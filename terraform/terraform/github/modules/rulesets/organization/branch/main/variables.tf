variable "name" {
  type        = string
  description = "The name of the rule."
}

variable "include_repositories" {
  type        = list(string)
  description = "A list of repositories the rules apply to."
  default     = []
}

variable "exclude_repositories" {
  type        = list(string)
  description = "A list of repositories the rules should not apply to."
  default     = []
}

variable "required_linear_history" {
  type        = bool
  description = "Prevent merge commits from being pushed to matching refs."
  default     = true
}

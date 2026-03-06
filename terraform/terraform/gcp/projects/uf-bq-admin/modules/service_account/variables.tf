variable "service_accounts" {
  type = map(object({
    account_id   = string
    display_name = string
    generate_key = bool
  }))
}
variable "base_labels" {
  type        = map(string)
  description = "Base Labels to be added to all resource under this project"
  default     = {}
  sensitive   = false
  nullable    = false
}
variable "rules" {
  type = list(object({
    priority   = number
    action     = string
    expression = string
    rate_limit_options = optional(object({
      rate_limit_threshold = optional(object({
        count        = number
        interval_sec = number
      }))
      conform_action = optional(string)
      exceed_redirect_options = optional(object({
        type = string
      }))
      exceed_action       = optional(string)
      enforce_on_key      = optional(string)
      enforce_on_key_name = optional(string)
      enforce_on_key_configs = optional(list(object({
        key_type = string
      })))
      ban_duration_sec = optional(number)
      ban_threshold = optional(object({
        count        = number
        interval_sec = number
      }))
    }))
    description = string
    preview     = bool
  }))
  default = []
}

variable "name" {
  type = string
}

# Add variable declarations here

variable "region" {
  description = "The region for the Cloud Armor policy. If null, a global policy will be created."
  type        = string
  default     = null
}

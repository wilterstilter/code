variable "compartment_id" {
  description = "The OCID of the compartment"
  type        = string
}

# tflint-ignore: terraform_unused_declarations
variable "region" {
  description = "OCI region"
  type        = string
}

variable "policies" {
  description = "List of IAM policies to create"
  type = list(object({
    name        = string
    description = string
    statements  = list(string)
  }))
  default = []
}

variable "tags" {
  description = "Freeform tags to apply to resources"
  type        = map(string)
  default     = {}
}


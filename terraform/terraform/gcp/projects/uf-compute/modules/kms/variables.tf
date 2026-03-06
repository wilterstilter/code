####GCP KMS Variables
variable "project_id" {
  type        = string
  description = "The project name."
}
variable "key_ring_name" {
  type = string
}

variable "crypto_key_name" {
  type = string
}

variable "location" {
  type    = string
  default = "us-south1"
}

# variable "rotation_period" {
#   type    = string
#   default = "2592000s" # 30 days
# }

######End GCP KMS Variables
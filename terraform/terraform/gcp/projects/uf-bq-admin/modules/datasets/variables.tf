variable "env" {
  type        = string
  description = "Environment name to be used"
  nullable    = false
  sensitive   = false
  default     = ""
}

variable "base_labels" {
  type        = map(string)
  description = "Base Labels to be added to all resource under this project"
  default     = {}
  sensitive   = false
  nullable    = false
}

variable "bq_labels" {
  type        = map(string)
  description = "BigQuery Labels to be added to all resource deployed for Bigquery"
  default     = {}
  sensitive   = false
  nullable    = false
}

# BigQuery dataset/Namespace variables along with permission controls
variable "datasets" {
  type = list(object({

    # Dataset id name
    dataset_id                  = string
    layer                       = string
    description                 = string
    default_table_expiration_ms = number
    is_case_insensitive         = optional(bool, true)
    location                    = optional(string, "us-south1") #location/region to deploy the resources
    controls = map(object({
      entities = list(string)
    }))

  }))
  description = "BigQuery dataset ID"
}

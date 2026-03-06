variable "project_id" {
  type        = string
  description = "The project ID like -uf-data-warehouse"
  default     = ""
}

variable "views" {
  type = map(object({
    dataset_id = string
    table_id   = string
    query      = string
  }))

  description = "A map of BigQuery views to create."
  default     = {}
}
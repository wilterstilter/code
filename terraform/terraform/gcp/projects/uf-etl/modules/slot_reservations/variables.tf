variable "project_id" {
  type        = string
  description = "Project Unique Name - like uf-data-warehouse"
  nullable    = false
  sensitive   = false
}

variable "region" {

  type        = string
  description = "Region to deploy the resources"
  default     = "us-south1"
  sensitive   = false
  nullable    = false

}

variable "reservations" {
  type = list(object({
    name          = string
    slot_capacity = number
    max_slots     = number
    edition       = string
    assignments = list(object({
      assignee = string
      job_type = string
    }))
  }))
  description = "BigQuery reservations"
  default     = []
}

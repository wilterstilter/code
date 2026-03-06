variable "project_id" {
  type        = string
  description = "Project Unique Name - like uf-data-warehouse"
  nullable    = false
  sensitive   = false
}

variable "env" {
  type        = string
  description = "Environment name to be used"
  nullable    = false
  sensitive   = false
  default     = "dev"
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

variable "region" {

  type        = string
  description = "Region to deploy the resources"
  default     = "us-south1"
  sensitive   = false
  nullable    = false

}

variable "project_iam_bindings" {
  type = map(object({
    entities = list(string)
  }))
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
    # List of access entries (users/groups) and their roles for BigQuery for
    # bigQuery roles: [roles/bigquery.dataEditor, roles/bigquery.dataViewer]
    controls = map(object({
      entities = list(string)
    }))

  }))
  description = "BigQuery dataset ID"

  # Validation for BigQuery dataset roles
  validation {
    condition = alltrue(flatten([
      for dataset in var.datasets : [
        for role in keys(dataset.controls) :
        contains([
          "roles/bigquery.dataEditor",
          "roles/bigquery.dataViewer",
          "projects/uf-data-warehouse-d/roles/custom.namespace.editor.serviceAccount",
          "projects/uf-data-warehouse-n/roles/custom.namespace.editor.serviceAccount",
          "projects/uf-data-warehouse-p/roles/custom.namespace.editor",
          "projects/uf-data-warehouse-n/roles/custom.namespace.editor",
          "projects/uf-data-warehouse-d/roles/custom.namespace.editor",
          "projects/uf-data-warehouse-p/roles/custom.namespace.editor.serviceAccount",
          "projects/uf-data-warehouse-p/roles/custom.namespace.viewer"
        ], role)
      ]
    ]))
    error_message = "Roles for Bigquery must be one of dataViewer, dataEditor & custom roles"
  }

  # Validation for BigQuery dataset entities
  validation {
    condition = alltrue(flatten([
      for dataset in var.datasets : [
        for control in values(dataset.controls) : [
          for entity in control.entities : contains([
            # Not allowed for our use cases
            # "allUsers",
            # "allAuthenticatedUsers",
            "user",
            "serviceAccount",
            "group",
            "domain"
          ], split(":", entity)[0])
        ]
      ]
    ]))
    error_message = "Entities for Bigquery must start with either user, serviceAccount, group or domain"
  }
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

variable "bqreaders" {
  type        = list(string)
  description = "List of data readers to be added to the project."
  default     = []
}

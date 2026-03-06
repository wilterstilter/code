variable "project_id" {
  type        = string
  description = "Project ID where Cloud Composer Environment is created."
  nullable    = false
  sensitive   = false
}

variable "composer_env_name" {
  type        = string
  description = "Name of Cloud Composer Environment"
  nullable    = false
  sensitive   = false
  default     = ""
}

variable "region" {
  type        = string
  description = "Region where the Cloud Composer Environment is created."
  default     = "us-south1"
  sensitive   = false
  nullable    = false
}

variable "labels" {
  type        = map(string)
  description = "The resource labels (a map of key/value pairs) to be applied to the Cloud Composer."
  default     = {}
}
variable "airflow_config_overrides" {
  type        = map(string)
  description = "Airflow configuration properties to override. Property keys contain the section and property names, separated by a hyphen, for example \"core-dags_are_paused_at_creation\"."
  default     = {}
}

variable "env_variables" {
  type        = map(string)
  description = "Variables of the airflow environment."
  default     = {}
}

variable "image_version" {
  type        = string
  description = "The version of the aiflow running in the cloud composer environment."
  default     = ""
}

variable "pypi_packages" {
  type        = map(string)
  description = " Custom Python Package Index (PyPI) packages to be installed in the environment. Keys refer to the lowercase package name (e.g. \"numpy\")."
  default     = {}
}

variable "web_server_plugins_mode" {
  description = " Web server plugins configuration. Can be either 'ENABLED' or 'DISABLED'. Defaults to 'ENABLED'."
  type        = string
  default     = "ENABLED"
}

variable "maintenance_start_time" {
  description = "Time window specified for daily or recurring maintenance operations in RFC3339 format"
  type        = string
  default     = "03:00"
}

variable "maintenance_end_time" {
  description = "Time window specified for recurring maintenance operations in RFC3339 format"
  type        = string
  default     = "07:00"
}

variable "maintenance_recurrence" {
  description = "Frequency of the recurring maintenance window in RFC5545 format."
  type        = string
  default     = null
}

variable "environment_size" {
  type        = string
  description = "The environment size controls the performance parameters of the managed Cloud Composer infrastructure that includes the Airflow database. Values for environment size are: `ENVIRONMENT_SIZE_SMALL`, `ENVIRONMENT_SIZE_MEDIUM`, and `ENVIRONMENT_SIZE_LARGE`."
  default     = "ENVIRONMENT_SIZE_MEDIUM"
}

variable "scheduler" {
  type = object({
    cpu        = string
    memory_gb  = number
    storage_gb = number
    count      = number
  })
  default = {
    cpu        = 2
    memory_gb  = 7.5
    storage_gb = 5
    count      = 2
  }
  description = "Configuration for resources used by Airflow schedulers."
}

variable "web_server" {
  type = object({
    cpu        = string
    memory_gb  = number
    storage_gb = number
  })
  default = {
    cpu        = 2
    memory_gb  = 7.5
    storage_gb = 5
  }
  description = "Configuration for resources used by Airflow web server."
}

variable "worker" {
  type = object({
    cpu        = string
    memory_gb  = number
    storage_gb = number
    min_count  = number
    max_count  = number
  })
  default = {
    cpu        = 2
    memory_gb  = 7.5
    storage_gb = 5
    min_count  = 2
    max_count  = 6
  }
  description = "Configuration for resources used by Airflow workers."
}

variable "triggerer" {
  type = object({
    cpu       = string
    memory_gb = number
    count     = number
  })
  default     = null
  description = " Configuration for resources used by Airflow triggerer"
}

variable "dag_processor" {
  type = object({
    cpu        = string
    memory_gb  = number
    storage_gb = number
    count      = number
  })
  default     = null
  description = "Configuration for resources used by Airflow dag processor."
}

variable "storage_bucket" {
  description = "Name of an existing Cloud Storage bucket to be used by the environment"
  type        = string
  default     = null
}

variable "service_account" {
  description = "The service account to be used by the Composer Environment."
  type        = string
  default     = null
}

variable "network" {
  type        = string
  description = "VPC self link"
  default     = null
}

variable "subnetwork" {
  type        = string
  description = "Subnet self link"
  default     = null
}

variable "enable_private_environment" {
  description = "Create a private environment."
  type        = bool
  default     = true
}

variable "enable_private_builds_only" {
  description = "If true, builds performed during operations that install Python packages have only private connectivity to Google services. If false, the builds also have access to the internet."
  type        = bool
  default     = true
}

variable "composer_network_attachment" {
  description = "PSC (Private Service Connect) Network entry point."
  type        = string
  default     = null
}

variable "composer_internal_ipv4_cidr_block" {
  description = " /20 IPv4 cidr range that will be used by Composer internal components. Cannot be updated."
  type        = string
  default     = null
}

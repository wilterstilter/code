variable "project_id" {
  type        = string
  description = "The ID of the Google Cloud project."
}

variable "network_project_id" {
  type        = string
  description = "The ID of the Google Cloud Network project for Shared VPC."
}

variable "region" {
  type        = string
  description = "The GCP region where resources will be deployed, this must be the same region where the subnet exists."
}

variable "dataflow_job_name" {
  type        = string
  description = "Dataflow job name"
}

variable "dataflow_temp_bucket_name" {
  type        = string
  description = "GCS Bucket to write Dataflow temporary files. Must start and end with letter or number. Must be between 3 and 63 characters."
}

variable "topic_name" {
  type        = string
  description = "Name of the Pub/Sub Topic to receive logs from Google Cloud."
}

variable "subscription_name" {
  type        = string
  description = "Name of the Pub/Sub subscription to receive logs from Google Cloud."
}

variable "service_account" {
  type        = string
  description = "Name of the Service Account"
}

variable "controller_service_account" {
  type        = string
  description = "Name of the Controller Service Account"
}

variable "deadlettertopic" {
  type        = string
  description = "Name of the Pub/Sub Topic for unprocessed messages."
}

variable "deadlettersub" {
  type        = string
  description = "Name of the Pub/Sub subscription for the dead letter topic."
}

variable "network" {
  type        = string
  description = "Name of the VPC used for Dataflow Virtual Machines."
}

variable "subnetwork" {
  type        = string
  description = "Name of the subnets used for Dataflow Virtual Machines."
}

variable "datadog_api_key" {
  type        = string
  description = "Datadog API Key for integration."
  sensitive   = true
}

variable "datadog_site_url" {
  type        = string
  description = "Datadog Logs API URL, it will depends on the Datadog site region (https://docs.datadoghq.com/integrations/google_cloud_platform/#4-create-and-run-the-dataflow-job)."
}

variable "folder_id" {
  type        = string
  description = "Folder Name for logging."
}

variable "sinks" {
  description = "List of log sinks"
  type = list(object({
    name   = string
    filter = string
  }))
  default = []
}

variable "dataflow_template_version" {
  type        = string
  description = "Dataflow template version. Check https://cloud.google.com/dataflow/docs/release-notes/release-notes-templates for available versions. Changing this will recreate the job."
  default     = "2026-01-27-00_RC00"
}

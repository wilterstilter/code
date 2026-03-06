# Creates a logging sink for each entry in var.sinks, directing logs to a Pub/Sub topic
resource "google_logging_folder_sink" "datadog_export_sink" {
  for_each = { for sink in var.sinks : sink.name => sink }

  name             = "datadog-${each.value.name}"
  description      = "Folder Sink to route logs from GCP to Datadog."
  folder           = var.folder_id
  destination      = "pubsub.googleapis.com/projects/${var.project_id}/topics/${google_pubsub_topic.topic.name}"
  filter           = each.value.filter
  include_children = true
}

# Generates a random ID for unique resource naming
resource "random_id" "random" {
  byte_length = 4
}

# Creates a GCS bucket for temporary files used in Dataflow jobs
resource "google_storage_bucket" "temp_files_bucket" {
  name     = lower("${var.dataflow_temp_bucket_name}-${random_id.random.hex}")
  location = var.region

  uniform_bucket_level_access = true
  storage_class               = "STANDARD"
  public_access_prevention    = "enforced"
}

resource "google_pubsub_topic_iam_member" "logs_sa_publishing_permissions_folder" {
  project = var.project_id
  topic   = google_pubsub_topic.topic.id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:service-folder-${var.folder_id}@gcp-sa-logging.iam.gserviceaccount.com"
}
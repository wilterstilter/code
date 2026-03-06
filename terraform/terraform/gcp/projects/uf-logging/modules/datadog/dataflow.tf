# Creates a Dataflow job that streams data from a Pub/Sub subscription to Datadog
resource "google_dataflow_job" "pubsub_stream_to_datadog" {
  # Include template version in name to force new job creation on upgrades
  # This avoids incompatibility issues and makes it easy to track which template version is running
  name = "datadog-${var.dataflow_job_name}-${replace(replace(var.dataflow_template_version, "_", "-"), "/", "-")}"
  # Using pinned version instead of 'latest' for explicit version control
  # Changing the version in variables.tf will automatically trigger job recreation
  # Check for new versions: https://cloud.google.com/dataflow/docs/release-notes/release-notes-templates
  template_gcs_path       = "gs://dataflow-templates-${var.region}/${var.dataflow_template_version}/Cloud_PubSub_to_Datadog"
  temp_gcs_location       = "gs://${google_storage_bucket.temp_files_bucket.id}/tmp_dir"
  region                  = var.region
  service_account_email   = google_service_account.dataflow_worker.email
  network                 = var.network
  subnetwork              = var.subnetwork
  ip_configuration        = "WORKER_IP_PRIVATE"
  max_workers             = 3
  enable_streaming_engine = true
  parameters = {
    inputSubscription     = google_pubsub_subscription.subscription.id,
    url                   = var.datadog_site_url,
    apiKey                = var.datadog_api_key,
    apiKeySource          = "PLAINTEXT",
    outputDeadletterTopic = google_pubsub_topic.output_dead_letter.id
  }
  on_delete = "drain"

  lifecycle {
    create_before_destroy = true
  }
}

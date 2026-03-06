output "dataflow_job_name" {
  description = "The name of the created Dataflow job."
  value       = google_dataflow_job.pubsub_stream_to_datadog.name
}

output "temp_files_bucket_name" {
  description = "The name of the created temporary files bucket."
  value       = google_storage_bucket.temp_files_bucket.name
}

output "datadog_topic_name" {
  description = "The name of the created Pub/Sub topic."
  value       = google_pubsub_topic.topic.name
}

output "datadog_subscription_name" {
  description = "The name of the created Pub/Sub subscription."
  value       = google_pubsub_subscription.subscription.name
}

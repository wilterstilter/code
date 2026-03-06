# Create a Pub/Sub topic
resource "google_pubsub_topic" "topic" {
  name    = "datadog-${var.topic_name}"
  project = var.project_id
}

# Create a Pub/Sub subscription
resource "google_pubsub_subscription" "subscription" {
  name                       = "datadog-${var.subscription_name}"
  project                    = var.project_id
  topic                      = google_pubsub_topic.topic.name
  message_retention_duration = "604800s"
  retain_acked_messages      = false
  ack_deadline_seconds       = 60

  expiration_policy {
    ttl = "2678400s"
  }
}

# Creates a Pub/Sub topic for unprocessed messages
resource "google_pubsub_topic" "output_dead_letter" {
  name    = var.deadlettertopic
  project = var.project_id
}

# Creates a subscription to the dead letter topic with retention and expiration policies
resource "google_pubsub_subscription" "output_dead_letter_sub" {
  ack_deadline_seconds = 10

  expiration_policy {
    ttl = "2678400s"
  }

  message_retention_duration = "604800s"
  name                       = var.deadlettersub
  project                    = var.project_id
  topic                      = google_pubsub_topic.output_dead_letter.id
}

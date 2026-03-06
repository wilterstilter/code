# Please keep this notification channel name unique, if there is a need to add more email make a new notification channel

resource "google_monitoring_notification_channel" "email_channels" {
  for_each     = toset(var.emails)
  display_name = "UF data freight alerts Notification Channel"
  type         = "email"
  labels = {
    email_address = each.value
  }
}

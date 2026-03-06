variable "project_id" {
  type        = string
  description = "The name of the project"
  default     = ""
}

variable "emails" {
  type        = list(string)
  description = "The list of emails in the notification channel"
  default     = []
}

variable "project_ids_to_monitor" {
  type        = list(string)
  description = "List of project IDs to monitor"
  default     = []
}

variable "metrics_scope" {
  type        = string
  description = "The metrics scope project ID"
}

variable "alert_policies" {
  description = "List of alert policy configurations."
  type = list(object({
    display_name              = string # The display name of the alert policy. This is shown in the Cloud Monitoring console and in notifications.
    documentation_content     = string # The content of the alert policy's documentation, which provides details about the alert.
    documentation_mime_type   = string # The MIME type of the documentation content ('text/markdown').
    documentation_subject     = string # The subject line of the alert policy's documentation. This is often used in email notifications.
    filter                    = string # The Monitoring Filter string that specifies the time series to be monitored. This defines which metrics and resources the alert applies to.
    alignment_period          = string # The alignment period specifies how data points are aggregated. For example, '60s' means data points are aggregated into 60-second intervals.
    cross_series_reducer      = string # The method used to combine multiple time series into a single time series. For example, 'REDUCE_MEAN' calculates the average across time series.
    per_series_aligner        = string # The method used to align data points within each time series. For example, 'ALIGN_MEAN' calculates the average of data points within the alignment period.
    comparison                = string # The comparison operator used to compare the aggregated time series with the threshold value (e.g., 'COMPARISON_GT' for greater than, 'COMPARISON_LT' for less than).
    duration                  = string # The duration for which the condition must be true before an alert is triggered (e.g., '300s' for 5 minutes). '0s' means trigger immediately.
    threshold_value           = number # The value to compare the aggregated time series against. If the comparison is true for the specified duration, an alert is triggered.
    alert_strategy_auto_close = string # The duration after which an incident is automatically closed (e.g., '86400s' for 1 day).
    severity                  = string # The severity of the alert (e.g., 'CRITICAL', 'WARNING').
  }))
  default = []
}

variable "notification_channels" {
  type        = list(string)
  description = "The names of the notification channel to fetch."
}

variable "composer_env_name_dev" {
  type        = string
  description = "The name of the Cloud Composer environment."
}

variable "composer_project_id_dev" {
  type        = string
  description = "The project ID where the Composer environment resides."
}

resource "google_monitoring_alert_policy" "monitoring_alerts" {
  for_each     = { for policy in var.alert_policies : policy.display_name => policy }
  project      = var.project_id
  display_name = each.value.display_name
  documentation {
    content   = each.value.documentation_content
    mime_type = each.value.documentation_mime_type
    subject   = each.value.documentation_subject
  }

  conditions {
    display_name = "Condition for ${each.value.display_name}"
    condition_threshold {
      filter = replace(
        replace(
          each.value.filter,
          "__COMPOSER_PROJECT_ID_DEV__",
          var.composer_project_id_dev
        ),
        "__COMPOSER_ENV_NAME_DEV__",
        var.composer_env_name_dev
      )

      aggregations {
        alignment_period     = each.value.alignment_period
        cross_series_reducer = each.value.cross_series_reducer
        per_series_aligner   = each.value.per_series_aligner
      }

      comparison      = each.value.comparison
      duration        = each.value.duration
      threshold_value = each.value.threshold_value

      trigger {
        count = 1
      }
    }
  }

  alert_strategy {
    auto_close = each.value.alert_strategy_auto_close
  }

  combiner              = "OR"
  enabled               = true
  notification_channels = var.notification_channels
  severity              = each.value.severity
}

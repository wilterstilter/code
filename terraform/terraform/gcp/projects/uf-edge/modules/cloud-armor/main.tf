# Global Cloud Armor Policy (created if region is not passed)
resource "google_compute_security_policy" "global_policy" {
  count = var.region == null ? 1 : 0

  name = var.name
  type = "CLOUD_ARMOR"

  advanced_options_config {
    json_parsing = "STANDARD"
    log_level    = "VERBOSE"
  }

  adaptive_protection_config {
    layer_7_ddos_defense_config {
      enable          = true
      rule_visibility = "STANDARD"
    }
  }
}

# Regional Cloud Armor Policy (created if region is passed)
resource "google_compute_region_security_policy" "regional_policy" {
  count = var.region != null ? 1 : 0

  provider = google-beta

  name   = var.name
  type   = "CLOUD_ARMOR"
  region = var.region

}

resource "google_compute_security_policy_rule" "global_rule" {
  count = var.region == null ? length(var.rules) : 0

  security_policy = var.name
  priority        = var.rules[count.index].priority
  action          = var.rules[count.index].action
  match {
    expr {
      expression = var.rules[count.index].expression
    }
  }
  description = var.rules[count.index].description
  preview     = var.rules[count.index].preview

  dynamic "rate_limit_options" {
    for_each = var.rules[count.index].rate_limit_options != null ? [var.rules[count.index].rate_limit_options] : []
    content {
      rate_limit_threshold {
        count        = rate_limit_options.value.rate_limit_threshold != null ? rate_limit_options.value.rate_limit_threshold.count : null
        interval_sec = rate_limit_options.value.rate_limit_threshold != null ? rate_limit_options.value.rate_limit_threshold.interval_sec : null
      }
      conform_action = rate_limit_options.value.conform_action
      exceed_action  = rate_limit_options.value.exceed_action
      dynamic "exceed_redirect_options" {
        for_each = rate_limit_options.value.exceed_redirect_options != null ? [rate_limit_options.value.exceed_redirect_options] : []
        content {
          type = exceed_redirect_options.value.type
        }
      }
      enforce_on_key      = rate_limit_options.value.enforce_on_key
      enforce_on_key_name = rate_limit_options.value.enforce_on_key_name
      dynamic "enforce_on_key_configs" {
        for_each = var.rules[count.index].rate_limit_options != null && var.rules[count.index].rate_limit_options.enforce_on_key_configs != null ? var.rules[count.index].rate_limit_options.enforce_on_key_configs : []
        content {
          enforce_on_key_type = enforce_on_key_configs.value.key_type
        }
      }
      ban_duration_sec = rate_limit_options.value.ban_duration_sec

      dynamic "ban_threshold" {
        for_each = toset(rate_limit_options.value.ban_threshold != null ? ["ban_threshold"] : [])

        content {
          count        = rate_limit_options.value.ban_threshold.count
          interval_sec = rate_limit_options.value.ban_threshold.interval_sec
        }
      }
    }
  }
}

resource "google_compute_region_security_policy_rule" "regional_rule" {
  count = var.region != null ? length(var.rules) : 0

  provider = google-beta
  region   = var.region

  security_policy = var.name
  priority        = var.rules[count.index].priority
  action          = var.rules[count.index].action
  match {
    expr {
      expression = var.rules[count.index].expression
    }
  }
  description = var.rules[count.index].description
  preview     = var.rules[count.index].preview

  dynamic "rate_limit_options" {
    for_each = var.rules[count.index].rate_limit_options != null ? [var.rules[count.index].rate_limit_options] : []
    content {
      rate_limit_threshold {
        count        = rate_limit_options.value.rate_limit_threshold != null ? rate_limit_options.value.rate_limit_threshold.count : null
        interval_sec = rate_limit_options.value.rate_limit_threshold != null ? rate_limit_options.value.rate_limit_threshold.interval_sec : null
      }
      conform_action      = rate_limit_options.value.conform_action
      exceed_action       = rate_limit_options.value.exceed_action
      enforce_on_key      = rate_limit_options.value.enforce_on_key
      enforce_on_key_name = rate_limit_options.value.enforce_on_key_name
      dynamic "enforce_on_key_configs" {
        for_each = var.rules[count.index].rate_limit_options != null && var.rules[count.index].rate_limit_options.enforce_on_key_configs != null ? var.rules[count.index].rate_limit_options.enforce_on_key_configs : []
        content {
          enforce_on_key_type = enforce_on_key_configs.value.key_type
        }
      }
      ban_duration_sec = rate_limit_options.value.ban_duration_sec

      dynamic "ban_threshold" {
        for_each = toset(rate_limit_options.value.ban_threshold != null ? ["ban_threshold"] : [])

        content {
          count        = rate_limit_options.value.ban_threshold.count
          interval_sec = rate_limit_options.value.ban_threshold.interval_sec
        }
      }
    }
  }
}


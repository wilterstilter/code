# Create unique health checks based on configuration
# For TCP health checks with INTERNAL_MANAGED, use regional health checks
# For all others, use global health checks
locals {
  # Determine which health checks need to be regional (TCP + INTERNAL_MANAGED)
  regional_health_checks = {
    for k, v in var.health_check_configs : k => v
    if lookup(v, "type", "http") == "tcp" && var.load_balancing_scheme == "INTERNAL_MANAGED"
  }
  global_health_checks = {
    for k, v in var.health_check_configs : k => v
    if !(lookup(v, "type", "http") == "tcp" && var.load_balancing_scheme == "INTERNAL_MANAGED")
  }
}

# Global health checks (for HTTP or non-INTERNAL_MANAGED)
resource "google_compute_health_check" "default" {
  for_each = local.global_health_checks

  # Use the key from health_check_configs to generate the health check name
  name                = "hc-${each.key}"
  project             = var.project_id
  check_interval_sec  = each.value.check_interval_sec
  timeout_sec         = each.value.timeout_sec
  healthy_threshold   = each.value.healthy_threshold
  unhealthy_threshold = each.value.unhealthy_threshold

  # Conditionally create HTTP or TCP health check based on type
  dynamic "http_health_check" {
    for_each = lookup(each.value, "type", "http") == "http" ? [1] : []
    content {
      request_path = each.value.request_path
      port         = each.value.port
    }
  }

  dynamic "tcp_health_check" {
    for_each = lookup(each.value, "type", "http") == "tcp" ? [1] : []
    content {
      port = each.value.port
    }
  }
}

# Regional health checks (for TCP + INTERNAL_MANAGED)
resource "google_compute_region_health_check" "default" {
  for_each = local.regional_health_checks

  name                = "hc-${each.key}"
  project             = var.project_id
  region              = var.region
  check_interval_sec  = each.value.check_interval_sec
  timeout_sec         = each.value.timeout_sec
  healthy_threshold   = each.value.healthy_threshold
  unhealthy_threshold = each.value.unhealthy_threshold

  tcp_health_check {
    port = each.value.port
  }
}

# Dummy health check for backends without specific health checks
# This is a shared resource - if it already exists in GCP, import it first:
# terragrunt import 'google_compute_health_check.dummy' projects/PROJECT_ID/global/healthChecks/hc-dummy
resource "google_compute_health_check" "dummy" {
  name                = "hc-dummy"
  project             = var.project_id
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 2

  tcp_health_check {
    port = 80
  }

  lifecycle {
    # Prevent accidental deletion
    prevent_destroy = true
    # If this already exists in GCP with different settings, ignore the differences
    ignore_changes = [
      check_interval_sec,
      timeout_sec,
      healthy_threshold,
      unhealthy_threshold,
      tcp_health_check,
    ]
  }
}

# Create regional backend services
resource "google_compute_region_backend_service" "default" {
  for_each = var.backend_service_configs

  name                  = "rbs-${each.key}"
  project               = var.project_id
  region                = var.region
  protocol              = lookup(each.value, "protocol", var.protocol)       # Use per-backend protocol or fallback to module-level
  timeout_sec           = lookup(each.value, "timeout_sec", var.timeout_sec) # Use custom timeout or fallback to default
  load_balancing_scheme = var.load_balancing_scheme

  # Add session affinity settings based on protocol
  # TCP backends support CLIENT_IP, NONE, CLIENT_IP_PROTO, CLIENT_IP_PORT_PROTO
  # HTTP/HTTPS backends support GENERATED_COOKIE, CLIENT_IP, NONE, etc.
  session_affinity        = lookup(each.value, "session_affinity", lookup(each.value, "protocol", var.protocol) == "TCP" ? "CLIENT_IP" : "GENERATED_COOKIE")
  affinity_cookie_ttl_sec = lookup(each.value, "protocol", var.protocol) == "TCP" ? null : 86400 # 1 day for HTTP/HTTPS only

  # Connection draining for graceful shutdown
  connection_draining_timeout_sec = lookup(each.value, "connection_draining_timeout_sec", lookup(each.value, "protocol", var.protocol) == "TCP" ? 300 : null)

  # Dynamically reference health checks
  # Use regional health check for TCP + INTERNAL_MANAGED, otherwise use global
  health_checks = [
    contains(keys(google_compute_region_health_check.default), each.value.health_check_name) ?
    google_compute_region_health_check.default[each.value.health_check_name].self_link :
    (
      contains(keys(google_compute_health_check.default), each.value.health_check_name) ?
      google_compute_health_check.default[each.value.health_check_name].self_link :
      "https://www.googleapis.com/compute/v1/projects/${var.project_id}/global/healthChecks/hc-${each.value.health_check_name}"
    )
  ]

  dynamic "backend" {
    for_each = each.value.neg_names
    content {
      group                 = backend.value
      balancing_mode        = each.value.balancing_mode
      max_rate_per_endpoint = each.value.balancing_mode == "RATE" ? each.value.max_rate_per_endpoint : null
      capacity_scaler       = each.value.capacity_scaler
    }
  }

  # Add logging configuration based on the `logging` flag
  log_config {
    enable      = lookup(each.value, "logging", false)   # Default to false if not specified
    sample_rate = lookup(each.value, "sample_rate", 1.0) # Default to 1.0 if not specified
  }
}

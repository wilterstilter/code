# Global Backend Services for Multi-Region NEGs
# This module creates global backend services that can reference NEGs across multiple regions
# Used with Global Load Balancers (GLB) in uf-edge

#------------------------------------------------------------------------------
# Global Health Checks
#------------------------------------------------------------------------------
resource "google_compute_health_check" "default" {
  for_each = var.health_check_configs

  name                = "hc-${each.key}"
  project             = var.project_id
  check_interval_sec  = each.value.check_interval_sec
  timeout_sec         = each.value.timeout_sec
  healthy_threshold   = each.value.healthy_threshold
  unhealthy_threshold = each.value.unhealthy_threshold

  dynamic "http_health_check" {
    for_each = each.value.protocol == "HTTP" ? [1] : []
    content {
      request_path = each.value.request_path
      port         = each.value.port
    }
  }

  dynamic "https_health_check" {
    for_each = each.value.protocol == "HTTPS" ? [1] : []
    content {
      request_path = each.value.request_path
      port         = each.value.port
    }
  }

  dynamic "tcp_health_check" {
    for_each = each.value.protocol == "TCP" ? [1] : []
    content {
      port = each.value.port
    }
  }

  dynamic "grpc_health_check" {
    for_each = each.value.protocol == "GRPC" ? [1] : []
    content {
      port = each.value.port
    }
  }
}

#------------------------------------------------------------------------------
# Global Backend Services
# These can reference NEGs from multiple regions
#------------------------------------------------------------------------------
resource "google_compute_backend_service" "default" {
  for_each = var.backend_service_configs

  name                  = "gbs-${each.key}"
  project               = var.project_id
  protocol              = each.value.protocol
  port_name             = each.value.port_name
  timeout_sec           = each.value.timeout_sec
  load_balancing_scheme = var.load_balancing_scheme

  # Health check
  health_checks = [
    google_compute_health_check.default[each.value.health_check_name].self_link
  ]

  # Session affinity
  session_affinity = each.value.session_affinity

  # Connection draining
  connection_draining_timeout_sec = each.value.connection_draining_timeout_sec

  # Security policy (Cloud Armor) - optional
  security_policy = each.value.security_policy

  # Backends - NEGs from multiple regions (simple list like neg-backends)
  dynamic "backend" {
    for_each = each.value.neg_names
    content {
      group                 = backend.value
      balancing_mode        = each.value.balancing_mode
      max_rate_per_endpoint = each.value.max_rate_per_endpoint
      capacity_scaler       = each.value.capacity_scaler
    }
  }

  # Logging configuration
  log_config {
    enable      = each.value.logging_enabled
    sample_rate = each.value.logging_sample_rate
  }
}

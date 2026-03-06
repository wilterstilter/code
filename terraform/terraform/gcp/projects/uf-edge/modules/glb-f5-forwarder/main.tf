locals {
  name = replace(var.domain, ".", "-")
}

# Public IP for the GLB
resource "google_compute_global_address" "default" {
  name         = "glb-${local.name}"
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
}

# Create a global external load balancer
resource "google_compute_global_forwarding_rule" "default" {
  name                  = "glb-${local.name}"
  target                = google_compute_target_https_proxy.default.self_link
  port_range            = 443
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_address            = google_compute_global_address.default.id

  labels = {
    "team" : "network"
  }
}

# Create a SSL policy to prevent use of outdated versions of TLS
resource "google_compute_ssl_policy" "default" {
  name            = "glb-${local.name}"
  profile         = "MODERN"
  min_tls_version = var.min_tls_version
}

# Create a target HTTPS proxy
resource "google_compute_target_https_proxy" "default" {
  name             = "glb-${local.name}"
  url_map          = google_compute_url_map.default.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.default.id]
  ssl_policy       = google_compute_ssl_policy.default.id
}

# Create a URL map
resource "google_compute_url_map" "default" {
  name            = "glb-${local.name}"
  default_service = google_compute_backend_service.default.self_link

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.default.self_link
  }
}

# Create a backend service
resource "google_compute_backend_service" "default" {
  name                  = "glb-${local.name}"
  port_name             = "https"
  protocol              = "HTTPS"
  timeout_sec           = 10
  load_balancing_scheme = "EXTERNAL_MANAGED"

  dynamic "backend" {
    for_each = toset(var.default_service)
    content {
      group                 = backend.value
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 10
    }
  }
  security_policy = var.security_policy_self_link
  health_checks   = [google_compute_health_check.default.self_link]
}

# Static TCP health check on port 443
resource "google_compute_health_check" "default" {
  name                = "glb-${local.name}"
  check_interval_sec  = 30
  timeout_sec         = 30
  healthy_threshold   = 2
  unhealthy_threshold = 2

  tcp_health_check {
    port = var.health_check_port
  }
}

# Create a Google Managed SSL certificate
resource "google_compute_managed_ssl_certificate" "default" {
  name        = "glb-${local.name}"
  provider    = google
  description = "Managed SSL certificate for ${local.name}"
  managed {
    domains = [
      var.domain
    ]
  }

  lifecycle {
    create_before_destroy = true
  }
}

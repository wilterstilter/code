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
  name            = "glb-${local.name}"
  url_map         = google_compute_url_map.default.self_link
  certificate_map = "//certificatemanager.googleapis.com/projects/uf-edge-p/locations/global/certificateMaps/${google_certificate_manager_certificate_map.main.name}"
  ssl_policy      = google_compute_ssl_policy.default.id
}

locals {
  use_path_backends = length(var.path_backends) > 0
}

# Path-based backend services (only for explicit paths, e.g. /ptms)
resource "google_compute_backend_service" "path" {
  for_each              = local.use_path_backends ? var.path_backends : {}
  name                  = trim("glb-${local.name}-${replace(replace(replace(trim(each.key, "/"), "/", "-"), ".", "-"), "*", "")}", "-")
  port_name             = lookup(each.value, "health_protocol", "HTTPS") == "HTTP" ? "http" : "https"
  protocol              = lookup(each.value, "health_protocol", "HTTPS") == "HTTP" ? "HTTP" : "HTTPS"
  timeout_sec           = each.value.timeout_sec
  load_balancing_scheme = "EXTERNAL_MANAGED"

  dynamic "backend" {
    for_each = toset(each.value.neg_links)
    content {
      group                 = backend.value
      balancing_mode        = "RATE"
      max_rate_per_endpoint = lookup(each.value, "max_rate_per_endpoint", 80)
    }
  }

  log_config {
    enable      = lookup(each.value, "backend_log_enabled", true)
    sample_rate = lookup(each.value, "backend_log_sample_rate", 1.0)
  }

  security_policy = var.security_policy_self_link
  health_checks   = [google_compute_health_check.path[each.key].self_link]
}

# Default backend service (for all traffic if no path_backends, or as default if path_backends is set)
resource "google_compute_backend_service" "default" {
  count                 = local.use_path_backends ? 1 : 1
  name                  = "glb-${local.name}"
  port_name             = "https"
  protocol              = "HTTPS"
  timeout_sec           = var.default_backend_timeout_sec
  load_balancing_scheme = "EXTERNAL_MANAGED"
  dynamic "backend" {
    for_each = toset(var.default_service)
    content {
      group                 = backend.value
      balancing_mode        = "RATE"
      max_rate_per_endpoint = var.default_max_rate_per_endpoint
    }
  }

  log_config {
    enable      = var.default_backend_log_enabled
    sample_rate = var.default_backend_log_sample_rate
  }

  security_policy = var.security_policy_self_link
  health_checks   = [google_compute_health_check.default.self_link]
}

resource "google_compute_url_map" "default" {
  name = "glb-${local.name}"

  default_service = google_compute_backend_service.default[0].self_link

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_service.default[0].self_link

    dynamic "path_rule" {
      for_each = local.use_path_backends ? var.path_backends : {}
      content {
        paths   = [path_rule.key]
        service = google_compute_backend_service.path[path_rule.key].self_link
      }
    }
  }
}

# Static TCP health check on port 443
resource "google_compute_health_check" "default" {
  name                = "glb-${local.name}"
  check_interval_sec  = var.health_check_interval_sec
  timeout_sec         = var.health_check_timeout_sec
  healthy_threshold   = var.health_check_healthy_threshold
  unhealthy_threshold = var.health_check_unhealthy_threshold

  tcp_health_check {
    port = var.health_check_port
  }
}

# Path backend health check (HTTP/HTTPS)
resource "google_compute_health_check" "path" {
  for_each = var.path_backends

  name                = "glb-${local.name}-${replace(replace(replace(trim(each.key, "/"), "/", "-"), ".", "-"), "*", "")}-hc"
  check_interval_sec  = lookup(each.value, "health_check_interval_sec", 30)
  timeout_sec         = lookup(each.value, "health_check_timeout_sec", 30)
  healthy_threshold   = lookup(each.value, "healthy_threshold", 2)
  unhealthy_threshold = lookup(each.value, "unhealthy_threshold", 2)

  # HTTPS health check (default)
  dynamic "https_health_check" {
    for_each = lookup(each.value, "health_protocol", "HTTPS") == "HTTPS" ? [1] : []
    content {
      port         = each.value.health_port
      request_path = each.value.health_path
    }
  }

  # HTTP health check (when specified)
  dynamic "http_health_check" {
    for_each = lookup(each.value, "health_protocol", "HTTPS") == "HTTP" ? [1] : []
    content {
      port         = each.value.health_port
      request_path = each.value.health_path
    }
  }
}

resource "google_certificate_manager_dns_authorization" "main" {
  name   = "glb-${local.name}-dns-auth"
  domain = var.domain
}

resource "google_certificate_manager_certificate" "main" {
  name = "glb-${local.name}-cert"
  managed {
    domains            = [var.domain]
    dns_authorizations = [google_certificate_manager_dns_authorization.main.id]
  }
}

resource "google_certificate_manager_certificate_map" "main" {
  name = "glb-${local.name}-map"
}

resource "google_certificate_manager_certificate_map_entry" "main" {
  name         = "glb-${local.name}-entry"
  map          = google_certificate_manager_certificate_map.main.name
  certificates = [google_certificate_manager_certificate.main.id]
  hostname     = var.domain
}

# URL map specifically for the HTTP to HTTPS redirect
resource "google_compute_url_map" "redirect" {
  name = "glb-${local.name}-redirect"

  default_url_redirect {
    https_redirect         = true
    strip_query            = false
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
  }
}

# Target HTTP proxy for the redirect flow
resource "google_compute_target_http_proxy" "http_proxy" {
  name    = "glb-${local.name}-http-proxy"
  url_map = google_compute_url_map.redirect.self_link
}


# Forwarding rule for port 80 to handle and redirect HTTP traffic
resource "google_compute_global_forwarding_rule" "http_redirect" {
  name                  = "glb-${local.name}-http-redirect"
  target                = google_compute_target_http_proxy.http_proxy.self_link
  port_range            = "80"
  load_balancing_scheme = "EXTERNAL_MANAGED"

  # Use the same IP address as your HTTPS rule
  ip_address = google_compute_global_address.default.id

  labels = {
    "team" : "network"
  }
}
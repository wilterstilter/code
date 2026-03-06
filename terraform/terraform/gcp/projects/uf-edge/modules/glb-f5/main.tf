locals {
  name          = replace(var.domain, ".", "-")
  all_hostnames = concat([var.domain], var.additional_hostnames)
  # For wildcard hostnames (e.g., *.example.com), Certificate Manager requires DNS auth at the apex (example.com)
  additional_auth_domains = distinct([
    for h in var.additional_hostnames : startswith(h, "*.") ? replace(h, "*.", "") : h
  ])
  # Avoid duplicating the main authorization when the apex matches var.domain
  additional_auth_domains_filtered = [for d in local.additional_auth_domains : d if d != var.domain]
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
  timeout_sec           = var.backend_timeout_sec
  load_balancing_scheme = "EXTERNAL_MANAGED"

  dynamic "backend" {
    for_each = toset(var.default_service)
    content {
      group                 = backend.value
      balancing_mode        = "RATE"
      max_rate_per_endpoint = var.max_rate_per_endpoint
    }
  }
  security_policy = var.security_policy_self_link
  health_checks   = [google_compute_health_check.default.self_link]

  log_config {
    enable      = true
    sample_rate = 1.0 # 1.0 is log 100% of requests
  }
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

resource "google_certificate_manager_dns_authorization" "main" {
  name   = "glb-${local.name}-dns-auth"
  domain = var.domain
}

resource "google_certificate_manager_dns_authorization" "additional" {
  for_each = toset(local.additional_auth_domains_filtered)
  name     = substr("glb-${replace(each.value, ".", "-")}-dns-auth", 0, 63)
  domain   = each.value
}

resource "google_certificate_manager_certificate" "main" {
  name = "glb-${local.name}-cert"
  managed {
    domains            = [var.domain]
    dns_authorizations = [google_certificate_manager_dns_authorization.main.id]
  }
}

resource "google_certificate_manager_certificate" "multi" {
  count = length(var.additional_hostnames) > 0 ? 1 : 0
  name  = "glb-${local.name}-cert-multi"
  managed {
    domains = local.all_hostnames
    dns_authorizations = concat(
      [google_certificate_manager_dns_authorization.main.id],
      [for auth in google_certificate_manager_dns_authorization.additional : auth.id]
    )
  }
}

resource "google_certificate_manager_certificate_map" "main" {
  name = "glb-${local.name}-map"
}

resource "google_certificate_manager_certificate_map_entry" "main" {
  name         = "glb-${local.name}-entry"
  map          = google_certificate_manager_certificate_map.main.name
  certificates = length(var.additional_hostnames) > 0 ? [google_certificate_manager_certificate.multi[0].id] : [google_certificate_manager_certificate.main.id]
  hostname     = var.domain
}

resource "google_certificate_manager_certificate_map_entry" "additional" {
  for_each = toset(var.additional_hostnames)
  # Build a deterministic, short, valid name (<= 63 chars, lowercase letters, digits, hyphens)
  name         = substr("glb-${local.name}-e-${replace(replace(each.value, "*", "wildcard"), ".", "-")}", 0, 63)
  map          = google_certificate_manager_certificate_map.main.name
  certificates = length(var.additional_hostnames) > 0 ? [google_certificate_manager_certificate.multi[0].id] : [google_certificate_manager_certificate.main.id]
  hostname     = each.value
}

locals {
  # Use the first domain in the list to create a consistent name for resources
  name = replace(var.domains[0], ".", "-")
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

  dynamic "host_rule" {
    for_each = length(var.redirect_map) == 0 ? [1] : []
    content {
      hosts        = var.domains
      path_matcher = "allpaths"
    }
  }

  dynamic "path_matcher" {
    for_each = length(var.redirect_map) == 0 ? [1] : []
    content {
      name            = "allpaths"
      default_service = google_compute_backend_service.default.self_link
    }
  }

  dynamic "host_rule" {
    for_each = var.redirect_map
    content {
      hosts        = [host_rule.key]
      path_matcher = "redirect-${replace(host_rule.key, ".", "-")}"
    }
  }

  dynamic "path_matcher" {
    for_each = var.redirect_map
    content {
      name = "redirect-${replace(path_matcher.key, ".", "-")}"
      default_url_redirect {
        https_redirect         = true
        strip_query            = false
        redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
        host_redirect          = path_matcher.value
      }
    }
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
      group = backend.value
    }
  }
  security_policy = var.security_policy_self_link

  log_config {
    enable      = true
    sample_rate = 1.0 # 1.0 is log 100% of requests
  }
}

resource "random_id" "id" {
  byte_length = 2
}

resource "google_certificate_manager_dns_authorization" "main" {
  for_each = toset(var.domains)
  name     = "glb-${replace(each.value, ".", "-")}-dns-auth"
  domain   = each.value
}

resource "google_certificate_manager_certificate" "main" {
  name = "glb-${local.name}-cert"
  managed {
    domains            = var.domains
    dns_authorizations = [for auth in google_certificate_manager_dns_authorization.main : auth.id]
  }
}

resource "google_certificate_manager_certificate_map" "main" {
  name = "glb-${local.name}-map"
}

resource "google_certificate_manager_certificate_map_entry" "main" {
  name         = "glb-${local.name}-entry"
  map          = google_certificate_manager_certificate_map.main.name
  certificates = [google_certificate_manager_certificate.main.id]
  hostname     = var.domains[0]
}

resource "google_certificate_manager_certificate_map_entry" "additional" {
  for_each     = setsubtract(toset(var.domains), toset([var.domains[0]]))
  name         = "glb-${local.name}-entry-${replace(each.value, ".", "-")}"
  map          = google_certificate_manager_certificate_map.main.name
  certificates = [google_certificate_manager_certificate.main.id]
  hostname     = each.value
}

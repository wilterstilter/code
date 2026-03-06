# Cross-Region Load Balancer Module
# This module creates a Load Balancer that can distribute traffic
# across regional NEGs in multiple regions (e.g., us-south1, us-east4)
# Supports both EXTERNAL_MANAGED (internet-facing) and INTERNAL_MANAGED (VPC-internal cross-region)

locals {
  lb_name     = replace(var.domain, ".", "-")
  is_internal = var.load_balancing_scheme == "INTERNAL_MANAGED"
}

#------------------------------------------------------------------------------
# Global IP Address for External Load Balancer
#------------------------------------------------------------------------------
resource "google_compute_global_address" "frontend_ips_external" {
  for_each = !local.is_internal ? var.frontends : {}

  name         = "gclb-${local.lb_name}-${each.key}-ip"
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
}

#------------------------------------------------------------------------------
# Regional Internal IPs for Internal Load Balancer (one per region)
#------------------------------------------------------------------------------
resource "google_compute_address" "frontend_ips_internal" {
  for_each = local.is_internal ? {
    for pair in setproduct(keys(var.frontends), var.regions) : "${pair[0]}-${pair[1]}" => {
      frontend = pair[0]
      region   = pair[1]
    }
  } : {}

  name         = "ilb-${local.lb_name}-${each.value.frontend}-${each.value.region}"
  region       = each.value.region
  address_type = "INTERNAL"
  subnetwork   = var.lb_subnets[each.value.region]
  address      = lookup(var.frontends[each.value.frontend].ip_addresses, each.value.region, null)
  purpose      = "SHARED_LOADBALANCER_VIP"
}

#------------------------------------------------------------------------------
# Global Health Checks
#------------------------------------------------------------------------------
resource "google_compute_health_check" "health_checks" {
  for_each = var.health_checks

  name                = "hc-${local.lb_name}-${each.key}"
  project             = var.project_id
  check_interval_sec  = each.value.check_interval_sec
  timeout_sec         = each.value.timeout_sec
  healthy_threshold   = each.value.healthy_threshold
  unhealthy_threshold = each.value.unhealthy_threshold

  dynamic "http_health_check" {
    for_each = each.value.protocol == "HTTP" ? [1] : []
    content {
      request_path = each.value.path
      port         = each.value.port
    }
  }

  dynamic "https_health_check" {
    for_each = each.value.protocol == "HTTPS" ? [1] : []
    content {
      request_path = each.value.path
      port         = each.value.port
    }
  }

  dynamic "tcp_health_check" {
    for_each = each.value.protocol == "TCP" ? [1] : []
    content {
      port = each.value.port
    }
  }
}

#------------------------------------------------------------------------------
# Global Backend Services
# These can reference NEGs from multiple regions (us-south1, us-east4, etc.)
# OR reference existing backend services created elsewhere (e.g., uf-compute)
#------------------------------------------------------------------------------
resource "google_compute_backend_service" "backends" {
  for_each = { for k, v in var.backends : k => v if v.backend_service_self_link == null }

  name                  = "gclb-${local.lb_name}-${each.key}"
  project               = var.project_id
  protocol              = lookup(each.value, "protocol", "HTTP")
  port_name             = lookup(each.value, "port_name", "http")
  timeout_sec           = lookup(each.value, "timeout_sec", 30)
  load_balancing_scheme = var.load_balancing_scheme

  # Health check
  health_checks = each.value.health_check != null ? [
    google_compute_health_check.health_checks[each.value.health_check].self_link
  ] : null

  # Session affinity
  session_affinity        = lookup(each.value, "session_affinity", "GENERATED_COOKIE")
  affinity_cookie_ttl_sec = lookup(each.value, "affinity_cookie_ttl_sec", 86400)

  # Connection draining
  connection_draining_timeout_sec = lookup(each.value, "connection_draining_timeout_sec", 300)

  # Security policy (Cloud Armor) - only for EXTERNAL_MANAGED
  security_policy = !local.is_internal ? lookup(each.value, "security_policy", null) : null

  # Backends - NEGs from multiple regions
  dynamic "backend" {
    for_each = each.value.neg_links != null && length(each.value.neg_links) > 0 ? toset(each.value.neg_links) : []
    content {
      group                 = backend.value
      balancing_mode        = lookup(each.value, "balancing_mode", "RATE")
      max_rate_per_endpoint = lookup(each.value, "max_rate_per_endpoint", 100)
      capacity_scaler       = lookup(each.value, "capacity_scaler", 1.0)
    }
  }

  # Logging configuration
  log_config {
    enable      = lookup(each.value, "logging_enabled", true)
    sample_rate = lookup(each.value, "logging_sample_rate", 1.0)
  }
}

# Local to get backend service self-link (either created or external)
locals {
  backend_service_links = {
    for k, v in var.backends : k => (
      v.backend_service_self_link != null ? v.backend_service_self_link : google_compute_backend_service.backends[k].self_link
    )
  }
}

#------------------------------------------------------------------------------
# URL Map with Path-Based Routing (Global for both external and internal)
#------------------------------------------------------------------------------
# Global URL Map (used for both EXTERNAL_MANAGED and INTERNAL_MANAGED)
resource "google_compute_url_map" "default" {
  count   = 1
  name    = local.is_internal ? "ilb-${local.lb_name}" : "gclb-${local.lb_name}"
  project = var.project_id

  default_service = local.backend_service_links[var.frontends[keys(var.frontends)[0]].default_backend]

  # Dynamic host rules for each frontend
  dynamic "host_rule" {
    for_each = var.frontends
    iterator = frontend
    content {
      hosts        = ["*"] # Match all hosts to support both root domain and subdomains
      path_matcher = frontend.key
    }
  }

  # Dynamic path matchers for each frontend with path-based routing
  dynamic "path_matcher" {
    for_each = var.frontends
    iterator = frontend
    content {
      name            = frontend.key
      default_service = local.backend_service_links[frontend.value.default_backend]

      # Route rules for forbidden URIs
      dynamic "route_rules" {
        for_each = frontend.value.forbidden_uris
        iterator = forbidden
        content {
          priority = forbidden.value.priority
          match_rules {
            prefix_match = forbidden.value.path_pattern
          }
          route_action {
            fault_injection_policy {
              abort {
                http_status = forbidden.value.status_code
                percentage  = 100.0
              }
            }
          }
          service = local.backend_service_links[frontend.value.default_backend]
        }
      }

      # Route rules for valid paths with path-based routing
      dynamic "route_rules" {
        for_each = frontend.value.url_map
        iterator = route
        content {
          priority = route.value.priority
          match_rules {
            ignore_case  = true
            prefix_match = route.value.path
          }
          route_action {
            url_rewrite {
              host_rewrite        = try(route.value.host_rewrite, false) && frontend.value.port == 443 ? "${frontend.key}.${var.domain}" : null
              path_prefix_rewrite = try(route.value.path_prefix_rewrite, false) ? "/" : null
            }
            dynamic "cors_policy" {
              for_each = frontend.value.enable_cors ? [1] : []
              content {
                allow_credentials = true
                allow_headers     = ["*"]
                allow_methods     = ["GET", "POST", "PUT", "DELETE", "OPTIONS"]
                allow_origins     = ["*"]
                expose_headers    = ["*"]
                max_age           = 3600
                disabled          = false
              }
            }
          }
          dynamic "header_action" {
            for_each = frontend.value.port == 443 ? [1] : []
            content {
              request_headers_to_add {
                header_name  = "X-Forwarded-Proto"
                header_value = "https"
                replace      = true
              }
              response_headers_to_add {
                header_name  = "Strict-Transport-Security"
                header_value = "max-age=31536000; includeSubDomains; preload"
                replace      = true
              }
            }
          }
          service = local.backend_service_links[route.value.backend]
        }
      }
    }
  }
}

#------------------------------------------------------------------------------
# SSL Certificate
#------------------------------------------------------------------------------
resource "google_compute_managed_ssl_certificate" "default" {
  count = var.create_ssl_certificate && var.ssl_certificate_domains != null && !local.is_internal ? 1 : 0

  name = "gclb-${local.lb_name}-cert"

  managed {
    domains = var.ssl_certificate_domains
  }
}

#------------------------------------------------------------------------------
# Target HTTPS Proxy (Global for both external and internal)
#------------------------------------------------------------------------------
# Global HTTPS Proxy (used for both EXTERNAL_MANAGED and INTERNAL_MANAGED)
resource "google_compute_target_https_proxy" "https_proxy" {
  count = length([for k, v in var.frontends : k if v.port == 443]) > 0 ? 1 : 0

  name    = local.is_internal ? "ilb-${local.lb_name}-https-proxy" : "gclb-${local.lb_name}-https-proxy"
  project = var.project_id
  url_map = google_compute_url_map.default[0].self_link

  ssl_certificates = var.certificate_id == null ? (
    local.is_internal ? (
      var.ssl_certificate_ids
      ) : (
      var.create_ssl_certificate ? [google_compute_managed_ssl_certificate.default[0].self_link] : var.ssl_certificate_ids
    )
  ) : null

  certificate_manager_certificates = var.certificate_id != null ? [
    "//certificatemanager.googleapis.com/${var.certificate_id}"
  ] : null

  ssl_policy = var.ssl_policy
}

#------------------------------------------------------------------------------
# Target HTTP Proxy (for HTTP to HTTPS redirect - Global for both)
#------------------------------------------------------------------------------
# Global URL Map for HTTP redirect
resource "google_compute_url_map" "http_redirect" {
  count = length([for k, v in var.frontends : k if v.enable_http_redirect]) > 0 ? 1 : 0

  name    = local.is_internal ? "ilb-${local.lb_name}-http-redirect" : "gclb-${local.lb_name}-http-redirect"
  project = var.project_id

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "PERMANENT_REDIRECT"
    strip_query            = false
  }
}

# Global HTTP Proxy (used for both EXTERNAL_MANAGED and INTERNAL_MANAGED)
resource "google_compute_target_http_proxy" "http_proxy" {
  count = length([for k, v in var.frontends : k if v.enable_http_redirect]) > 0 ? 1 : 0

  name    = local.is_internal ? "ilb-${local.lb_name}-http-proxy" : "gclb-${local.lb_name}-http-proxy"
  project = var.project_id
  url_map = google_compute_url_map.http_redirect[0].self_link
}

# Global HTTP Proxy for direct HTTP traffic (no redirect)
resource "google_compute_target_http_proxy" "http_direct" {
  count = length([for k, v in var.frontends : k if v.port == 80]) > 0 ? 1 : 0

  name    = local.is_internal ? "ilb-${local.lb_name}-http-direct-proxy" : "gclb-${local.lb_name}-http-direct-proxy"
  project = var.project_id
  url_map = google_compute_url_map.default[0].self_link
}

#------------------------------------------------------------------------------
# Forwarding Rules (Global for external, Regional for internal)
#------------------------------------------------------------------------------
# Global Forwarding Rules for HTTPS (External)
resource "google_compute_global_forwarding_rule" "https_external" {
  for_each = !local.is_internal ? { for key, frontend in var.frontends : key => frontend if frontend.port == 443 } : {}

  name                  = "gclb-${local.lb_name}-${each.key}-https"
  project               = var.project_id
  ip_protocol           = "TCP"
  port_range            = "443"
  target                = google_compute_target_https_proxy.https_proxy[0].self_link
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_address            = google_compute_global_address.frontend_ips_external[each.key].address

  depends_on = [google_compute_global_address.frontend_ips_external]
}

# Global Forwarding Rules for HTTPS (Internal) - INTERNAL_MANAGED uses global forwarding rules
resource "google_compute_global_forwarding_rule" "https_internal" {
  for_each = local.is_internal ? {
    for pair in setproduct(keys(var.frontends), var.regions) : "${pair[0]}-${pair[1]}" => {
      frontend = pair[0]
      region   = pair[1]
    } if var.frontends[pair[0]].port == 443
  } : {}

  name                  = "ilb-${local.lb_name}-${each.value.frontend}-${each.value.region}-https"
  project               = var.project_id
  ip_protocol           = "TCP"
  port_range            = "443"
  target                = google_compute_target_https_proxy.https_proxy[0].self_link
  load_balancing_scheme = "INTERNAL_MANAGED"
  ip_address            = google_compute_address.frontend_ips_internal[each.key].address
  subnetwork            = var.lb_subnets[each.value.region]
  network               = var.network

  depends_on = [google_compute_address.frontend_ips_internal]
}

# Global Forwarding Rules for HTTP (External)
resource "google_compute_global_forwarding_rule" "http_external" {
  for_each = !local.is_internal ? { for key, frontend in var.frontends : key => frontend if frontend.port == 80 } : {}

  name                  = "gclb-${local.lb_name}-${each.key}-http"
  project               = var.project_id
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_target_http_proxy.http_direct[0].self_link
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_address            = google_compute_global_address.frontend_ips_external[each.key].address

  depends_on = [
    google_compute_global_address.frontend_ips_external,
    google_compute_target_http_proxy.http_direct
  ]
}

# Global Forwarding Rules for HTTP (Internal) - INTERNAL_MANAGED uses global forwarding rules
resource "google_compute_global_forwarding_rule" "http_internal" {
  for_each = local.is_internal ? {
    for pair in setproduct(keys(var.frontends), var.regions) : "${pair[0]}-${pair[1]}" => {
      frontend = pair[0]
      region   = pair[1]
    } if var.frontends[pair[0]].port == 80
  } : {}

  name                  = "ilb-${local.lb_name}-${each.value.frontend}-${each.value.region}-http"
  project               = var.project_id
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_target_http_proxy.http_direct[0].self_link
  load_balancing_scheme = "INTERNAL_MANAGED"
  ip_address            = google_compute_address.frontend_ips_internal[each.key].address
  subnetwork            = var.lb_subnets[each.value.region]
  network               = var.network

  depends_on = [
    google_compute_address.frontend_ips_internal,
    google_compute_target_http_proxy.http_direct
  ]
}
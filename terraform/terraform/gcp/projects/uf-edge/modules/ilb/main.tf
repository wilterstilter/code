locals {
  lb_name = replace(var.domain, ".", "-")
}

# Internal IP for the ILB
resource "google_compute_address" "frontend_ips" {
  for_each     = var.frontends
  name         = "ilb-${local.lb_name}-${each.key}-ip"
  region       = var.region
  address_type = "INTERNAL"
  subnetwork   = var.subnetwork
  address      = each.value.ip_address
  purpose      = "SHARED_LOADBALANCER_VIP"
}

# Create backend services
resource "google_compute_region_backend_service" "backends" {
  for_each = { for key, value in var.backends : key => value if value.cross_project_backend == null }

  name                  = "ilb-${local.lb_name}-${each.key}"
  provider              = google-beta
  port_name             = "http"
  protocol              = "HTTP"
  timeout_sec           = lookup(each.value, "timeout_sec", 30) # Use backend-specific timeout or default (30 seconds)
  load_balancing_scheme = "INTERNAL_MANAGED"
  region                = var.region

  # Add session affinity settings
  session_affinity        = "GENERATED_COOKIE"
  affinity_cookie_ttl_sec = 86400 # 1 day

  # Include backend block only if neg_links is provided and not empty
  dynamic "backend" {
    for_each = each.value.neg_links != null && length(each.value.neg_links) > 0 ? toset(each.value.neg_links) : []
    content {
      group                 = backend.value
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 10
      capacity_scaler       = 1.0
    }
  }

  # Include health checks only for local backends
  health_checks = each.value.health_check != null ? [
    google_compute_region_health_check.health_checks[each.value.health_check].self_link
  ] : null

  # Use the security policy passed from terragrunt.hcl, or default to null
  security_policy = lookup(each.value, "security_policy", null)

}



# Create health checks
resource "google_compute_region_health_check" "health_checks" {
  #  for_each = { for key, value in var.backends : key => value if value.health_check != null }
  for_each = { for key, value in var.backends : key => value if value.health_check != null && value.cross_project_backend == null }

  name                = "hc-${local.lb_name}-${each.key}"
  project             = var.project_id
  region              = var.region
  check_interval_sec  = 10
  timeout_sec         = 10
  healthy_threshold   = 2
  unhealthy_threshold = 2

  http_health_check {
    request_path = var.health_checks[each.value.health_check].path
    port         = var.health_checks[each.value.health_check].port
  }
}

# Create URL map
resource "google_compute_region_url_map" "default" {
  name   = "ilb-${local.lb_name}"
  region = var.region

  # Ensure a valid reference to the default backend
  default_service = contains(keys(var.backends), var.frontends[keys(var.frontends)[0]].default_backend) ? (
    var.backends[var.frontends[keys(var.frontends)[0]].default_backend].cross_project_backend != null ?
    var.backends[var.frontends[keys(var.frontends)[0]].default_backend].cross_project_backend :
    google_compute_region_backend_service.backends[var.frontends[keys(var.frontends)[0]].default_backend].self_link
  ) : null

  # Dynamic host rules for each frontend
  dynamic "host_rule" {
    for_each = var.frontends
    iterator = frontend
    content {
      hosts        = ["${frontend.key}.${var.domain}"]
      path_matcher = frontend.key
    }
  }

  # Dynamic path matchers for each frontend
  dynamic "path_matcher" {
    for_each = var.frontends
    iterator = frontend
    content {
      name = frontend.key

      # Ensure a valid reference to the default backend for the path matcher
      default_service = contains(keys(var.backends), frontend.value.default_backend) ? (
        var.backends[frontend.value.default_backend].cross_project_backend != null ?
        var.backends[frontend.value.default_backend].cross_project_backend :
        google_compute_region_backend_service.backends[frontend.value.default_backend].self_link
      ) : null

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

          # Service must still be defined, even if unused
          service = google_compute_region_backend_service.backends[frontend.value.default_backend].self_link
        }
      }

      # Route rules for valid paths
      dynamic "route_rules" {
        for_each = frontend.value.url_map
        iterator = route
        content {
          priority = route.value.priority

          match_rules {
            ignore_case  = true
            prefix_match = route.value.path
          }

          # Add cross-project backend logic
          route_action {
            dynamic "weighted_backend_services" {
              for_each = var.backends[route.value.backend].cross_project_backend != null ? [1] : []
              content {
                backend_service = var.backends[route.value.backend].cross_project_backend
                weight          = 100
              }
            }

            # URL rewrite logic
            url_rewrite {
              host_rewrite = try(route.value.host_rewrite, false) && frontend.value.port == 443 ? "${frontend.key}.${var.domain}:443" : null
              # Enable path_prefix_rewrite only if explicitly enabled in the frontend configuration
              path_prefix_rewrite = try(route.value.path_prefix_rewrite, false) ? "/" : null
            }
          }

          dynamic "header_action" {
            for_each = frontend.value.enable_https_redirects ? [1] : []
            content {
              request_headers_to_add {
                header_name  = "X-Forwarded-Port"
                header_value = "443"
                replace      = true
              }
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

          # Service reference for local backends only
          service = contains(keys(var.backends), route.value.backend) ? (
            var.backends[route.value.backend].cross_project_backend == null ?
            google_compute_region_backend_service.backends[route.value.backend].self_link :
            null
          ) : null
        }
      }
    }
  }
}

# Create HTTPS proxies for frontends with port 443
resource "google_compute_region_target_https_proxy" "https_proxy" {
  for_each = { for key, frontend in var.frontends : key => frontend if frontend.port == 443 }

  name   = "https-proxy-${local.lb_name}-${each.key}"
  region = var.region
  #url_map          = google_compute_region_url_map.default[each.key].self_link
  url_map                          = google_compute_region_url_map.default.self_link
  certificate_manager_certificates = ["//certificatemanager.googleapis.com/${var.certificate_id}"]
}

# Create HTTP proxies for frontends with port 80
resource "google_compute_region_target_http_proxy" "http_proxy" {
  for_each = { for key, frontend in var.frontends : key => frontend if frontend.port == 80 }

  name   = "http-proxy-${local.lb_name}-${each.key}"
  region = var.region
  #url_map = google_compute_region_url_map.default[each.key].self_link
  url_map = google_compute_region_url_map.default.self_link
}

# Create forwarding rules for HTTPS frontends (port 443)
resource "google_compute_forwarding_rule" "https" {
  for_each = { for key, frontend in var.frontends : key => frontend if frontend.port == 443 }

  name                  = "fr-${local.lb_name}-${each.key}-https"
  region                = var.region
  ip_protocol           = "TCP"
  port_range            = "443"
  target                = google_compute_region_target_https_proxy.https_proxy[each.key].self_link
  load_balancing_scheme = "INTERNAL_MANAGED"
  ip_address            = google_compute_address.frontend_ips[each.key].address # 🔥 Assign unique IP per frontend
  subnetwork            = var.subnetwork

  depends_on = [google_compute_address.frontend_ips]
}

resource "google_compute_forwarding_rule" "http" {
  for_each = { for key, frontend in var.frontends : key => frontend if frontend.port == 80 }

  name                  = "fr-${local.lb_name}-${each.key}-http"
  region                = var.region
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.http_proxy[each.key].self_link
  load_balancing_scheme = "INTERNAL_MANAGED"
  ip_address            = google_compute_address.frontend_ips[each.key].address # 🔥 Assign unique IP per frontend
  subnetwork            = var.subnetwork

  depends_on = [google_compute_address.frontend_ips]
}

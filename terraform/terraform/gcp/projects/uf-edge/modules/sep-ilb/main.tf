locals {
  name = replace(var.domain, ".", "-")
}

# Internal IP for the ILB
resource "google_compute_address" "default" {
  name         = "ilb-${local.name}"
  region       = var.region
  address_type = "INTERNAL"
  subnetwork   = var.subnetwork
  address      = var.address
}

# Create an internal load balancer for HTTPS
resource "google_compute_forwarding_rule" "https" {
  count                 = var.port == 443 ? 1 : 0
  name                  = "ilb-${local.name}"
  target                = google_compute_region_target_https_proxy.default[count.index].self_link
  port_range            = var.port
  load_balancing_scheme = "INTERNAL_MANAGED"
  ip_address            = google_compute_address.default.address
  region                = var.region
  network               = var.network
  subnetwork            = var.subnetwork
  network_tier          = "PREMIUM"
  depends_on            = [var.proxy_subnetwork]

  labels = {
    "team" : "network"
  }
}

# Create an internal load balancer for HTTP
resource "google_compute_forwarding_rule" "http" {
  count                 = var.port == 80 ? 1 : 0
  name                  = "ilb-${local.name}"
  target                = google_compute_region_target_http_proxy.default[count.index].self_link
  port_range            = var.port
  load_balancing_scheme = "INTERNAL_MANAGED"
  ip_address            = google_compute_address.default.address
  region                = var.region
  network               = var.network
  subnetwork            = var.subnetwork
  network_tier          = "PREMIUM"
  depends_on            = [var.proxy_subnetwork]

  labels = {
    "team" : "network"
  }
}

output "debug_certificate_id" {
  value = var.certificate_id
}

# Create a target HTTPS proxy
resource "google_compute_region_target_https_proxy" "default" {
  count                            = var.port == 443 ? 1 : 0
  name                             = "ilb-${local.name}"
  region                           = var.region
  url_map                          = google_compute_region_url_map.default.self_link
  certificate_manager_certificates = ["//certificatemanager.googleapis.com/${var.certificate_id}"]
}

# Create a target HTTP proxy
resource "google_compute_region_target_http_proxy" "default" {
  count   = var.port == 80 ? 1 : 0
  name    = "ilb-${local.name}"
  region  = var.region
  url_map = google_compute_region_url_map.default.self_link
}

# Create a URL map
resource "google_compute_region_url_map" "default" {
  name            = "ilb-${local.name}"
  default_service = google_compute_region_backend_service.default.self_link
  region          = var.region

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_region_backend_service.default.self_link

    # Dynamic block for forbidden paths (403 rejection)
    dynamic "route_rules" {
      for_each = { for key, value in var.url_map : key => value if length(lookup(value, "forbidden_uris", [])) > 0 }
      iterator = route
      content {
        priority = index(keys(var.url_map), route.key) + 1 # Ensures blocking happens first

        # Loop over each forbidden URI and create a match rule
        dynamic "match_rules" {
          for_each = route.value.forbidden_uris
          iterator = uri
          content {
            ignore_case  = true
            prefix_match = uri.value
          }
        }

        service = google_compute_region_backend_service.default.self_link

        route_action {
          fault_injection_policy {
            abort {
              http_status = 403
              percentage  = 100.0
            }
          }
        }
      }
    }

    # Dynamic block for valid service routes
    dynamic "route_rules" {
      for_each = var.url_map
      iterator = route
      content {
        priority = index(keys(var.url_map), route.key) + 100 # Higher priority for normal routes

        match_rules {
          ignore_case  = true
          prefix_match = route.key
        }

        dynamic "route_action" {
          for_each = route.value.cross_project_backend != "" ? [1] : []
          content {
            weighted_backend_services {
              backend_service = route.value.cross_project_backend
              weight          = 100
            }
            url_rewrite {
              path_prefix_rewrite = "/"
            }
          }
        }
        #        service = google_compute_region_backend_service.path[route.key].self_link

        # Implement Host header modification only if enabled
        dynamic "route_action" {
          for_each = var.enable_host_rewrite ? [1] : []
          content {
            url_rewrite {
              host_rewrite = "${var.domain}:443"
            }
          }
        }

        #  HTTPS enforcement within valid service routes (conditionally)
        dynamic "header_action" {
          for_each = var.enable_https_redirects ? [1] : [] # Only apply when enabled
          content {
            response_headers_to_add {
              header_name  = "Location"
              header_value = replace("$LOCATION", "http://", "https://")
              replace      = true
            }
          }
        }

        service = route.value.cross_project_backend != "" ? null : google_compute_region_backend_service.path[route.key].self_link

      }
    }
  }
}

resource "google_compute_region_backend_service" "default" {
  name                  = "ilb-${local.name}"
  port_name             = "http"
  protocol              = "HTTP"
  timeout_sec           = 10
  load_balancing_scheme = "INTERNAL_MANAGED"
  region                = var.region

  dynamic "backend" {
    for_each = toset(var.default_service)
    content {
      group                 = backend.value
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 10
      capacity_scaler       = 1.0
    }
  }
  health_checks = [google_compute_region_health_check.default_backend.self_link]
}

# Create a health check for the default backend
resource "google_compute_region_health_check" "default_backend" {
  name                = "ilb-${local.name}-default-backend"
  project             = var.project_id
  region              = var.region
  check_interval_sec  = 10
  timeout_sec         = 10
  healthy_threshold   = 2
  unhealthy_threshold = 2

  http_health_check {
    request_path = var.default_hc_path
    port         = var.default_hc_port
  }
}


resource "google_compute_region_backend_service" "path" {
  for_each = var.url_map

  name                  = "ilb-${local.name}-${replace(replace(replace(trim(each.key, "/"), "/", "-"), "*", ""), ".", "")}"
  port_name             = "http"
  protocol              = "HTTP"
  timeout_sec           = 10
  load_balancing_scheme = "INTERNAL_MANAGED"
  region                = var.region

  dynamic "backend" {
    for_each = toset(each.value.neg_links)
    content {
      group                 = backend.value
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 10
      capacity_scaler       = 1.0
    }
  }
  health_checks = [google_compute_region_health_check.default[each.key].self_link]
}

# Create a health check
resource "google_compute_region_health_check" "default" {
  for_each = var.url_map

  name                = "ilb-${local.name}-${replace(replace(replace(trim(each.key, "/"), "/", "-"), "*", ""), ".", "")}"
  project             = var.project_id
  region              = var.region
  check_interval_sec  = 10
  timeout_sec         = 10
  healthy_threshold   = 2
  unhealthy_threshold = 2

  http_health_check {
    request_path = each.value.health_check_path
    port         = each.value.health_check_port
  }
}

# URL map for the HTTP redirect load balancer
resource "google_compute_region_url_map" "http_redirect" {
  name   = var.http_redirect_lb_name
  region = var.region

  # Default URL redirect block
  default_url_redirect {
    https_redirect         = true
    host_redirect          = var.domain           # Redirect to HTTPS for the same domain
    redirect_response_code = "PERMANENT_REDIRECT" # HTTP 308 Permanent Redirect
    strip_query            = false                # Retain query parameters
  }

  # Dynamic host rules for each frontend
  dynamic "host_rule" {
    for_each = { for key, frontend in var.frontends : key => frontend if frontend.enable_https_redirects }
    content {
      hosts        = ["${host_rule.key}.${var.domain}"] # Hostname for the frontend
      path_matcher = host_rule.key
    }
  }

  # Dynamic path matchers for each frontend
  dynamic "path_matcher" {
    for_each = { for key, frontend in var.frontends : key => frontend if frontend.enable_https_redirects }
    content {
      name = path_matcher.key

      # Redirect all paths to HTTPS
      default_url_redirect {
        https_redirect         = true
        host_redirect          = "${path_matcher.key}.${var.domain}" # Redirect to HTTPS for the specific domain
        redirect_response_code = "PERMANENT_REDIRECT"                # HTTP 308 Permanent Redirect
        strip_query            = false                               # Retain query parameters
      }
    }
  }
}

# Target HTTP proxy for the HTTP redirect load balancer
resource "google_compute_region_target_http_proxy" "http_redirect_proxy" {
  name    = "http-to-https-redirect-proxy-${var.http_redirect_lb_name}"
  region  = var.region
  url_map = google_compute_region_url_map.http_redirect.self_link
}

# Forwarding rules for HTTP traffic (port 80) for all frontends with HTTPS redirection enabled
resource "google_compute_forwarding_rule" "http_redirect" {
  for_each = { for key, frontend in var.frontends : key => frontend if frontend.enable_https_redirects }

  name                  = "http-redirect-rule-${each.key}"
  region                = var.region
  ip_protocol           = "TCP"
  port_range            = "80" # Handle HTTP traffic
  target                = google_compute_region_target_http_proxy.http_redirect_proxy.self_link
  load_balancing_scheme = "INTERNAL_MANAGED"
  ip_address            = google_compute_address.frontend_ips[each.key].address # Use the IP from the frontend
  subnetwork            = var.subnetwork
}


locals {
  name   = replace(var.domain, ".", "-")
  region = element(split("/", var.service_attachment_uri), 3)
}

resource "google_compute_region_network_endpoint_group" "default" {
  name   = "psc-${local.name}"
  region = local.region

  network_endpoint_type = "PRIVATE_SERVICE_CONNECT"
  psc_target_service    = var.service_attachment_uri

  network    = var.network
  subnetwork = var.subnetwork
}

# Reserve IP address for load balancer.
resource "google_compute_address" "default" {
  name   = "psc-${local.name}"
  region = local.region
}

# Create load balancer backend service
resource "google_compute_region_backend_service" "default" {
  name                  = "psc-${local.name}"
  region                = local.region
  load_balancing_scheme = "EXTERNAL_MANAGED"

  backend {
    group           = google_compute_region_network_endpoint_group.default.id
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }

  protocol    = "HTTPS"
  timeout_sec = 10
}

# Create url map
resource "google_compute_region_url_map" "default" {
  name            = "psc-${local.name}"
  region          = local.region
  default_service = google_compute_region_backend_service.default.id
}

# Self-signed regional SSL certificate
resource "google_certificate_manager_dns_authorization" "default" {
  name     = "psc-${local.name}"
  location = local.region
  type     = "PER_PROJECT_RECORD"
  domain   = var.domain
}

resource "google_certificate_manager_certificate" "default" {
  name     = "psc-${local.name}"
  location = local.region
  managed {
    domains = [
      google_certificate_manager_dns_authorization.default.domain,
      "*.${google_certificate_manager_dns_authorization.default.domain}"
    ]
    dns_authorizations = [
      google_certificate_manager_dns_authorization.default.id
    ]
  }
}

# Create a SSL policy to prevent use of outdated versions of TLS
resource "google_compute_region_ssl_policy" "default" {
  name            = "psc-${local.name}"
  region          = local.region
  profile         = "MODERN"
  min_tls_version = "TLS_1_2"
}

# Create HTTPS target proxy
resource "google_compute_region_target_https_proxy" "default" {
  name    = "psc-${local.name}"
  region  = local.region
  url_map = google_compute_region_url_map.default.id

  certificate_manager_certificates = [
    google_certificate_manager_certificate.default.id
  ]

  ssl_policy = google_compute_region_ssl_policy.default.id
}

# Create forwarding rule
resource "google_compute_forwarding_rule" "default" {
  name                  = "psc-${local.name}"
  region                = local.region
  network               = var.network
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "443"
  target                = google_compute_region_target_https_proxy.default.id
  ip_address            = google_compute_address.default.id
}


resource "google_compute_global_network_endpoint_group" "default" {
  project               = var.project_id
  name                  = var.name
  network_endpoint_type = var.network_endpoint_type
  default_port          = var.port
}

resource "google_compute_global_network_endpoint" "ip_endpoint" {
  for_each = var.network_endpoint_type == "INTERNET_IP_PORT" ? toset(var.ip_addresses) : toset([])

  project                       = var.project_id
  global_network_endpoint_group = google_compute_global_network_endpoint_group.default.name
  port                          = var.port
  ip_address                    = each.value
}

resource "google_compute_global_network_endpoint" "fqdn_endpoint" {
  for_each = var.network_endpoint_type == "INTERNET_FQDN_PORT" ? toset(var.fqdns) : toset([])

  project                       = var.project_id
  global_network_endpoint_group = google_compute_global_network_endpoint_group.default.name
  port                          = var.port
  fqdn                          = each.value
}

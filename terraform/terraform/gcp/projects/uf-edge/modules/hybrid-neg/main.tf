resource "google_compute_network_endpoint_group" "default" {
  for_each = toset(var.zones)

  name                  = "${var.name}-${each.value}"
  network               = var.network
  network_endpoint_type = "NON_GCP_PRIVATE_IP_PORT"
  default_port          = var.onpremise_port
  zone                  = each.value
}

resource "google_compute_network_endpoint" "default" {
  for_each = merge([
    for zone in var.zones : {
      for ip in var.onpremise_ip_addresses : "${zone}-${ip}" => {
        zone : zone,
        ip : ip
      }
    }
  ]...)

  network_endpoint_group = google_compute_network_endpoint_group.default[each.value.zone].self_link
  ip_address             = each.value.ip
  port                   = var.onpremise_port
  zone                   = each.value.zone
}

locals {
  private_dns_zone_name = replace(var.private_dns, ".", "-")
}

# Private DNS zone
resource "google_dns_managed_zone" "private-zone" {
  name     = local.private_dns_zone_name
  dns_name = "${var.private_dns}."

  visibility = "private"
  private_visibility_config {
    networks {
      network_url = var.network
    }
  }
}

resource "google_dns_record_set" "default" {
  name         = "*.${google_dns_managed_zone.private-zone.dns_name}"
  managed_zone = google_dns_managed_zone.private-zone.name
  type         = "A"
  ttl          = 60

  rrdatas = [for addr in google_compute_address.psc_address : addr.address]
}

resource "google_dns_record_set" "zonal_record" {
  for_each     = var.endpoints
  name         = "*.${each.value.dns_subdomain}.${google_dns_managed_zone.private-zone.dns_name}"
  managed_zone = google_dns_managed_zone.private-zone.name
  type         = "A"
  ttl          = 60

  rrdatas = [google_compute_address.psc_address[each.key].address]
}

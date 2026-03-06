resource "google_dns_managed_zone" "private" {
  description = "Private DNS zone to Cloud Workstations"
  dns_name    = "${var.region}.${var.name}.ufinternal.com."
  name        = "workstations-${var.region}-${var.name}"
  visibility  = "private"

  private_visibility_config {
    networks {
      network_url = var.network_id
    }
  }
}

resource "google_dns_record_set" "wildcard" {
  count = var.psc_ip != "" ? 1 : 0

  managed_zone = resource.google_dns_managed_zone.private.name
  name         = "*.${resource.google_dns_managed_zone.private.dns_name}"
  rrdatas      = [resource.google_dns_managed_zone.private.dns_name]
  ttl          = 300
  type         = "CNAME"
}

resource "google_dns_record_set" "root" {
  count = var.psc_ip != "" ? 1 : 0

  managed_zone = resource.google_dns_managed_zone.private.name
  name         = resource.google_dns_managed_zone.private.dns_name
  rrdatas      = [var.psc_ip]
  ttl          = 300
  type         = "A"
}

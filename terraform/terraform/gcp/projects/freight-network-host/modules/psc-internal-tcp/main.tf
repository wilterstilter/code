data "google_compute_subnetwork" "subnet" {
  self_link = "https://www.googleapis.com/compute/v1/${var.subnetwork}"
}

locals {
  region = data.google_compute_subnetwork.subnet.region
}

# Private Service Connect Endpoints
resource "google_compute_address" "psc_address" {
  for_each     = var.endpoints
  name         = "${each.key}-ip"
  address_type = "INTERNAL"
  subnetwork   = var.subnetwork
  region       = local.region
}

resource "google_compute_forwarding_rule" "psc_endpoint" {
  for_each                = var.endpoints
  name                    = "${each.key}-endpoint"
  network                 = var.network
  subnetwork              = var.subnetwork
  ip_address              = google_compute_address.psc_address[each.key].id
  target                  = each.value.service_attachment_uri
  region                  = local.region
  load_balancing_scheme   = ""
  allow_psc_global_access = each.value.allow_psc_global_access
}

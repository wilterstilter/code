data "google_compute_network" "network" {
  name    = var.network_name
  project = var.project_id
}

resource "google_compute_global_address" "peering_range" {
  project       = var.project_id
  name          = var.peering_range_name
  purpose       = "VPC_PEERING"
  address_type  = var.address_type
  prefix_length = var.peering_range_prefix_length
  description   = var.peering_range_description
  network       = data.google_compute_network.network.self_link
}

resource "google_service_networking_connection" "private_service_access" {
  network                 = data.google_compute_network.network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.peering_range.name]
}

resource "google_compute_network_peering" "peering_to_tenant" {
  name                 = "peer-to-datafusion-tenant"
  network              = data.google_compute_network.network.self_link
  peer_network         = "projects/${var.tenant_project_id}/global/networks/${var.tenant_vpc_name}"
  export_custom_routes = true
  import_custom_routes = true
}

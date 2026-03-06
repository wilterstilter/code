data "google_compute_network" "network" {
  name    = var.network_name
  project = var.project_id
}

locals {
  # Support both single range (legacy) and multiple ranges (preferred)
  psa_ranges_map = length(var.psa_ranges) > 0 ? var.psa_ranges : (
    var.psa_range_name != "" ? {
      (var.psa_range_name) = {
        address       = var.psa_range_address
        prefix_length = var.psa_range_prefix_length
        description   = var.psa_range_description
      }
    } : {}
  )

  # For legacy outputs: deterministically select first range alphabetically
  first_range_key = length(google_compute_global_address.psa_ranges) > 0 ? sort(keys(google_compute_global_address.psa_ranges))[0] : null
  first_range     = local.first_range_key != null ? google_compute_global_address.psa_ranges[local.first_range_key] : null
}

# Reserve global IP address ranges for Private Service Access
resource "google_compute_global_address" "psa_ranges" {
  for_each = local.psa_ranges_map

  project       = var.project_id
  name          = each.key
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  address       = each.value.address
  prefix_length = each.value.prefix_length
  description   = each.value.description
  network       = data.google_compute_network.network.self_link
}

# Create the service networking connection for Private Service Access
# Includes all PSA ranges created above
resource "google_service_networking_connection" "private_service_access" {
  network                 = data.google_compute_network.network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [for name in sort(keys(local.psa_ranges_map)) : google_compute_global_address.psa_ranges[name].name]
}

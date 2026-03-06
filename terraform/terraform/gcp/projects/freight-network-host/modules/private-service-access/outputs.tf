output "psa_ranges" {
  description = "Map of PSA range names to their details"
  value = {
    for name, range in google_compute_global_address.psa_ranges : name => {
      name    = range.name
      address = range.address
      cidr    = "${range.address}/${range.prefix_length}"
      id      = range.id
    }
  }
}

# Legacy outputs for backward compatibility
# Returns the first range alphabetically by name (deterministic) when multiple ranges exist
# For single range usage, this will return that range. For multiple ranges, use psa_ranges output instead.
output "psa_range_name" {
  description = "The name of the allocated PSA IP range (legacy - use psa_ranges output instead). Returns first range alphabetically if multiple exist."
  value       = local.first_range != null ? local.first_range.name : null
}

output "psa_range_address" {
  description = "The starting IP address of the PSA range (legacy - use psa_ranges output instead). Returns first range alphabetically if multiple exist."
  value       = local.first_range != null ? local.first_range.address : null
}

output "psa_range_cidr" {
  description = "The CIDR notation of the PSA range (legacy - use psa_ranges output instead). Returns first range alphabetically if multiple exist."
  value       = local.first_range != null ? "${local.first_range.address}/${local.first_range.prefix_length}" : null
}

output "service_networking_connection" {
  description = "The service networking connection peering name"
  value       = google_service_networking_connection.private_service_access.peering
}

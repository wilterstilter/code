resource "random_id" "zone_suffix" {
  count       = length(var.dns_names)
  byte_length = 8
}

resource "google_dns_managed_zone" "peering_zone" {
  count       = length(var.dns_names)
  name        = "peering-zone-${random_id.zone_suffix[count.index].hex}"
  dns_name    = var.dns_names[count.index] # Removed the extra "."
  description = "Private DNS peering zone for ${var.dns_names[count.index]}"

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = var.source_network
    }
  }

  peering_config {
    target_network {
      network_url = var.target_network
    }
  }
}

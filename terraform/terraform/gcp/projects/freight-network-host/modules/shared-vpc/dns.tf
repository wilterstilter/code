resource "google_dns_policy" "default" {
  name                      = "default"
  enable_inbound_forwarding = true

  networks {
    network_url = module.network.network_self_link
  }
}

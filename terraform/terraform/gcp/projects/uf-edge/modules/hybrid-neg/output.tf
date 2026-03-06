output "neg_self_link" {
  value = {
    for neg in google_compute_network_endpoint_group.default : neg.zone => neg.self_link
  }
  description = "A map containing the zone and the network endpoint group self link."
}

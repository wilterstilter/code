include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/freight-network-host/modules/dns-peering"
}

inputs = {
  dns_names      = ["transplace.com.", "uberfreight.com.", "ufdomain.com.", "exttransplace.res."]
  source_network = "https://www.googleapis.com/compute/v1/projects/freight-network-host-n/global/networks/nonprod"
  target_network = "https://www.googleapis.com/compute/v1/projects/freight-network-host-p/global/networks/prod"
}
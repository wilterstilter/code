include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-edge/modules/internet-neg"
}

include "common2" {
    path = find_in_parent_folders("common2.hcl")
    expose = true
}

inputs = {
  project_id            = include.gcp.locals.project_id
  name                  = include.common2.locals.name
  network_endpoint_type = "INTERNET_IP_PORT"
  port                  = 443
  ip_addresses = [
    "52.153.241.0"
  ]
}

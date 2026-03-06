include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-edge/modules/sep-ilb"
}

include "common" {
    path = find_in_parent_folders("common.hcl")
    expose = true
}

dependency "ocp-dev" {
  config_path = "../../hybrid-neg/dev/ocp-dev"
}

dependency "tms-dev" {
  config_path = "../../hybrid-neg/dev/tms-dev"
}

dependency "vpc" {
  config_path = "../../../../../freight-network-host/environments/prod/vpc"
}

dependency "ssl_certs" {
  config_path = "../../cert-manager/tp-wildcard-cert"
}

inputs = {
  domain             = include.common.locals.domain
  project_id         = include.gcp.locals.project_id
  region             = "us-south1"
  address            = "10.247.10.8"
  network            = dependency.vpc.outputs.network_id
  proxy_subnetwork   = dependency.vpc.outputs.regional-managed-proxy["us-south1"].self_link
  subnetwork         = dependency.vpc.outputs.internal-lb["us-south1"].self_link
  default_service = concat(
    [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link]
  )
  default_hc_port    = "1936"
  default_hc_path    = "/healthz"
  url_map = {
    "/draco-es-client/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    }
  }
  certificate_id     = dependency.ssl_certs.outputs.certificate_id
}

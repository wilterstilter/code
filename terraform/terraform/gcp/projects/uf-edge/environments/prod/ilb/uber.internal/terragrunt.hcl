include "gcp" {
  path = find_in_parent_folders()
  expose = true
}

terraform {
  source = "${dirname(find_in_parent_folders())}//projects/uf-edge/modules/ilb"
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

dependency "rating-dev" {
  config_path = "../../hybrid-neg/dev/rating-dev"
}

dependency "smp-dev" {
  config_path = "../../hybrid-neg/dev/smp-dev"
}

dependency "dms-dev" {
  config_path = "../../hybrid-neg/dev/dms-dev"
}

dependency "ptms-dev" {
  config_path = "../../hybrid-neg/dev/ptms-dev"
}

dependency "cp-dev" {
  config_path = "../../hybrid-neg/dev/cp-dev"
}

dependency "rmc-dev" {
  config_path = "../../hybrid-neg/dev/rmc-dev"
}

dependency "sidekick-dev" {
  config_path = "../../hybrid-neg/dev/sidekick"
}

dependency "correctaddress-dev" {
  config_path = "../../hybrid-neg/dev/correct-address-dev"
}

dependency "oca-dev" {
  config_path = "../../hybrid-neg/dev/oca-dev"
}

dependency "optimize-dev" {
  config_path = "../../hybrid-neg/dev/optimize-dev"
}

dependency "vpc" {
  config_path = "../../../../../freight-network-host/environments/prod/vpc"
}

dependency "ssl_certs" {
  config_path = "../../cert-manager/uber-internal-cert"
}

inputs = {
  domain             = include.common.locals.domain
  project_id         = include.gcp.locals.project_id
  region             = "us-south1"
  network            = dependency.vpc.outputs.network_id
  proxy_subnetwork   = dependency.vpc.outputs.regional-managed-proxy["us-south1"].self_link
  subnetwork         = dependency.vpc.outputs.uberdev-internal-lb["us-south1"].self_link
  certificate_id     = dependency.ssl_certs.outputs.certificate_id

  # Load frontends from separate files
  frontends = {
    "uf-tms-dev-ext" = read_terragrunt_config("frontends/uf-tms-dev-ext/terragrunt.hcl").inputs,
    "uf-tms-dev-int" = read_terragrunt_config("frontends/uf-tms-dev-int/terragrunt.hcl").inputs
  }

  # Load backends from a separate file
  backends = read_terragrunt_config("../transplace.com/backends/terragrunt.hcl").inputs.backends

  # Load health checks from a separate file
  health_checks = read_terragrunt_config("../transplace.com/health_checks/terragrunt.hcl").inputs.health_checks
  http_redirect_lb_name = "uf-http-to-https-redirect-lb"
}


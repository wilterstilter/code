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


dependency "vpc" {
  config_path = "../../../../../freight-network-host/environments/dev/vpc"
}

dependency "ssl_certs" {
  config_path = "../../cert-manager/uf-wildcard-cert"
}

dependency "cloud_armor" {
  config_path = "../../cloud-armor/policies/tms-ilb"
}

inputs = {
  domain             = include.common.locals.domain
  project_id         = include.gcp.locals.project_id
  region             = "us-south1"
  network            = dependency.vpc.outputs.network_id
  proxy_subnetwork   = dependency.vpc.outputs.regional-managed-proxy["us-south1"].self_link
  subnetwork         = dependency.vpc.outputs.internal-lb["us-south1"].self_link
  certificate_id     = dependency.ssl_certs.outputs.certificate_id
  security_policy_self_link  = dependency.cloud_armor.outputs.security_policy_self_link



  # Load frontends from separate file
  frontends = {
    "cicd-nonprod" = read_terragrunt_config("frontends/cicd-nonprod/terragrunt.hcl").inputs
    "devptms" = read_terragrunt_config("frontends/devptms/terragrunt.hcl").inputs
  }

  # Load backends from a separate file
  backends = read_terragrunt_config("backends/terragrunt.hcl").inputs.backends

  # Load health checks from a separate file
  health_checks = read_terragrunt_config("health_checks/terragrunt.hcl").inputs.health_checks
  http_redirect_lb_name = "http-to-https-redirect-lb"
}

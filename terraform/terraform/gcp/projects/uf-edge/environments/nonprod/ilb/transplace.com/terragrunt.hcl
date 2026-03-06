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

dependency "ocp-staging" {
  config_path = "../../hybrid-neg/staging/ocp-staging"
}

dependency "tms-staging" {
  config_path = "../../hybrid-neg/staging/tms-staging"
}

dependency "tmsservices-staging" {
  config_path = "../../hybrid-neg/staging/tmsservices-staging"
}

dependency "rating-staging" {
  config_path = "../../hybrid-neg/staging/rating-staging"
}

dependency "smp-staging" {
  config_path = "../../hybrid-neg/staging/smp-staging"
}

dependency "dms-staging" {
  config_path = "../../hybrid-neg/staging/dms-staging"
}

dependency "ptms-staging" {
  config_path = "../../hybrid-neg/staging/ptms-staging"
}

dependency "cp-staging" {
  config_path = "../../hybrid-neg/staging/cp-staging"
}

dependency "rmceng19-staging" {
  config_path = "../../hybrid-neg/staging/rmceng19-staging"
}

dependency "correctaddress-staging" {
  config_path = "../../hybrid-neg/staging/correct-address-staging"
}

dependency "oca-staging" {
  config_path = "../../hybrid-neg/staging/oca-staging"
}

dependency "optimize-staging" {
  config_path = "../../hybrid-neg/staging/optimize-staging"
}

dependency "vpc" {
  config_path = "../../../../../freight-network-host/environments/nonprod/vpc"
}

dependency "ssl_certs" {
  config_path = "../../cert-manager/tp-wildcard-cert"
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

  # Load frontends from separate files
  frontends = {
    "stagingtmsservices" = read_terragrunt_config("frontends/stagingtmsservices/terragrunt.hcl").inputs,
    "stagingtmsservices-int"    = read_terragrunt_config("frontends/stagingtmsservices-int/terragrunt.hcl").inputs
    "tmsstaging-int"    = read_terragrunt_config("frontends/tmsstaging-int/terragrunt.hcl").inputs
    "stagingtms"    = read_terragrunt_config("frontends/stagingtms/terragrunt.hcl").inputs
    "stagingtms-es-client"    = read_terragrunt_config("frontends/stagingtms-es-client/terragrunt.hcl").inputs
  }

  # Load backends from a separate file
  backends = read_terragrunt_config("backends/terragrunt.hcl").inputs.backends

  # Load health checks from a separate file
  health_checks = read_terragrunt_config("health_checks/terragrunt.hcl").inputs.health_checks
  http_redirect_lb_name = "tp-http-to-https-redirect-lb"
}


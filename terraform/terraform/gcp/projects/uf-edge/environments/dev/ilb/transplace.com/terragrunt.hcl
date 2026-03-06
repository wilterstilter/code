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

### TEST ENVIRONMENT HYBRID NEGs #######

dependency "ocp-test" {
  config_path = "../../hybrid-neg/test/ocp-test"
}

dependency "tms-test" {
  config_path = "../../hybrid-neg/test/tms-test"
}

dependency "tmsservices-test" {
  config_path = "../../hybrid-neg/test/tmsservices-test"
}

dependency "rating-test" {
  config_path = "../../hybrid-neg/test/rating-test"
}

dependency "smp-test" {
  config_path = "../../hybrid-neg/test/smp-test"
}

dependency "dms-test" {
  config_path = "../../hybrid-neg/test/dms-test"
}

dependency "ptms-test" {
  config_path = "../../hybrid-neg/test/ptms-test"
}

dependency "cp-test" {
  config_path = "../../hybrid-neg/test/cp-test"
}

dependency "rmceng19-test" {
  config_path = "../../hybrid-neg/test/rmceng19-test"
}

dependency "correctaddress-test" {
  config_path = "../../hybrid-neg/test/correct-address-test"
}

dependency "oca-test" {
  config_path = "../../hybrid-neg/test/oca-test"
}

dependency "optimize-test" {
  config_path = "../../hybrid-neg/test/optimize-test"
}


### DEV ENVIRONMENT HYBRID NEGs #######

dependency "ocp-dev" {
  config_path = "../../hybrid-neg/dev/ocp-dev"
}

dependency "tms-dev" {
  config_path = "../../hybrid-neg/dev/tms-dev"
}

dependency "tmsservices-dev" {
  config_path = "../../hybrid-neg/dev/tmsservices-dev"
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

dependency "rmceng19-dev" {
  config_path = "../../hybrid-neg/dev/rmceng19-dev"
}

dependency "rmc-dev" {
  config_path = "../../hybrid-neg/dev/rmc-dev"
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
  config_path = "../../../../../freight-network-host/environments/dev/vpc"
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
    "testtmsservices" = read_terragrunt_config("frontends/testtmsservices/terragrunt.hcl").inputs,
    "testtmsservices-int"    = read_terragrunt_config("frontends/testtmsservices-int/terragrunt.hcl").inputs
    "tmstest-int"    = read_terragrunt_config("frontends/tmstest-int/terragrunt.hcl").inputs
    "test-internal"    = read_terragrunt_config("frontends/test-internal/terragrunt.hcl").inputs
    "testtms"    = read_terragrunt_config("frontends/testtms/terragrunt.hcl").inputs
    "testtms-es-client"    = read_terragrunt_config("frontends/testtms-es-client/terragrunt.hcl").inputs
    "devtmsservices" = read_terragrunt_config("frontends/devtmsservices/terragrunt.hcl").inputs,
    "devtmsservices-int"    = read_terragrunt_config("frontends/devtmsservices-int/terragrunt.hcl").inputs
    "tmsdev-int"    = read_terragrunt_config("frontends/tmsdev-int/terragrunt.hcl").inputs
    "devtms"    = read_terragrunt_config("frontends/devtms/terragrunt.hcl").inputs
    "devtms-es-client"    = read_terragrunt_config("frontends/devtms-es-client/terragrunt.hcl").inputs
  }

  # Load backends from a separate file
  backends = read_terragrunt_config("backends/terragrunt.hcl").inputs.backends

  # Load health checks from a separate file
  health_checks = read_terragrunt_config("health_checks/terragrunt.hcl").inputs.health_checks
  http_redirect_lb_name = "tp-http-to-https-redirect-lb"
}

#dummy comment2
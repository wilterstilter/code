include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-edge/modules/glb-f5"
}

include "common" {
    path = find_in_parent_folders("common.hcl")
    expose = true
}

dependency "cloud_armor" {
  config_path = "../../cloud-armor/policies/web"
}

dependency "customswmsapi-dal-f5" {
  config_path = "../../hybrid-neg/prod/customswmsapi-dal-f5"
}

inputs = {
  domain = include.common.locals.domain
  security_policy_self_link = dependency.cloud_armor.outputs.security_policy_self_link
  health_check_port  = "443"
  min_tls_version = "TLS_1_2"
  default_service = concat(
    [for zone, link in dependency.customswmsapi-dal-f5.outputs.neg_self_link: link]
  )
}

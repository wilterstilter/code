include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-edge/modules/glb-internet-neg"
}

include "common" {
    path = find_in_parent_folders("common.hcl")
    expose = true
}

dependency "cloud_armor" {
  config_path = "../../cloud-armor/policies/web"
}

dependency "dev-lanehub-azure" {
  config_path = "../../internet-neg/uat/dev-lanehub-azure"
}

# Force refresh
inputs = {
  domains = [
    include.common.locals.domain
  ]
  security_policy_self_link = dependency.cloud_armor.outputs.security_policy_self_link
  min_tls_version = "TLS_1_2"
  default_service = concat(
    [for zone, link in dependency.dev-lanehub-azure.outputs.neg_self_link: link]
  )
}

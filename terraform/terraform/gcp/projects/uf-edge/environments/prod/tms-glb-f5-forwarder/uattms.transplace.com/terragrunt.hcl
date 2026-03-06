include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-edge/modules/tms-glb-f5-forwarder"
}

include "common" {
    path = find_in_parent_folders("common.hcl")
    expose = true
}

dependency "cloud_armor" {
  config_path = "../../cloud-armor/policies/web"
}

dependency "tms-aus" {
  config_path = "../../hybrid-neg/uat/tms-aus-f5"
}

dependency "tms-dal" {
  config_path = "../../hybrid-neg/uat/tms-dal-f5"
}


inputs = {
  domain = include.common.locals.domain
  security_policy_self_link = dependency.cloud_armor.outputs.security_policy_self_link
  
  # Default backend health check (TCP/HTTPS)\
  health_check_port  = "443"
  default_backend_timeout_sec = 300

  min_tls_version = "TLS_1_2"
  path_backends = {
    "/tmobile/*" = {
      neg_links   = concat(
        []
      )
      health_path = "/tmobile/ptms/induction"
      health_port = 443
      timeout_sec               = 45
      health_check_interval_sec = 5
      health_check_timeout_sec  = 2
    }
    "/ptms/t-mobile/*" = {
      neg_links   = concat(
        [for zone, link in dependency.tms-aus.outputs.neg_self_link: link],
        [for zone, link in dependency.tms-dal.outputs.neg_self_link: link]
      )
      health_path = "/ptms/t-mobile/induction"
      health_port = 443
      timeout_sec               = 45
      health_check_interval_sec = 5
      health_check_timeout_sec  = 2
    }
    "/ratingmaintenance/*" = {
      neg_links   = concat(
        [for zone, link in dependency.tms-aus.outputs.neg_self_link: link]
      )
      health_path = "/ratingmaintenance/index.html"
      health_port = 443
      timeout_sec               = 1800
      health_check_interval_sec = 60
      health_check_timeout_sec  = 10
    }
  }
  default_service = concat(
    [for zone, link in dependency.tms-aus.outputs.neg_self_link: link]
  )
}


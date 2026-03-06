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

dependency "ptms-aus-prod-east" {
  config_path = "../../hybrid-neg/prod/ptms-aus-prod-east"
}

dependency "ptms-aus-prod-south" {
  config_path = "../../hybrid-neg/prod/ptms-aus-prod-south"
}

dependency "ptms-dal-prod-south" {
  config_path = "../../hybrid-neg/prod/ptms-dal-prod-south"
}

dependency "ptms-dal-prod-west" {
  config_path = "../../hybrid-neg/prod/ptms-dal-prod-west"
}

dependency "tms-aus" {
  config_path = "../../hybrid-neg/prod/tms-aus-prod-f5"
}

dependency "tms-dal" {
  config_path = "../../hybrid-neg/prod/tms-dal-prod-f5"
}


inputs = {
  domain = include.common.locals.domain
  security_policy_self_link = dependency.cloud_armor.outputs.security_policy_self_link
  
  # Default backend health check (TCP/HTTPS)\
  health_check_port  = "443"

  min_tls_version = "TLS_1_2"
  path_backends = {
    "/ptms/t-mobile/api/shipping/*" = {
      neg_links   = concat(
        [for zone, link in dependency.tms-aus.outputs.neg_self_link: link],
        [for zone, link in dependency.tms-dal.outputs.neg_self_link: link]
      )
      health_path = "/ptms/t-mobile/api/shipping/health/live"
      health_port = 443
      health_protocol = "HTTPS"
      max_rate_per_endpoint = 120
      timeout_sec               = 45
      health_check_interval_sec = 5
      health_check_timeout_sec  = 2
    }
    "/ptms/t-mobile/api/rating/*" = {
      neg_links   = concat(
        [for zone, link in dependency.tms-aus.outputs.neg_self_link: link],
        [for zone, link in dependency.tms-dal.outputs.neg_self_link: link]
      )
      health_path = "/ptms/t-mobile/api/rating/health/live"
      health_port = 443
      health_protocol = "HTTPS"
      max_rate_per_endpoint = 120
      timeout_sec               = 45
      health_check_interval_sec = 5
      health_check_timeout_sec  = 2
    }
    "/ptms/t-mobile/api/label/*" = {
      neg_links   = concat(
        [for zone, link in dependency.tms-aus.outputs.neg_self_link: link],
        [for zone, link in dependency.tms-dal.outputs.neg_self_link: link]
      )
      health_path = "/ptms/t-mobile/api/label/health/live"
      health_port = 443
      health_protocol = "HTTPS"
      max_rate_per_endpoint = 120
      timeout_sec               = 45
      health_check_interval_sec = 5
      health_check_timeout_sec  = 2
    }
    "/ptms/t-mobile/api/manifest/*" = {
      neg_links   = concat(
        [for zone, link in dependency.tms-aus.outputs.neg_self_link: link],
        [for zone, link in dependency.tms-dal.outputs.neg_self_link: link]
      )
      health_path = "/ptms/t-mobile/api/shipping/health/live"
      health_port = 443
      health_protocol = "HTTPS"
      max_rate_per_endpoint = 120
      timeout_sec               = 45
      health_check_interval_sec = 5
      health_check_timeout_sec  = 2
    }
    "/ptms/t-mobile/api/config/*" = {
      neg_links   = concat(
        [for zone, link in dependency.tms-aus.outputs.neg_self_link: link],
        [for zone, link in dependency.tms-dal.outputs.neg_self_link: link]
      )
      health_path = "/ptms/t-mobile/api/shipping/health/live"
      health_port = 443
      health_protocol = "HTTPS"
      max_rate_per_endpoint = 120
      timeout_sec               = 45
      health_check_interval_sec = 5
      health_check_timeout_sec  = 2
    }
    "/ptms/t-mobile/api/admin/*" = {
      neg_links   = concat(
        [for zone, link in dependency.tms-aus.outputs.neg_self_link: link],
        [for zone, link in dependency.tms-dal.outputs.neg_self_link: link]
      )
      health_path = "/ptms/t-mobile/api/shipping/health/live"
      health_port = 443
      health_protocol = "HTTPS"
      max_rate_per_endpoint = 120
      timeout_sec               = 45
      health_check_interval_sec = 5
      health_check_timeout_sec  = 2
    }
    "/ptms/t-mobile/api/reports/*" = {
      neg_links   = concat(
        [for zone, link in dependency.tms-aus.outputs.neg_self_link: link],
        [for zone, link in dependency.tms-dal.outputs.neg_self_link: link]
      )
      health_path = "/ptms/t-mobile/api/shipping/health/live"
      health_port = 443
      health_protocol = "HTTPS"
      max_rate_per_endpoint = 120
      timeout_sec               = 45
      health_check_interval_sec = 5
      health_check_timeout_sec  = 2
    }
  }
  default_service = concat(
        [for zone, link in dependency.tms-aus.outputs.neg_self_link: link],
        [for zone, link in dependency.tms-dal.outputs.neg_self_link: link]
  )
}




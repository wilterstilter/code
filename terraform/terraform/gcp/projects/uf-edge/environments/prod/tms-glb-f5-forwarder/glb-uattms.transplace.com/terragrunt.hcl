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

dependency "cicd-aus-f5" {
  config_path = "../../hybrid-neg/uat/cicd-aus-f5"
}

dependency "sonarqube-dal-f5" {
  config_path = "../../hybrid-neg/prod/sonarqube-dal-f5"
}

dependency "sonar-dal-f5" {
  config_path = "../../hybrid-neg/prod/sonar-dal-f5"
}

dependency "celchi-dal-f5" {
  config_path = "../../hybrid-neg/prod/celchi-dal-f5"
}

inputs = {
  domain = include.common.locals.domain
  security_policy_self_link = dependency.cloud_armor.outputs.security_policy_self_link
  
  # Default backend health check (TCP/HTTPS)\
  health_check_port  = "443"

  min_tls_version = "TLS_1_2"
  path_backends = {
    "/tmobile/ptms/api/shipping/*" = {
      neg_links   = concat(
        [for zone, link in dependency.tms-aus.outputs.neg_self_link: link],
        [for zone, link in dependency.tms-dal.outputs.neg_self_link: link]
      )
      health_path = "/tmobile/ptms/api/shipping/health/live"
      health_port = 443
    }
    "/tmobile/ptms/api/rating/*" = {
      neg_links   = concat(
        [for zone, link in dependency.cicd-aus-f5.outputs.neg_self_link: link],
        [for zone, link in dependency.tms-aus.outputs.neg_self_link: link]
      )
      health_path = "/tmobile/ptms/api/rating/health/live"
      health_port = 443
    }
    "/ptms/" = {
      neg_links   = concat(
        [for zone, link in dependency.sonar-dal-f5.outputs.neg_self_link: link]
      )
      health_path = "/"
      health_port = 443
    }
    "/ptms/t-mobile/api/rating/*" = {
      neg_links   = concat(
        [for zone, link in dependency.tms-aus.outputs.neg_self_link: link]
      )
      health_path = "/tmobile/ptms/api/rating/health/live"
      health_port = 443
    }
    "/sonar" = {
      neg_links   = concat(
        [for zone, link in dependency.sonar-dal-f5.outputs.neg_self_link: link]
      )
      health_path = "/"
      health_port = 443
    }
    "/tmobile/ui" = {
      neg_links   = concat(
        [for zone, link in dependency.cicd-aus-f5.outputs.neg_self_link: link],
        [for zone, link in dependency.tms-aus.outputs.neg_self_link: link]
      )
      health_path = "/tmobile/ptms/induction"
      health_port = 443
    }
  }
  default_service = concat(
    [for zone, link in dependency.tms-dal.outputs.neg_self_link: link]
  )
}

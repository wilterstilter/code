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

dependency "rating-dev" {
  config_path = "../../hybrid-neg/dev/rating-dev"
}

dependency "smp-dev" {
  config_path = "../../hybrid-neg/dev/smp-dev"
}

dependency "dms-dev" {
  config_path = "../../hybrid-neg/dev/dms-dev"
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


inputs = {
  domain             = include.common.locals.domain
  project_id         = include.gcp.locals.project_id
  region             = "us-south1"
  address            = "10.247.10.9"
  port               = "80"
  network            = dependency.vpc.outputs.network_id
  proxy_subnetwork   = dependency.vpc.outputs.regional-managed-proxy["us-south1"].self_link
  subnetwork         = dependency.vpc.outputs.internal-lb["us-south1"].self_link
  default_service = concat(
    [for zone, link in dependency.tms-dev.outputs.neg_self_link: link]
  )
  default_hc_port    = "7077"
  default_hc_path    = "/tms/version.jsp"
  url_map = {
    "/tms/": {
      "neg_links": [for zone, link in dependency.tms-dev.outputs.neg_self_link: link],
      "health_check_port": "7077",
      "health_check_path": "/tms/version.jsp"
    },
    "/optimizeengine/": {
      "neg_links": [for zone, link in dependency.optimize-dev.outputs.neg_self_link: link],
      "health_check_port": "8080",
      "health_check_path": "/optimizeengine/index.jsp"
    },
    "/sptresult/": {
      "neg_links": [for zone, link in dependency.tms-dev.outputs.neg_self_link: link],
      "health_check_port": "7077",
      "health_check_path": "/tms/version.jsp"
    },
    "/optimizerest/": {
      "neg_links": [for zone, link in dependency.optimize-dev.outputs.neg_self_link: link],
      "health_check_port": "8080",
      "health_check_path": "/maoptimizerest/index.jsp"
    },
    "/correctaddress/": {
      "neg_links": [for zone, link in dependency.correctaddress-dev.outputs.neg_self_link: link],
      "health_check_port": "8080",
      "health_check_path": "/correctAddress/"
    },
    "/ratingmaintenance/": {
      "neg_links": [for zone, link in dependency.rating-dev.outputs.neg_self_link: link],
      "health_check_port": "8080",
      "health_check_path": "/ratingmaintenance/index.html"
    },
    "/oca/": {
      "neg_links": [for zone, link in dependency.oca-dev.outputs.neg_self_link: link],
      "health_check_port": "8180",
      "health_check_path": "/info"
    },
    "/ratingengine/": {
      "neg_links": [for zone, link in dependency.rating-dev.outputs.neg_self_link: link],
      "health_check_port": "8080",
      "health_check_path": "/ratingengine/index.html"
    },
    "/rmcengine19/": {
      "neg_links": [for zone, link in dependency.rmc-dev.outputs.neg_self_link: link],
      "health_check_port": "8180",
      "health_check_path": "/rmcengine19/index.html"
    },
    "/dms/": {
      "neg_links": [for zone, link in dependency.dms-dev.outputs.neg_self_link: link],
      "health_check_port": "7042",
      "health_check_path": "/dms/index.html"
    },
    "/smp/": {
      "neg_links": [for zone, link in dependency.smp-dev.outputs.neg_self_link: link],
      "health_check_port": "8080",
      "health_check_path": "/smp/index.html"
    },
    "/alert-service/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/notification/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/check-call-stream-api/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/rating-service/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/rates-and-lanes/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/parcel/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/dcm-service/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/dcm/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    }
    "/rating/maintenance/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/mit/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/ltlcarrierapiservice/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/op-job-scheduler/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/optimize-service/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/optimizefacade/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/optimizemediator/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/op-consumer/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/opconsumer-cr/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/opconsumer-faq/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/opconsumer-nom/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/opconsumer-pop/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/parcel-carrier-api-service/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/junction/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/spring-config/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/spring-config-v2/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/externalrates/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/carrier-auction-service/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/carrierapi-request/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/carrierapi-config/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/carrierapi-status/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/ipl/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/tp-kafka-connect-jdbc/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/yms/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/junction/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/spring-config/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/otd/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/ops/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/ratingsearch/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/routing-service/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/rating-regression/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/riskpulse/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/tracking/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/tenderservice/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/radeon/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/sidekick/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    }
  }
}

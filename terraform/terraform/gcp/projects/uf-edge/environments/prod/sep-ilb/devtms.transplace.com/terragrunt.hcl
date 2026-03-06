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

dependency "cp-dev" {
  config_path = "../../hybrid-neg/dev/cp-dev"
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

dependency "vpc" {
  config_path = "../../../../../freight-network-host/environments/prod/vpc"
}


inputs = {
  domain             = include.common.locals.domain
  project_id         = include.gcp.locals.project_id
  region             = "us-south1"
  address            = "10.247.10.10"
  port               = "80"
  network            = dependency.vpc.outputs.network_id
  proxy_subnetwork   = dependency.vpc.outputs.regional-managed-proxy["us-south1"].self_link
  subnetwork         = dependency.vpc.outputs.internal-lb["us-south1"].self_link
  default_service = concat(
    [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link]
  )
  default_hc_port    = "1936"
  default_hc_path    = "/healthz"
  enable_host_rewrite = true
  enable_https_redirects = true
  url_map = {
    "/tms/": {
      "neg_links": [for zone, link in dependency.tms-dev.outputs.neg_self_link: link],
      "health_check_port": "7077",
      "health_check_path": "/tms/version.jsp"
      "forbidden_uris": ["/tms/UpdateServlet"]
    },
    "/ptms/": {
      "neg_links": [for zone, link in dependency.ptms-dev.outputs.neg_self_link: link],
      "health_check_port": "80",
      "health_check_path": "/ptms/index.html"
    },
    "/cp/": {
      "neg_links": [for zone, link in dependency.cp-dev.outputs.neg_self_link: link],
      "health_check_port": "7092",
      "health_check_path": "/cp/index.html"
    },
    "/ratingmaintenance/": {
      "neg_links": [for zone, link in dependency.rating-dev.outputs.neg_self_link: link],
      "health_check_port": "8080",
      "health_check_path": "/ratingmaintenance/index.html"
    },
    "/ratingexternal/": {
      "neg_links": [for zone, link in dependency.rating-dev.outputs.neg_self_link: link],
      "health_check_port": "8080",
      "health_check_path": "/ratingexternal/index.html"
    },
    "/smp/": {
      "neg_links": [for zone, link in dependency.smp-dev.outputs.neg_self_link: link],
      "health_check_port": "8080",
      "health_check_path": "/smp/index.html"
    },
    "/dms/": {
      "neg_links": [for zone, link in dependency.dms-dev.outputs.neg_self_link: link],
      "health_check_port": "7042",
      "health_check_path": "/dms/index.html"
    },
    "/security/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
      "forbidden_uris": ["/security/UpdateServlet"]
    },
    "/cms/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
      "forbidden_uris": ["/cms/UpdateServlet"]
    },
    "/sku/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
      "forbidden_uris": ["/sku/UpdateServlet"]
    },
    "/carrierapi-status/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/configuration/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/web/settings/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/web/srg/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/web/ds/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/web/locations/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/web/tracking/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/web/auctions/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/web/earbuds-docs/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/web/carrier/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/web/distance/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/web/isd/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/web/sp/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/web/tracking-portal-ui/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/web/se/smp/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/web/se/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/web/sec/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/web/parcel-ui/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/web/dcm-ui/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/web/ect-ui/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/web/configuration-ui/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/web/tpangular/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/web/orders/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/web/shipments/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/draco/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/mobile-access/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/transmatch/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/xml-api/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/ct/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/yms/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/drome/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/rateapproval/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/location-web/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/tracking/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/notification/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/io/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/alert-service/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/otd/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/sidekick/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/eda-service/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    },
    "/settings/": {
      "neg_links": [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link],
      "health_check_port": "1936",
      "health_check_path": "/healthz"
    }
  }
}

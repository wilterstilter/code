include "gcp" {
  path = find_in_parent_folders()
  expose = true
}

terraform {
  source = "${dirname(find_in_parent_folders())}//projects/uf-edge/modules/cross-region-lb"
}

# Dependencies
dependency "vpc" {
  config_path = "../../../../../freight-network-host/environments/nonprod/vpc"
}

# Reference the backend service created in uf-compute
dependency "backend_service" {
  config_path  = "../../../../../uf-compute/environments/nonprod/cross-region-neg-backends"
  skip_outputs = true
}

# Dependency on certificate from nonprod environment
dependency "certificate" {
  config_path = "../../cert-manager/uf-wildcard-cert-global"
}

# Cross-regional internal load balancer configuration for HTTPS
inputs = {
  domain     = "tmob.uberfreight.com"
  project_id = include.gcp.locals.project_id

  # INTERNAL_MANAGED for cross-regional internal ALB
  load_balancing_scheme = "INTERNAL_MANAGED"

  # Regions for cross-region load balancing
  regions = ["us-south1", "us-east4"]

  # VPC Network
  network = dependency.vpc.outputs.network_id

  # Load balancer subnets - using internal-lb subnets (same as working DEV)
  lb_subnets = {
    "us-south1" = dependency.vpc.outputs.internal-lb["us-south1"].self_link
    "us-east4"  = dependency.vpc.outputs.internal-lb["us-east4"].self_link
  }

  # SSL certificate - referencing existing dev global certificate
  certificate_id = "projects/${include.gcp.locals.project_id}/locations/global/certificates/uf-wildcard-cert-global"

  # Frontend configuration (HTTPS-only)
  frontends = {
    "ptms-tmob-https" = {
      port                 = 443
      default_backend      = "ptms-tmob-adminapi-backend"
      enable_http_redirect = false
      enable_cors          = false

      # Internal IPs per region - using specified addresses
      ip_addresses = {
        "us-south1" = "10.223.10.20"
        "us-east4"  = "10.220.32.20"
      }

      # URL mapping with more specific path matching
      # NOTE: prefix_match doesn't support wildcards - it's a literal prefix
      url_map = [
        {
          path     = "/ptms/t-mobile/api/admin/"
          backend  = "ptms-tmob-adminapi-backend"
          priority = 1
        },
        {
          path     = "/ptms/t-mobile/api/config/"
          backend  = "ptms-tmob-configapi-backend"
          priority = 2
        },
        {
          path     = "/ptms/t-mobile/api/label/"
          backend  = "ptms-tmob-labelapi-backend"
          priority = 3
        },
        {
          path     = "/ptms/t-mobile/api/labelexternal/"
          backend  = "ptms-tmob-labelexternalapi-backend"
          priority = 4
        },
        {
          path     = "/ptms/t-mobile/api/manifest/"
          backend  = "ptms-tmob-manifestapi-backend"
          priority = 5
        },
        {
          path     = "/ptms/t-mobile/api/rating/"
          backend  = "ptms-tmob-ratingapi-backend"
          priority = 6
        },
        {
          path     = "/ptms/t-mobile/api/ratingexternal/"
          backend  = "ptms-tmob-ratingexternalapi-backend"
          priority = 7
        },
        {
          path     = "/ptms/t-mobile/api/reports/"
          backend  = "ptms-tmob-reportsapi-backend"
          priority = 8
        },
        {
          path     = "/ptms/t-mobile/api/shipping/"
          backend  = "ptms-tmob-shippingapi-backend"
          priority = 9
        },
        {
          path     = "/ptms/t-mobile/api/shippingexternal/"
          backend  = "ptms-tmob-shippingexternalapi-backend"
          priority = 10
        },
        {
          path     = "/uat/api-edge/parcel/"
          backend  = "parceledge-backend"
          priority = 11
        },
        {
          path     = "/ptms/t-mobile/admin/"
          backend  = "ptms-tmob-adminui-backend"
          priority = 12
        },
        {
          path     = "/ptms/t-mobile/induction/"
          backend  = "ptms-tmob-inductionui-backend"
          priority = 13
        },
        {
          path     = "/"
          backend  = "ptms-tmob-adminapi-backend"
          priority = 14
        }
      ]

      forbidden_uris = []
    }
  }

  # Reference existing backend services from uf-compute
  backends = {
    "ptms-tmob-adminapi-backend" = {
      backend_service_self_link = "projects/uf-compute-n/global/backendServices/gbs-ptms-tmob-adminapi-uat"
    },
    "ptms-tmob-adminui-backend" = {
      backend_service_self_link = "projects/uf-compute-n/global/backendServices/gbs-ptms-tmob-adminui-uat"
    },
    "ptms-tmob-configapi-backend" = {
      backend_service_self_link = "projects/uf-compute-n/global/backendServices/gbs-ptms-tmob-configapi-uat"
    },
    "ptms-tmob-inductionui-backend" = {
      backend_service_self_link = "projects/uf-compute-n/global/backendServices/gbs-ptms-tmob-inductionui-uat"
    },
    "ptms-tmob-labelapi-backend" = {
      backend_service_self_link = "projects/uf-compute-n/global/backendServices/gbs-ptms-tmob-labelapi-uat"
    },
    "ptms-tmob-labelexternalapi-backend" = {
      backend_service_self_link = "projects/uf-compute-n/global/backendServices/gbs-ptms-tmob-labelexternalapi-uat"
    },
    "ptms-tmob-manifestapi-backend" = {
      backend_service_self_link = "projects/uf-compute-n/global/backendServices/gbs-ptms-tmob-manifestapi-uat"
    },
    "ptms-tmob-ratingapi-backend" = {
      backend_service_self_link = "projects/uf-compute-n/global/backendServices/gbs-ptms-tmob-ratingapi-uat"
    },
    "ptms-tmob-ratingexternalapi-backend" = {
      backend_service_self_link = "projects/uf-compute-n/global/backendServices/gbs-ptms-tmob-ratingexternalapi-uat"
    },
    "ptms-tmob-reportsapi-backend" = {
      backend_service_self_link = "projects/uf-compute-n/global/backendServices/gbs-ptms-tmob-reportsapi-uat"
    },
    "ptms-tmob-shippingapi-backend" = {
      backend_service_self_link = "projects/uf-compute-n/global/backendServices/gbs-ptms-tmob-shippingapi-uat"
    },
    "ptms-tmob-shippingexternalapi-backend" = {
      backend_service_self_link = "projects/uf-compute-n/global/backendServices/gbs-ptms-tmob-shippingexternalapi-uat"
    },
    "parceledge-backend" = {
      backend_service_self_link = "projects/uf-compute-n/global/backendServices/gbs-parceledge-uat"
    }
  }

  # No health checks needed - they're defined in uf-compute
  health_checks = {}
}


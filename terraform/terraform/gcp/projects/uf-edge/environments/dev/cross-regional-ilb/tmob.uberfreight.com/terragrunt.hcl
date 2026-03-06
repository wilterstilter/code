include "gcp" {
  path = find_in_parent_folders()
  expose = true
}

terraform {
  source = "${dirname(find_in_parent_folders())}//projects/uf-edge/modules/cross-region-lb"
}

include "common" {
  path = find_in_parent_folders("common.hcl")
  expose = true
}

# Dependencies
dependency "vpc" {
  config_path = "../../../../../freight-network-host/environments/dev/vpc"
}

# Reference the backend service created in uf-compute
dependency "backend_service" {
  config_path  = "../../../../../uf-compute/environments/dev/cross-region-neg-backends"
  skip_outputs = true
}

# Cross-regional internal load balancer configuration
# Fix HTTP forwarding rules dependency issue


inputs = {
  domain     = "tmob.uberfreight.com"
  project_id = include.gcp.locals.project_id

  # INTERNAL_MANAGED for cross-regional internal ALB
  load_balancing_scheme = "INTERNAL_MANAGED"

  # Regions for cross-region load balancing
  regions = ["us-south1", "us-east4"]

  # VPC Network
  network = dependency.vpc.outputs.network_id

  # Load balancer subnets
  lb_subnets = {
    "us-south1" = dependency.vpc.outputs.internal-lb["us-south1"].self_link
    "us-east4"  = dependency.vpc.outputs.internal-lb["us-east4"].self_link
  }

  # SSL certificate (disabled - deploy HTTP first, add HTTPS later)
  # certificate_id = "projects/${include.gcp.locals.project_id}/locations/global/certificates/uf-self-managed-crt-global"

  # Frontend configuration (HTTP-only - working config)
  frontends = {
    "ptms-tmob" = {
      port                 = 80
      default_backend      = "ptms-tmob-backend"
      enable_http_redirect = false
      enable_cors          = false
      
      # Internal IPs per region - use different IPs to avoid conflicts
      ip_addresses = {
        "us-south1" = "10.227.10.28"
        "us-east4"  = "10.225.16.28"
      }
      
      url_map = [
        {
          path     = "/dev/api-edge/parcel"
          backend  = "ptms-tmob-backend"
          priority = 1
        },
        {
          path     = "/"
          backend  = "ptms-tmob-backend"
          priority = 2
        }
      ]
      
      forbidden_uris = []
    }
  }

  # Reference existing backend service from uf-compute
  backends = {
    "ptms-tmob-backend" = {
      # Use the backend service created in uf-compute
      backend_service_self_link = "projects/uf-compute-d/global/backendServices/gbs-ptms-tmob-active-active-dev"
    }
  }

  # No health checks needed - they're defined in uf-compute
  health_checks = {}

}
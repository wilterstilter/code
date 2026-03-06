# =============================================================================
# EXAMPLE: Global Backend Service for External GLB
# =============================================================================
# Same format as neg-backends but creates GLOBAL backend services
# for use with external Global Load Balancers
# =============================================================================

include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "${dirname(find_in_parent_folders())}//projects/uf-compute/modules/global-neg-backends"
}

include "common" {
  path   = find_in_parent_folders("common.hcl")
  expose = true
}

inputs = {
  project_id            = include.gcp.locals.project_id
  protocol              = "HTTP"
  timeout_sec           = 30
  load_balancing_scheme = "EXTERNAL_MANAGED"  # For Global LB

  # Health check configurations (same format as neg-backends)
  health_check_configs = {
    "parceltpapi" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/health"
      port                = 8080
    },
    "another-service" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/api/health"
      port                = 8080
    }
  }

  # Backend service configurations (same format as neg-backends)
  # KEY DIFFERENCE: neg_names can include NEGs from MULTIPLE regions!
  backend_service_configs = {
    "parceltpapi" = {
      # NEGs from multiple regions (this is the key difference from regional module)
      neg_names = [
        # us-south1 (Region 1)
        "projects/uf-compute-d/zones/us-south1-a/networkEndpointGroups/neg-parceltpapi",
        "projects/uf-compute-d/zones/us-south1-b/networkEndpointGroups/neg-parceltpapi",
        "projects/uf-compute-d/zones/us-south1-c/networkEndpointGroups/neg-parceltpapi",
        # us-east4 (Region 2) - Can add NEGs from other regions!
        "projects/uf-compute-d/zones/us-east4-a/networkEndpointGroups/neg-parceltpapi",
        "projects/uf-compute-d/zones/us-east4-b/networkEndpointGroups/neg-parceltpapi",
        "projects/uf-compute-d/zones/us-east4-c/networkEndpointGroups/neg-parceltpapi"
      ]
      health_check_name     = "parceltpapi"
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 100
      capacity_scaler       = 1.0
    },
    "another-service" = {
      neg_names = [
        "projects/uf-compute-d/zones/us-south1-a/networkEndpointGroups/neg-another-service",
        "projects/uf-compute-d/zones/us-south1-b/networkEndpointGroups/neg-another-service",
        "projects/uf-compute-d/zones/us-south1-c/networkEndpointGroups/neg-another-service"
      ]
      health_check_name     = "another-service"
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 50
      capacity_scaler       = 1.0
      timeout_sec           = 60  # Custom timeout
      logging               = true
    }
  }
}

# =============================================================================
# OUTPUTS
# =============================================================================
# backend_service_self_links = {
#   "parceltpapi"     = "https://.../global/backendServices/gbs-parceltpapi"
#   "another-service" = "https://.../global/backendServices/gbs-another-service"
# }
#
# Use in uf-edge GLB:
#   default_cross_project_backend = dependency.backends.outputs.backend_service_self_links["parceltpapi"]
# =============================================================================

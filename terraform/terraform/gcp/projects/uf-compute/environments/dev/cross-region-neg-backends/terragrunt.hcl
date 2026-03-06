include "gcp" {
    path = find_in_parent_folders()
    expose = true
}
 
terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-compute/modules/global-neg-backends"
}
 
include "common" {
    path = find_in_parent_folders("common.hcl")
    expose = true
}

# Deploy NEGs and backend service for cross-regional load balancer
# Update health check port to 8080
dependency "vpc" {
  config_path = "../../../../freight-network-host/environments/dev/vpc"
}
 
inputs = {
  project_id            = include.gcp.locals.project_id
  load_balancing_scheme = "INTERNAL_MANAGED"

  # Health check configurations
  # NOTE: Use service port (9015) for health checks
  health_check_configs = {
    "parceledge-v2" = {
      protocol            = "HTTP"
      port                = 9015   # Service port
      request_path        = "/dev/api-edge/parcel/v2/healthCheck"
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
    }
  }

  # Backend service configurations
  backend_service_configs = {
    "ptms-tmob-active-active-dev" = {
      protocol          = "HTTP"
      port_name         = "http"
      timeout_sec       = 30
      health_check_name = "parceledge-v2"
      
      # Balancing settings (applied to all NEGs)
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 100
      capacity_scaler       = 1.0
      
      # All NEGs in one simple list (same format as neg-backends!)
      neg_names = [
        # us-south1
        "projects/uf-compute-d/zones/us-south1-a/networkEndpointGroups/neg-parceledge-south1-dev",
        "projects/uf-compute-d/zones/us-south1-b/networkEndpointGroups/neg-parceledge-south1-dev",
        "projects/uf-compute-d/zones/us-south1-c/networkEndpointGroups/neg-parceledge-south1-dev",
        # us-east4
        "projects/uf-compute-d/zones/us-east4-a/networkEndpointGroups/neg-parceledge-east4-dev",
        "projects/uf-compute-d/zones/us-east4-b/networkEndpointGroups/neg-parceledge-east4-dev",
        "projects/uf-compute-d/zones/us-east4-c/networkEndpointGroups/neg-parceledge-east4-dev",
      ]
    }
  }
}
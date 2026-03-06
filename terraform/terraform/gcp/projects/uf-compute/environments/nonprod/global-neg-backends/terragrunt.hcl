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
 
inputs = {
  project_id            = include.gcp.locals.project_id
  load_balancing_scheme = "EXTERNAL_MANAGED"

  # Health check configurations
  # NOTE: Use container port (9015) not service port (8080) because GLB talks directly to pods via NEG
  health_check_configs = {
    "parcel-apiedge" = {
      protocol            = "HTTP"
      port                = 9015   # Container port (targetPort in k8s service)
      request_path        = "/uat/api-edge/parcel/v2/healthCheck"
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
    }
  }

  # Backend service configurations
  backend_service_configs = {
    "parceledge" = {
      protocol          = "HTTP"
      port_name         = "http"
      timeout_sec       = 30
      health_check_name = "parcel-apiedge"
      
      # Balancing settings (applied to all NEGs)
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 100
      capacity_scaler       = 1.0
      
      # All NEGs in one simple list (same format as neg-backends!)
      neg_names = [
        # us-south1
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-parceledge-south1-uat",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-parceledge-south1-uat",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-parceledge-south1-uat",
        # us-east4
        "projects/uf-compute-n/zones/us-east4-a/networkEndpointGroups/neg-parceledge-east4-uat",
        "projects/uf-compute-n/zones/us-east4-b/networkEndpointGroups/neg-parceledge-east4-uat",
        "projects/uf-compute-n/zones/us-east4-c/networkEndpointGroups/neg-parceledge-east4-uat"
      ]
    }
  }
}

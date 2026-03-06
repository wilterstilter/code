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

dependency "vpc" {
  config_path = "../../../../freight-network-host/environments/nonprod/vpc"
}

inputs = {
  project_id            = include.gcp.locals.project_id
  load_balancing_scheme = "INTERNAL_MANAGED"

  # Health check configurations for PTMS-TMOB services
  health_check_configs = {
    "ptms-tmob-adminapi" = {
      protocol            = "HTTP"
      port                = 8080
      request_path        = "/ptms/t-mobile/api/admin/health/live"
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
    },
    "ptms-tmob-adminui" = {
      protocol            = "HTTP"
      port                = 8080
      request_path        = "/ptms/t-mobile/admin/"
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
    },
    "ptms-tmob-configapi" = {
      protocol            = "HTTP"
      port                = 8080
      request_path        = "/ptms/t-mobile/api/config/health/live"
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
    },
    "ptms-tmob-inductionui" = {
      protocol            = "HTTP"
      port                = 8080
      request_path        = "/ptms/t-mobile/induction/"
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
    },
    "ptms-tmob-labelapi" = {
      protocol            = "HTTP"
      port                = 8080
      request_path        = "/ptms/t-mobile/api/label/health/live"
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
    },
    "ptms-tmob-labelexternalapi" = {
      protocol            = "HTTP"
      port                = 8080
      request_path        = "/ptms/t-mobile/api/labelexternal/health/live"
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
    },
    "ptms-tmob-manifestapi" = {
      protocol            = "HTTP"
      port                = 8080
      request_path        = "/ptms/t-mobile/api/manifest/health/live"
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
    },
    "ptms-tmob-ratingapi" = {
      protocol            = "HTTP"
      port                = 8080
      request_path        = "/ptms/t-mobile/api/rating/health/live"
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
    },
    "ptms-tmob-ratingexternalapi" = {
      protocol            = "HTTP"
      port                = 8080
      request_path        = "/ptms/t-mobile/api/ratingexternal/health/live"
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
    },
    "ptms-tmob-reportsapi" = {
      protocol            = "HTTP"
      port                = 8080
      request_path        = "/ptms/t-mobile/api/reports/health/live"
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
    },
    "ptms-tmob-shippingapi" = {
      protocol            = "HTTP"
      port                = 8080
      request_path        = "/ptms/t-mobile/api/shipping/health/live"
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
    },
    "ptms-tmob-shippingexternalapi" = {
      protocol            = "HTTP"
      port                = 8080
      request_path        = "/ptms/t-mobile/api/shippingexternal/health/live"
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
    },
    "parceledge" = {
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
  # Each backend service now includes NEGs from BOTH regions for cross-region load balancing
  backend_service_configs = {
    # PTMS-TMOB Admin API - Active-Active across both regions
    "ptms-tmob-adminapi-uat" = {
      protocol              = "HTTP"
      port_name             = "http"
      timeout_sec           = 10
      health_check_name     = "ptms-tmob-adminapi"
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler       = 1.0
      
      neg_names = [
        # us-south1
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-ptms-tmob-adminapi-south1-uat",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-ptms-tmob-adminapi-south1-uat",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-ptms-tmob-adminapi-south1-uat",
        # us-east4
        "projects/uf-compute-n/zones/us-east4-a/networkEndpointGroups/neg-ptms-tmob-adminapi-east4-uat",
        "projects/uf-compute-n/zones/us-east4-b/networkEndpointGroups/neg-ptms-tmob-adminapi-east4-uat",
        "projects/uf-compute-n/zones/us-east4-c/networkEndpointGroups/neg-ptms-tmob-adminapi-east4-uat",
      ]
    },

    # PTMS-TMOB Admin UI
    "ptms-tmob-adminui-uat" = {
      protocol              = "HTTP"
      port_name             = "http"
      timeout_sec           = 10
      health_check_name     = "ptms-tmob-adminui"
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler       = 1.0
      
      neg_names = [
        # us-south1
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-ptms-tmob-adminui-south1-uat",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-ptms-tmob-adminui-south1-uat",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-ptms-tmob-adminui-south1-uat",
        # us-east4
        "projects/uf-compute-n/zones/us-east4-a/networkEndpointGroups/neg-ptms-tmob-adminui-east4-uat",
        "projects/uf-compute-n/zones/us-east4-b/networkEndpointGroups/neg-ptms-tmob-adminui-east4-uat",
        "projects/uf-compute-n/zones/us-east4-c/networkEndpointGroups/neg-ptms-tmob-adminui-east4-uat",
      ]
    },

    # PTMS-TMOB Config API
    "ptms-tmob-configapi-uat" = {
      protocol              = "HTTP"
      port_name             = "http"
      timeout_sec           = 10
      health_check_name     = "ptms-tmob-configapi"
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler       = 1.0
      
      neg_names = [
        # us-south1
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-ptms-tmob-configapi-south1-uat",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-ptms-tmob-configapi-south1-uat",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-ptms-tmob-configapi-south1-uat",
        # us-east4
        "projects/uf-compute-n/zones/us-east4-a/networkEndpointGroups/neg-ptms-tmob-configapi-east4-uat",
        "projects/uf-compute-n/zones/us-east4-b/networkEndpointGroups/neg-ptms-tmob-configapi-east4-uat",
        "projects/uf-compute-n/zones/us-east4-c/networkEndpointGroups/neg-ptms-tmob-configapi-east4-uat",
      ]
    },

    # PTMS-TMOB Induction UI
    "ptms-tmob-inductionui-uat" = {
      protocol              = "HTTP"
      port_name             = "http"
      timeout_sec           = 10
      health_check_name     = "ptms-tmob-inductionui"
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler       = 1.0
      
      neg_names = [
        # us-south1
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-ptms-tmob-inductionui-south1-uat",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-ptms-tmob-inductionui-south1-uat",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-ptms-tmob-inductionui-south1-uat",
        # us-east4
        "projects/uf-compute-n/zones/us-east4-a/networkEndpointGroups/neg-ptms-tmob-inductionui-east4-uat",
        "projects/uf-compute-n/zones/us-east4-b/networkEndpointGroups/neg-ptms-tmob-inductionui-east4-uat",
        "projects/uf-compute-n/zones/us-east4-c/networkEndpointGroups/neg-ptms-tmob-inductionui-east4-uat",
      ]
    },

    # PTMS-TMOB Label API
    "ptms-tmob-labelapi-uat" = {
      protocol              = "HTTP"
      port_name             = "http"
      timeout_sec           = 10
      health_check_name     = "ptms-tmob-labelapi"
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler       = 1.0
      
      neg_names = [
        # us-south1
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-ptms-tmob-labelapi-south1-uat",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-ptms-tmob-labelapi-south1-uat",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-ptms-tmob-labelapi-south1-uat",
        # us-east4
        "projects/uf-compute-n/zones/us-east4-a/networkEndpointGroups/neg-ptms-tmob-labelapi-east4-uat",
        "projects/uf-compute-n/zones/us-east4-b/networkEndpointGroups/neg-ptms-tmob-labelapi-east4-uat",
        "projects/uf-compute-n/zones/us-east4-c/networkEndpointGroups/neg-ptms-tmob-labelapi-east4-uat",
      ]
    },

    # PTMS-TMOB Label External API
    "ptms-tmob-labelexternalapi-uat" = {
      protocol              = "HTTP"
      port_name             = "http"
      timeout_sec           = 10
      health_check_name     = "ptms-tmob-labelexternalapi"
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler       = 1.0
      
      neg_names = [
        # us-south1
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-ptms-tmob-labelexternalapi-south1-uat",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-ptms-tmob-labelexternalapi-south1-uat",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-ptms-tmob-labelexternalapi-south1-uat",
        # us-east4
        "projects/uf-compute-n/zones/us-east4-a/networkEndpointGroups/neg-ptms-tmob-labelexternalapi-east4-uat",
        "projects/uf-compute-n/zones/us-east4-b/networkEndpointGroups/neg-ptms-tmob-labelexternalapi-east4-uat",
        "projects/uf-compute-n/zones/us-east4-c/networkEndpointGroups/neg-ptms-tmob-labelexternalapi-east4-uat",
      ]
    },

    # PTMS-TMOB Manifest API
    "ptms-tmob-manifestapi-uat" = {
      protocol              = "HTTP"
      port_name             = "http"
      timeout_sec           = 10
      health_check_name     = "ptms-tmob-manifestapi"
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler       = 1.0
      
      neg_names = [
        # us-south1
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-ptms-tmob-manifestapi-south1-uat",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-ptms-tmob-manifestapi-south1-uat",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-ptms-tmob-manifestapi-south1-uat",
        # us-east4
        "projects/uf-compute-n/zones/us-east4-a/networkEndpointGroups/neg-ptms-tmob-manifestapi-east4-uat",
        "projects/uf-compute-n/zones/us-east4-b/networkEndpointGroups/neg-ptms-tmob-manifestapi-east4-uat",
        "projects/uf-compute-n/zones/us-east4-c/networkEndpointGroups/neg-ptms-tmob-manifestapi-east4-uat",
      ]
    },

    # PTMS-TMOB Rating API
    "ptms-tmob-ratingapi-uat" = {
      protocol              = "HTTP"
      port_name             = "http"
      timeout_sec           = 10
      health_check_name     = "ptms-tmob-ratingapi"
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler       = 1.0
      
      neg_names = [
        # us-south1
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-ptms-tmob-ratingapi-south1-uat",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-ptms-tmob-ratingapi-south1-uat",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-ptms-tmob-ratingapi-south1-uat",
        # us-east4
        "projects/uf-compute-n/zones/us-east4-a/networkEndpointGroups/neg-ptms-tmob-ratingapi-east4-uat",
        "projects/uf-compute-n/zones/us-east4-b/networkEndpointGroups/neg-ptms-tmob-ratingapi-east4-uat",
        "projects/uf-compute-n/zones/us-east4-c/networkEndpointGroups/neg-ptms-tmob-ratingapi-east4-uat",
      ]
    },

    # PTMS-TMOB Rating External API
    "ptms-tmob-ratingexternalapi-uat" = {
      protocol              = "HTTP"
      port_name             = "http"
      timeout_sec           = 10
      health_check_name     = "ptms-tmob-ratingexternalapi"
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler       = 1.0
      
      neg_names = [
        # us-south1
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-ptms-tmob-ratingexternalapi-south1-uat",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-ptms-tmob-ratingexternalapi-south1-uat",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-ptms-tmob-ratingexternalapi-south1-uat",
        # us-east4
        "projects/uf-compute-n/zones/us-east4-a/networkEndpointGroups/neg-ptms-tmob-ratingexternalapi-east4-uat",
        "projects/uf-compute-n/zones/us-east4-b/networkEndpointGroups/neg-ptms-tmob-ratingexternalapi-east4-uat",
        "projects/uf-compute-n/zones/us-east4-c/networkEndpointGroups/neg-ptms-tmob-ratingexternalapi-east4-uat",
      ]
    },

    # PTMS-TMOB Reports API
    "ptms-tmob-reportsapi-uat" = {
      protocol              = "HTTP"
      port_name             = "http"
      timeout_sec           = 10
      health_check_name     = "ptms-tmob-reportsapi"
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler       = 1.0
      
      neg_names = [
        # us-south1
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-ptms-tmob-reportsapi-south1-uat",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-ptms-tmob-reportsapi-south1-uat",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-ptms-tmob-reportsapi-south1-uat",
        # us-east4
        "projects/uf-compute-n/zones/us-east4-a/networkEndpointGroups/neg-ptms-tmob-reportsapi-east4-uat",
        "projects/uf-compute-n/zones/us-east4-b/networkEndpointGroups/neg-ptms-tmob-reportsapi-east4-uat",
        "projects/uf-compute-n/zones/us-east4-c/networkEndpointGroups/neg-ptms-tmob-reportsapi-east4-uat",
      ]
    },

    # PTMS-TMOB Shipping API
    "ptms-tmob-shippingapi-uat" = {
      protocol              = "HTTP"
      port_name             = "http"
      timeout_sec           = 10
      health_check_name     = "ptms-tmob-shippingapi"
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler       = 1.0
      
      neg_names = [
        # us-south1
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-ptms-tmob-shippingapi-south1-uat",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-ptms-tmob-shippingapi-south1-uat",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-ptms-tmob-shippingapi-south1-uat",
        # us-east4
        "projects/uf-compute-n/zones/us-east4-a/networkEndpointGroups/neg-ptms-tmob-shippingapi-east4-uat",
        "projects/uf-compute-n/zones/us-east4-b/networkEndpointGroups/neg-ptms-tmob-shippingapi-east4-uat",
        "projects/uf-compute-n/zones/us-east4-c/networkEndpointGroups/neg-ptms-tmob-shippingapi-east4-uat",
      ]
    },

    # PTMS-TMOB Shipping External API
    "ptms-tmob-shippingexternalapi-uat" = {
      protocol              = "HTTP"
      port_name             = "http"
      timeout_sec           = 10
      health_check_name     = "ptms-tmob-shippingexternalapi"
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler       = 1.0
      
      neg_names = [
        # us-south1
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-ptms-tmob-shippingexternalapi-south1-uat",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-ptms-tmob-shippingexternalapi-south1-uat",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-ptms-tmob-shippingexternalapi-south1-uat",
        # us-east4
        "projects/uf-compute-n/zones/us-east4-a/networkEndpointGroups/neg-ptms-tmob-shippingexternalapi-east4-uat",
        "projects/uf-compute-n/zones/us-east4-b/networkEndpointGroups/neg-ptms-tmob-shippingexternalapi-east4-uat",
        "projects/uf-compute-n/zones/us-east4-c/networkEndpointGroups/neg-ptms-tmob-shippingexternalapi-east4-uat",
      ]
    },
    
    "parceledge-uat" = {
      protocol          = "HTTP"
      port_name         = "http"
      timeout_sec       = 30
      health_check_name = "parceledge"
      
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

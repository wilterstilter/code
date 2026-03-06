include "gcp" {
    path = find_in_parent_folders()
    expose = true
}
 
terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-compute/modules/neg-backends"
}
 
include "common" {
    path = find_in_parent_folders("common.hcl")
    expose = true
}
 
dependency "vpc" {
  config_path = "../../../../freight-network-host/environments/prod/vpc"
}
 
inputs = {
  project_id          = include.gcp.locals.project_id
  region              = "us-south1"
  protocol            = "HTTP"
  timeout_sec         = 10
  load_balancing_scheme = "INTERNAL_MANAGED"
 
  # Health check configurations
  health_check_configs = {
    "nginx" = {
      check_interval_sec  = 10
      timeout_sec         = 5
      healthy_threshold   = 2
      unhealthy_threshold = 2
      request_path        = "/"
      port                = 80
    },
    "dir-app" = {
      check_interval_sec  = 15
      timeout_sec         = 5
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/"
      port                = 8080
    },
    "optimize-service" = {
      check_interval_sec  = 15
      timeout_sec         = 5
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/optimize-service/actuator/health"
      port                = 8080
    },
    "mit" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/mit/actuator/health"
      port                = 8080
    },
    "alert-service" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/alert-service/actuator/info"
      port                = 8080
    },
    "carrierauctionservice" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/carrier-auction-service/v2/alive"
      port                = 8080
    },
    "checkcallkafkastreamapp" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/check-call-stream-api/alive"
      port                = 8080
    },
    "cms" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/cms/IAmAlive.html"
      port                = 8080
    },
    "config-app" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/configuration/ImAlive.htm"
      port                = 8080
    },
    "configserver-v2" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/spring-config-v2/junction/default"
      port                = 8888
    },
    "control-tower" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/ct/info"
      port                = 8080
    },
    "dcmengine" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/dcm/dcm-engine/v1/alive"
      port                = 8080
    },
    "dcmservice" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/dcm/dcm-service/v1/alive"
      port                = 8080
    },
    "documentai" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/ops/swagger/index.html"
      port                = 8080
    },
    "draco-es-client-svc" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/draco-es-client-svc/info"
      port                = 8080
    },
    "draco-es-client" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/draco-es-client/info"
      port                = 8080
    },
    "draco" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/draco/ImAlive.html"
      port                = 8080
    },
    "drome" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/drome/es/config"
      port                = 8080
    },
    "eventmediator" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/eda-service/v1/alive"
      port                = 8080
    },
    "externalrates" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/externalrates/actuator/health"
      port                = 8080
    },
    "integrated-price-link" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/ipl/actuator/health"
      port                = 8080
    },
    "javajunction" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/junction/actuator/health"
      port                = 8080
    },
    "ltlcarrierapiservice" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/ltlcarrierapiservice/pingme"
      port                = 8080
    },
    "mobile-api" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/mobile-access/"
      port                = 8080
    },
    "notificationservice" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/notification/v1/alive"
      port                = 8080
    },
    "op-job-scheduler" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/op-job-scheduler/actuator/health"
      port                = 8080
    },
    "optimizefacade" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/optimizefacade/actuator/health"
      port                = 8080
    },
    "optimizemediator" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/optimizemediator/actuator/health"
      port                = 8080
    },
    "optimizeservice" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/optmize-service/actuator/health"
      port                = 8080
    },
    "parcelcarrierapiservice" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/parcel-carrier-api-service/actuator"
      port                = 8080
    },
    "parcelratingservice" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/rating-service/actuator/health"
      port                = 8080
    },
    "radeon" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/radeon/v1/alive"
      port                = 8080
    },
    "rateapproval" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/rateapproval/info"
      port                = 8080
    },
    "rates-and-lanes" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/rates-and-lanes/actuator/health"
      port                = 8080
    },
    "ratingmaintenance" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/rating/maintenance/v1/alive"
      port                = 8080
    },
    "ratingregressionsuite" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/rating-regression/actuator/health"
      port                = 8080
    },
    "ratingsearch" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/ratingsearch/v1/alive"
      port                = 8080
    },
    "riskpulse" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/riskpulse/actuator/health"
      port                = 8080
    },
    "route-service" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/info"
      port                = 8080
    },
    "routing-service" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/routing-service/actuator/health"
      port                = 8080
    },
    "common" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/"
      port                = 80
    },
    "security" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/security/security/ImAlive.html"
      port                = 8080
    },
    "settings-backend" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/settings/actuator/health"
      port                = 8080
    },
    "shipment-search" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/shipment-search/actuator/health"
      port                = 8080
    },
    "sidekick" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/sidekick/api/info"
      port                = 9090
    },
    "sku" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/sku/IAmAlive.html"
      port                = 8080
    },
    "tenderservice" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/tenderservice/actuator/health"
      port                = 8080
    },
    "tinyurlservice" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/io/"
      port                = 8080
    },
    "tp-kafka-connect" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/"
      port                = 8083
    },
    "tracking" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/tracking/pingme"
      port                = 8080
    },
    "trackingportalservice" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/tracking/alive/test"
      port                = 8080
    },
    "cp" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/cp/version.jsp"
      port                = 8080
    },
    "yms" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/yms/info"
      port                = 8080
    }
  }
 
  # Backend service configurations
  backend_service_configs = {
    "nginx" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-nginx-ilb",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-nginx-ilb"
      ]
      health_check_name    = "nginx"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 10
      capacity_scaler      = 1.0
    },
    "dir-app" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-alive"
      ]
      health_check_name    = "dir-app"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 10
      capacity_scaler      = 1.0
    },
    "optimize-service-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-optimizeservice-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-optimizeservice-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-optimizeservice-dev"  
      ]
      health_check_name    = "optimize-service"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 10
      capacity_scaler      = 1.0
    },
    "optimize-service" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-optimizeservice-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-optimizeservice-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-optimizeservice-dev"  
      ]
      health_check_name    = "optimize-service"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 10
      capacity_scaler      = 1.0
    },
    "mit-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-mit-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-mit-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-mit-dev", 
      ]
      health_check_name    = "abhi"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "mit" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-mit-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-mit-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-mit-dev", 
      ]
      health_check_name    = "abhi"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "alert-service-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-alert-service-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-alert-service-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-alert-service-dev", 
      ]
      health_check_name    = "alert-service"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "auctions-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-auctions-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-auctions-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-auctions-dev", 
      ]
      health_check_name    = "dummy"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "carrier" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-carrier-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-carrier-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-carrier-dev", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "carrierauctionservice-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-carrierauctionservice-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-carrierauctionservice-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-carrierauctionservice-dev", 
      ]
      health_check_name    = "carrierauctionservice"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "checkcallkafkastreamapp-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-checkcallkafkastreamapp-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-checkcallkafkastreamapp-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-checkcallkafkastreamapp-dev", 
      ]
      health_check_name    = "checkcallkafkastreamapp"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "cms-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-cms-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-cms-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-cms-dev", 
      ]
      health_check_name    = "cms"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "config-app-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-config-app-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-config-app-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-config-app-dev", 
      ]
      health_check_name    = "config-app"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "configserver-v2-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-configserver-v2-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-configserver-v2-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-configserver-v2-dev", 
      ]
      health_check_name    = "configserver-v2"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "configuration-ui-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-configuration-ui-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-configuration-ui-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-configuration-ui-dev", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "control-tower-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-control-tower-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-control-tower-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-control-tower-dev", 
      ]
      health_check_name    = "control-tower"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "dcm-ui-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-dcm-ui-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-dcm-ui-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-dcm-ui-dev", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "dcmengine-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-dcmengine-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-dcmengine-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-dcmengine-dev", 
      ]
      health_check_name    = "dcmengine"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "dcmservice-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-dcmservice-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-dcmservice-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-dcmservice-dev", 
      ]
      health_check_name    = "dcmservice"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "distance-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-distance-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-distance-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-distance-dev", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "documentai-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-documentai-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-documentai-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-documentai-dev", 
      ]
      health_check_name    = "documentai"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "draco-es-client-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-draco-es-client-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-draco-es-client-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-draco-es-client-dev", 
      ]
      health_check_name    = "draco-es-client"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "draco-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-draco-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-draco-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-draco-dev", 
      ]
      health_check_name    = "draco"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "drome-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-drome-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-drome-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-drome-dev", 
      ]
      health_check_name    = "drome"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "ds-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-ds-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-ds-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-ds-dev", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "earbuds-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-earbuds-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-earbuds-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-earbuds-dev", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "ect-ui-v2-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-ect-ui-v2-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-ect-ui-v2-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-ect-ui-v2-dev", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "ect-ui-v2" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-ect-ui-v2-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-ect-ui-v2-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-ect-ui-v2-dev", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "ect-ui-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-ect-ui-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-ect-ui-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-ect-ui-dev", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "ect-ui" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-ect-ui-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-ect-ui-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-ect-ui-dev", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "eventmediator-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-eventmediator-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-eventmediator-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-eventmediator-dev", 
      ]
      health_check_name    = "eventmediator"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "externalrates-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-externalrates-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-externalrates-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-externalrates-dev", 
      ]
      health_check_name    = "externalrates"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "integrated-price-link-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-integrated-price-link-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-integrated-price-link-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-integrated-price-link-dev", 
      ]
      health_check_name    = "integrated-price-link"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "isd-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-isd-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-isd-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-isd-dev", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "javajunction-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-javajunction-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-javajunction-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-javajunction-dev", 
      ]
      health_check_name    = "javajunction"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "location-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-location-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-location-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-location-dev", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "ltlcarrierapiservice-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-ltlcarrierapiservice-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-ltlcarrierapiservice-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-ltlcarrierapiservice-dev", 
      ]
      health_check_name    = "ltlcarrierapiservice"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "mobile-api-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-mobile-api-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-mobile-api-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-mobile-api-dev", 
      ]
      health_check_name    = "mobile-api"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "notificationservice-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-notificationservice-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-notificationservice-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-notificationservice-dev", 
      ]
      health_check_name    = "notificationservice"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "op-job-scheduler-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-op-job-scheduler-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-op-job-scheduler-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-op-job-scheduler-dev", 
      ]
      health_check_name    = "op-job-scheduler"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "opconsumer-cr-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-opconsumer-cr-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-opconsumer-cr-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-opconsumer-cr-dev", 
      ]
      health_check_name    = "dummy"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "opconsumer-faq-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-opconsumer-faq-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-opconsumer-faq-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-opconsumer-faq-dev", 
      ]
      health_check_name    = "dummy"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "opconsumer-nom-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-opconsumer-nom-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-opconsumer-nom-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-opconsumer-nom-dev", 
      ]
      health_check_name    = "dummy"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "opconsumer-pop-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-opconsumer-pop-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-opconsumer-pop-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-opconsumer-pop-dev", 
      ]
      health_check_name    = "dummy"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "opconsumer-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-opconsumer-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-opconsumer-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-opconsumer-dev", 
      ]
      health_check_name    = "dummy"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "optimizefacade-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-optimizefacade-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-optimizefacade-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-optimizefacade-dev", 
      ]
      health_check_name    = "optimizefacade"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "optimizemediator-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-optimizemediator-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-optimizemediator-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-optimizemediator-dev", 
      ]
      health_check_name    = "optimizemediator"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "optimizeservice-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-optimizeservice-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-optimizeservice-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-optimizeservice-dev", 
      ]
      health_check_name    = "optimizeservice"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "orders-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-orders-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-orders-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-orders-dev", 
      ]
      health_check_name    = "dummy"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "parcel-ui-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-parcel-ui-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-parcel-ui-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-parcel-ui-dev", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "parcelcarrierapiservice-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-parcelcarrierapiservice-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-parcelcarrierapiservice-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-parcelcarrierapiservice-dev", 
      ]
      health_check_name    = "parcelcarrierapiservice"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "parcelratingservice" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-parcelratingservice-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-parcelratingservice-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-parcelratingservice-dev", 
      ]
      health_check_name    = "parcelratingservice"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "radeon-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-radeon-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-radeon-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-radeon-dev", 
      ]
      health_check_name    = "radeon"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "rateapproval-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-rateapproval-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-rateapproval-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-rateapproval-dev", 
      ]
      health_check_name    = "rateapproval"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "rates-and-lanes-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-rates-and-lanes-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-rates-and-lanes-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-rates-and-lanes-dev", 
      ]
      health_check_name    = "rates-and-lanes"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 1800
    },
    "ratingmaintenance-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-ratingmaintenance-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-ratingmaintenance-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-ratingmaintenance-dev", 
      ]
      health_check_name    = "ratingmaintenance"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "ratingregressionsuite-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-ratingregressionsuite-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-ratingregressionsuite-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-ratingregressionsuite-dev", 
      ]
      health_check_name    = "ratingregressionsuite"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "route-service-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-route-service-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-route-service-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-route-service-dev", 
      ]
      health_check_name    = "route-service"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "routing-service-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-routing-service-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-routing-service-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-routing-service-dev", 
      ]
      health_check_name    = "routing-service"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "se-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-se-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-se-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-se-dev", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "security-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-security-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-security-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-security-dev", 
      ]
      health_check_name    = "security"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "sec-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-sec-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-sec-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-sec-dev", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "settings-backend-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-settings-backend-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-settings-backend-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-settings-backend-dev", 
      ]
      health_check_name    = "settings-backend"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "settings-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-settings-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-settings-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-settings-dev", 
      ]
      health_check_name    = "dummy"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "shipment-search-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-shipment-search-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-shipment-search-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-shipment-search-dev", 
      ]
      health_check_name    = "shipment-search"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "shipments-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-shipments-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-shipments-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-shipments-dev", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "sidekick-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-sidekick-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-sidekick-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-sidekick-dev", 
      ]
      health_check_name    = "sidekick"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "sku-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-sku-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-sku-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-sku-dev", 
      ]
      health_check_name    = "sku"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "smp-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-smp-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-smp-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-smp-dev", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "sp-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-sp-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-sp-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-sp-dev", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "srg-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-srg-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-srg-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-srg-dev", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "tenderservice-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-tenderservice-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-tenderservice-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-tenderservice-dev", 
      ]
      health_check_name    = "tenderservice"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "tinyurlservice-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-tinyurlservice-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-tinyurlservice-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-tinyurlservice-dev", 
      ]
      health_check_name    = "tinyurlservice"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "tp-angular-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-tp-angular-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-tp-angular-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-tp-angular-dev", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "tp-kafka-connect-distributed-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-tp-kafka-connect-distributed-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-tp-kafka-connect-distributed-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-tp-kafka-connect-distributed-dev", 
      ]
      health_check_name    = "tp-kafka-connect"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "tp-kafka-connect-elastic-sink-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-tp-kafka-connect-elastic-sink-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-tp-kafka-connect-elastic-sink-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-tp-kafka-connect-elastic-sink-dev", 
      ]
      health_check_name    = "tp-kafka-connect"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "tp-kafka-connect-jdbc-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-tp-kafka-connect-jdbc-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-tp-kafka-connect-jdbc-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-tp-kafka-connect-jdbc-dev", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "tracking-portal-ui-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-tracking-portal-ui-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-tracking-portal-ui-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-tracking-portal-ui-dev", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "tracking-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-tracking-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-tracking-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-tracking-dev", 
      ]
      health_check_name    = "tracking"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "trackingportalservice-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-trackingportalservice-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-trackingportalservice-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-trackingportalservice-dev", 
      ]
      health_check_name    = "trackingportalservice"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "monorepotracking-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-monorepotracking-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-monorepotracking-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-monorepotracking-dev", 
      ]
      health_check_name    = "dummy"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "yms-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-yms-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-yms-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-yms-dev", 
      ]
      health_check_name    = "yms"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "cp-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-cp-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-cp-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-cp-dev", 
      ]
      health_check_name    = "cp"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "ratingsearch-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-ratingsearch-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-ratingsearch-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-ratingsearch-dev", 
      ]
      health_check_name    = "ratingsearch"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "riskpulse-dev" = {
      neg_names = [
        "projects/uf-compute-p/zones/us-south1-a/networkEndpointGroups/neg-riskpulse-dev",
        "projects/uf-compute-p/zones/us-south1-b/networkEndpointGroups/neg-riskpulse-dev",
        "projects/uf-compute-p/zones/us-south1-c/networkEndpointGroups/neg-riskpulse-dev", 
      ]
      health_check_name    = "riskpulse"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },

  }
}

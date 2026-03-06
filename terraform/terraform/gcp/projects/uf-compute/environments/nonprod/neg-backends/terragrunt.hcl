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
  config_path = "../../../../freight-network-host/environments/nonprod/vpc"
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
    "cp" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/cp/version.jsp"
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
      port                = 3030
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
    "drome-v2" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/drome-v2/es/config"
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
    "parcellogisticsservice" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/parcel/logistics-service/actuator/health"
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
    "parcelserviceprovider" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/parcel/service-provider/actuator/health"
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
      request_path        = "/tracking/alive/staging"
      port                = 8080
    },
    "yms" = {
      check_interval_sec  = 30
      timeout_sec         = 30
      healthy_threshold   = 3
      unhealthy_threshold = 2
      request_path        = "/yms/info"
      port                = 8080
    },
  }
 
  # Backend service configurations
  backend_service_configs = {
    "optimize-service-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-optimizeservice-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-optimizeservice-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-optimizeservice-staging"  
      ]
      health_check_name    = "optimize-service"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 10
      capacity_scaler      = 1.0
    },
    "optimize-service" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-optimizeservice-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-optimizeservice-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-optimizeservice-staging"  
      ]
      health_check_name    = "optimize-service"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 10
      capacity_scaler      = 1.0
    },
    "mit-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-mit-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-mit-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-mit-staging", 
      ]
      health_check_name    = "mit"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "alert-service-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-alert-service-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-alert-service-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-alert-service-staging", 
      ]
      health_check_name    = "alert-service"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "carrier" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-carrier-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-carrier-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-carrier-staging", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "carrierauctionservice-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-carrierauctionservice-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-carrierauctionservice-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-carrierauctionservice-staging", 
      ]
      health_check_name    = "carrierauctionservice"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "cms-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-cms-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-cms-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-cms-staging", 
      ]
      health_check_name    = "cms"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "config-app-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-config-app-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-config-app-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-config-app-staging", 
      ]
      health_check_name    = "config-app"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "configserver-v2-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-configserver-v2-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-configserver-v2-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-configserver-v2-staging", 
      ]
      health_check_name    = "configserver-v2"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "configuration-ui-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-configuration-ui-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-configuration-ui-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-configuration-ui-staging", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "control-tower-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-control-tower-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-control-tower-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-control-tower-staging", 
      ]
      health_check_name    = "control-tower"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "distance-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-distance-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-distance-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-distance-staging", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "draco-es-client-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-draco-es-client-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-draco-es-client-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-draco-es-client-staging", 
      ]
      health_check_name    = "draco-es-client"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "draco-es-client-svc-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-draco-es-client-svc-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-draco-es-client-svc-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-draco-es-client-svc-staging", 
      ]
      health_check_name    = "draco-es-client-svc"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "draco-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-draco-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-draco-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-draco-staging", 
      ]
      health_check_name    = "draco"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "drome-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-drome-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-drome-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-drome-staging", 
      ]
      health_check_name    = "drome"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "ds-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-ds-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-ds-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-ds-staging", 
      ]
      health_check_name    = "dummy"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "ect-ui-v2-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-ect-ui-v2-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-ect-ui-v2-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-ect-ui-v2-staging", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
      logging               = true
    },
    "ect-ui-v2" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-ect-ui-v2-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-ect-ui-v2-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-ect-ui-v2-staging", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
      logging               = true
    },
    "ect-ui-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-ect-ui-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-ect-ui-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-ect-ui-staging", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "ect-ui" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-ect-ui-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-ect-ui-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-ect-ui-staging", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "externalrates-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-externalrates-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-externalrates-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-externalrates-staging", 
      ]
      health_check_name    = "externalrates"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "integrated-price-link-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-integrated-price-link-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-integrated-price-link-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-integrated-price-link-staging", 
      ]
      health_check_name    = "integrated-price-link"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "isd-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-isd-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-isd-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-isd-staging", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "javajunction-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-javajunction-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-javajunction-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-javajunction-staging", 
      ]
      health_check_name    = "javajunction"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "location-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-location-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-location-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-location-staging", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "ltlcarrierapiservice-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-ltlcarrierapiservice-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-ltlcarrierapiservice-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-ltlcarrierapiservice-staging", 
      ]
      health_check_name    = "ltlcarrierapiservice"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "mobile-api-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-mobile-api-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-mobile-api-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-mobile-api-staging", 
      ]
      health_check_name    = "mobile-api"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "notificationservice-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-notificationservice-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-notificationservice-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-notificationservice-staging", 
      ]
      health_check_name    = "notificationservice"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "op-job-scheduler-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-op-job-scheduler-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-op-job-scheduler-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-op-job-scheduler-staging", 
      ]
      health_check_name    = "op-job-scheduler"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "optimizefacade-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-optimizefacade-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-optimizefacade-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-optimizefacade-staging", 
      ]
      health_check_name    = "optimizefacade"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "optimizemediator-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-optimizemediator-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-optimizemediator-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-optimizemediator-staging", 
      ]
      health_check_name    = "optimizemediator"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "optimizeservice-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-optimizeservice-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-optimizeservice-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-optimizeservice-staging", 
      ]
      health_check_name    = "optimizeservice"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "parcel-ui-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-parcel-ui-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-parcel-ui-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-parcel-ui-staging", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "parcelratingservice" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-parcelratingservice-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-parcelratingservice-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-parcelratingservice-staging", 
      ]
      health_check_name    = "parcelratingservice"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "radeon-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-radeon-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-radeon-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-radeon-staging", 
      ]
      health_check_name    = "radeon"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "rateapproval-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-rateapproval-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-rateapproval-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-rateapproval-staging", 
      ]
      health_check_name    = "rateapproval"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "rates-and-lanes-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-rates-and-lanes-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-rates-and-lanes-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-rates-and-lanes-staging", 
      ]
      health_check_name    = "rates-and-lanes"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 1800
      logging               = true
    },
    "ratingmaintenance-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-ratingmaintenance-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-ratingmaintenance-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-ratingmaintenance-staging", 
      ]
      health_check_name    = "ratingmaintenance"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "route-service-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-route-service-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-route-service-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-route-service-staging", 
      ]
      health_check_name    = "route-service"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "routing-service-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-routing-service-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-routing-service-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-routing-service-staging", 
      ]
      health_check_name    = "routing-service"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "se-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-se-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-se-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-se-staging", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "security-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-security-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-security-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-security-staging", 
      ]
      health_check_name    = "security"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "sec-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-sec-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-sec-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-sec-staging", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "settings-backend-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-settings-backend-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-settings-backend-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-settings-backend-staging", 
      ]
      health_check_name    = "settings-backend"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "sidekick-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-sidekick-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-sidekick-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-sidekick-staging", 
      ]
      health_check_name    = "sidekick"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "sku-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-sku-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-sku-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-sku-staging", 
      ]
      health_check_name    = "sku"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "smp-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-smp-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-smp-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-smp-staging", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "sp-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-sp-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-sp-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-sp-staging", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "srg-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-srg-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-srg-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-srg-staging", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "tenderservice-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-tenderservice-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-tenderservice-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-tenderservice-staging", 
      ]
      health_check_name    = "tenderservice"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "tinyurlservice-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-tinyurlservice-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-tinyurlservice-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-tinyurlservice-staging", 
      ]
      health_check_name    = "tinyurlservice"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "tracking-portal-ui-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-tracking-portal-ui-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-tracking-portal-ui-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-tracking-portal-ui-staging", 
      ]
      health_check_name    = "common"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "tracking-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-tracking-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-tracking-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-tracking-staging", 
      ]
      health_check_name    = "tracking"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "trackingportalservice-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-trackingportalservice-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-trackingportalservice-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-trackingportalservice-staging", 
      ]
      health_check_name    = "trackingportalservice"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
      timeout_sec           = 300
    },
    "yms-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-yms-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-yms-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-yms-staging", 
      ]
      health_check_name    = "yms"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "ratingsearch-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-ratingsearch-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-ratingsearch-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-ratingsearch-staging", 
      ]
      health_check_name    = "ratingsearch"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
    "riskpulse-staging" = {
      neg_names = [
        "projects/uf-compute-n/zones/us-south1-a/networkEndpointGroups/neg-riskpulse-staging",
        "projects/uf-compute-n/zones/us-south1-b/networkEndpointGroups/neg-riskpulse-staging",
        "projects/uf-compute-n/zones/us-south1-c/networkEndpointGroups/neg-riskpulse-staging", 
      ]
      health_check_name    = "riskpulse"
      balancing_mode       = "RATE"
      max_rate_per_endpoint = 20
      capacity_scaler      = 1.0
    },
  }
}

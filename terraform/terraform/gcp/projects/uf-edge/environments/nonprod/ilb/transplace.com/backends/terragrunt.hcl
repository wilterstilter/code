inputs = {
  backends = {
    "tms-staging" = {
      neg_links             = [for zone, link in dependency.tms-staging.outputs.neg_self_link: link]
      health_check          = "tms-staging"
      timeout_sec           = 900
      security_policy       = dependency.cloud_armor.outputs.security_policy_self_link
    },
    "tmsservices-staging" = {
      neg_links             = [for zone, link in dependency.tmsservices-staging.outputs.neg_self_link: link]
      health_check          = "tms-staging"
      timeout_sec           = 900
      security_policy       = dependency.cloud_armor.outputs.security_policy_self_link
    },
    "ocp-staging" = {
      neg_links             = [for zone, link in dependency.ocp-staging.outputs.neg_self_link: link]
      health_check          = "ocp-staging"
    },
    "optimize-staging" = {
      neg_links             = [for zone, link in dependency.optimize-staging.outputs.neg_self_link: link]
      health_check          = "optimize-staging"
      security_policy       = dependency.cloud_armor.outputs.security_policy_self_link    
    },
    "optimizeengine-staging" = {
      neg_links             = [for zone, link in dependency.optimize-staging.outputs.neg_self_link: link]
      health_check          = "optimizeengine-staging"
    },
    "optimizerest-staging" = {
      neg_links             = [for zone, link in dependency.optimize-staging.outputs.neg_self_link: link]
      health_check          = "optimizerest-staging"
    },
    "correctaddress-staging" = {
      neg_links             = [for zone, link in dependency.correctaddress-staging.outputs.neg_self_link: link]
      health_check          = "correctaddress-staging"
    },
    "rating-staging" = {
      neg_links             = [for zone, link in dependency.rating-staging.outputs.neg_self_link: link]
      health_check          = "rating-staging"
    },
    "oca-staging" = {
      neg_links             = [for zone, link in dependency.oca-staging.outputs.neg_self_link: link]
      health_check          = "oca-staging"
      timeout_sec           = 300
    },
    "rmc-staging" = {
      neg_links             = [for zone, link in dependency.rmceng19-staging.outputs.neg_self_link: link]
      health_check          = "rmc-staging"
      timeout_sec           = 300
    },
    "dms-staging" = {
      neg_links             = [for zone, link in dependency.dms-staging.outputs.neg_self_link: link]
      health_check          = "dms-staging"
      timeout_sec            = 600
    },
    "smp-staging" = {
      neg_links             = [for zone, link in dependency.smp-staging.outputs.neg_self_link: link]
      health_check          = "smp-staging"
      timeout_sec           = 600
    },
    "ptms-staging" = {
      neg_links             = [for zone, link in dependency.ptms-staging.outputs.neg_self_link: link]
      health_check          = "ptms-staging"
    },
    "cp-staging" = {
      neg_links             = [for zone, link in dependency.cp-staging.outputs.neg_self_link: link]
      health_check          = "cp-staging"
      security_policy       = dependency.cloud_armor.outputs.security_policy_self_link
      timeout_sec           = 600
    },
    "ratingmaintenance-staging" = {
      neg_links             = [for zone, link in dependency.rating-staging.outputs.neg_self_link: link]
      health_check          = "ratingmaintenance-staging"
    },
    "ratingengine-staging" = {
      neg_links             = [for zone, link in dependency.rating-staging.outputs.neg_self_link: link]
      health_check          = "ratingengine-staging"
    },
    "ratingexternal-staging" = {
      neg_links             = [for zone, link in dependency.rating-staging.outputs.neg_self_link: link]
      health_check          = "ratingexternal-staging"
    },
    "optimizeservice-staging" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-optimize-service-staging"
      health_check          = "optimize-staging"
    },
    "mit-staging" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-mit-staging"
      health_check          = "mit-staging"
    },
    "configserver-v2-staging" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-configserver-v2-staging"
      health_check          = "gke-nginx" 
    },
    "yms-staging" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-yms-staging"
    },
    "security-staging" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-security-staging"
      timeout_sec            = 300
    },
    "cms-staging" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-cms-staging"
    },
    "sku-staging" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-sku-staging"
    },
    "draco-staging" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-draco-staging"
    },
    "mobile-api-staging" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-mobile-api-staging"
    },
    "control-tower-staging" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-control-tower-staging"
    },
    "drome-staging" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-drome-staging"
    },
    "rateapproval-staging" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-rateapproval-staging"
    },
    "location-staging" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-location-staging"
    },
    "tinyurlservice-staging" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-tinyurlservice-staging"
    },
    "settings-backend-staging" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-settings-backend-staging"
    },
    "srg-staging" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-srg-staging"
    },
    "ds-staging" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-ds-staging"
    },
    "location-staging" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-location-staging"
    },
    "carrier-staging" = {     
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-carrier"
    },
    "distance-staging" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-distance-staging"
    },
    "isd-staging" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-isd-staging"
    },
    "sp-staging" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-sp-staging"
    },
    "tracking-portal-ui-staging" = {     
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-tracking-portal-ui-staging"
    },
    "trackingportalservice-staging" = {     
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-trackingportalservice-staging"
    },
    "web-smp-staging" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-smp-staging"
    },
    "se-staging" = {     
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-se-staging"
    },
    "sec-staging" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-sec-staging"
    },
    "parcel-ui-staging" =  { 
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-parcel-ui-staging"
    },
    "configuration-ui-staging" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-configuration-ui-staging"
    },
    "config-app-staging" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-config-app-staging"
    },
    "rating-maintenance-staging" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-ratingmaintenance-staging"
    },
    "alert-service-staging" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-alert-service-staging"
    },
    "notificationservice-staging" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-notificationservice-staging"
    },
    "configuration-ui-staging" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-configuration-ui-staging"
    },
    "sidekick-staging" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-sidekick-staging"
    },
    "op-job-scheduler-staging" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-op-job-scheduler-staging"
    },
    "rates-and-lanes-staging" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-rates-and-lanes-staging"
      timeout_sec           = 60
    },
    "optimizefacade-staging" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-optimizefacade-staging"
    },
    "optimizemediator-staging" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-optimizemediator-staging"
    },
    "parcelratingservice-staging" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-parcelratingservice"
    },
    "javajunction-staging" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-javajunction-staging"
    },
    "externalrates-staging" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-externalrates-staging"
    },
    "carrierauctionservice-staging" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-carrierauctionservice-staging"
    },
    "integrated-price-link-staging" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-integrated-price-link-staging"
    },
    "ltlcarrierapiservice-staging" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-ltlcarrierapiservice-staging"
    },
    "ratingsearch-staging" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-ratingsearch-staging"
    },
    "routing-service-staging" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-routing-service-staging"
    },
    "riskpulse-staging" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-riskpulse-staging"
    },
    "tracking-staging" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-tracking-staging"
    },
    "tenderservice-staging" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-tenderservice-staging"
    },
    "radeon-staging" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-radeon-staging"
    },
    "draco-es-client-staging" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-draco-es-client-staging"
    },
    "draco-es-client-svc-staging" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-draco-es-client-svc-staging"
    },
    "ect-ui-staging" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-ect-ui-staging"
    },
    "ect-ui-v2-staging" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-n/regions/us-south1/backendServices/rbs-ect-ui-v2"
    }
  }
}

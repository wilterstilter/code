inputs = {
  backends = {
    "tms-dev" = {
      neg_links             = [for zone, link in dependency.tms-dev.outputs.neg_self_link: link]
      health_check          = "tms-dev"
      timeout_sec            = 60
    },
    "ocp-dev" = {
      neg_links             = [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link]
      health_check          = "ocp-dev"
    },
    "alive-dev" = {     
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/neg-hello"
    },
    "nginx-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/neg-test-2"
    },
    "optimize-dev" = {
      neg_links             = [for zone, link in dependency.optimize-dev.outputs.neg_self_link: link]
      health_check          = "optimize-dev"
    },
    "optimizeengine-dev" = {
      neg_links             = [for zone, link in dependency.optimize-dev.outputs.neg_self_link: link]
      health_check          = "optimizeengine-dev"
    },
    "optimizerest-dev" = {
      neg_links             = [for zone, link in dependency.optimize-dev.outputs.neg_self_link: link]
      health_check          = "optimizerest-dev"
    },
    "correctaddress-dev" = {
      neg_links             = [for zone, link in dependency.correctaddress-dev.outputs.neg_self_link: link]
      health_check          = "correctaddress-dev"
    },
    "rating-dev" = {
      neg_links             = [for zone, link in dependency.rating-dev.outputs.neg_self_link: link]
      health_check          = "rating-dev"
    },
    "oca-dev" = {
      neg_links             = [for zone, link in dependency.oca-dev.outputs.neg_self_link: link]
      health_check          = "oca-dev"
    },
    "rmc-dev" = {
      neg_links             = [for zone, link in dependency.rmc-dev.outputs.neg_self_link: link]
      health_check          = "rmc-dev"
    },
    "dms-dev" = {
      neg_links             = [for zone, link in dependency.dms-dev.outputs.neg_self_link: link]
      health_check          = "dms-dev"
    },
    "cp-dev" = {
      neg_links             = [for zone, link in dependency.cp-dev.outputs.neg_self_link: link]
      health_check          = "cp-dev"
    },
    "smp-dev" = {
      neg_links             = [for zone, link in dependency.smp-dev.outputs.neg_self_link: link]
      health_check          = "smp-dev"
    },
    "ptms-dev" = {
      neg_links             = [for zone, link in dependency.ptms-dev.outputs.neg_self_link: link]
      health_check          = "ptms-dev"
    },
    "ratingmaintenance-dev" = {
      neg_links             = [for zone, link in dependency.rating-dev.outputs.neg_self_link: link]
      health_check          = "ratingmaintenance-dev"
    },
    "ratingengine-dev" = {
      neg_links             = [for zone, link in dependency.rating-dev.outputs.neg_self_link: link]
      health_check          = "ratingengine-dev"
    },
    "ratingexternal-dev" = {
      neg_links             = [for zone, link in dependency.rating-dev.outputs.neg_self_link: link]
      health_check          = "ratingexternal-dev"
    },
    "optimizeservice-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-optimize-service-dev"
      health_check          = "optimize-dev"
    },
    "mit-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-mit-dev"
      health_check          = "mit-dev"
    },
    "configserver-v2-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-configserver-v2-dev"
      health_check          = "gke-nginx" 
    },
    "yms-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-yms-dev"
    },
    "dcmservice-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-dcmservice-dev"
    },
    "security-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-security-dev"
      timeout_sec           = 300
    },
    "cms-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-cms-dev"
    },
    "sku-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-sku-dev"
    },
    "draco-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-draco-dev"
    },
    "mobile-api-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-mobile-api-dev"
    },
    "control-tower-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-control-tower-dev"
    },
    "drome-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-drome-dev"
    },
    "rateapproval-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-rateapproval-dev"
    },
    "location-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-location-dev"
    },
    "eventmediator-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-eventmediator-dev"
    },
    "tinyurlservice-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-tinyurlservice-dev"
    },
    "settings-backend-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-settings-backend-dev"
    },
    "settings-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-settings-dev"
    },
    "srg-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-srg-dev"
    },
    "ds-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-ds-dev"
    },
    "location-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-location-dev"
    },
    "auctions-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-auctions-dev"
    },
    "earbuds-dev" = {
     
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-earbuds-dev"
    },
    "carrier-dev" = {     
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-carrier"
    },
    "distance-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-distance-dev"
    },
    "isd-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-isd-dev"
    },
    "sp-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-sp-dev"
    },
    "tracking-portal-ui-dev" = {     
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-tracking-portal-ui-dev"
    },
    "web-smp-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-smp-dev"
    },
    "se-dev" = {     
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-se-dev"
    },
    "sec-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-sec-dev"
    },
    "parcel-ui-dev" =  { 
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-parcel-ui-dev"
    },
    "dcm-ui-dev" = {     
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-dcm-ui-dev"
    },
    "configuration-ui-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-configuration-ui-dev"
    },
    "tpangular-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-tp-angular-dev"
    },
    "orders-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-orders-dev"
    },
    "shipments-dev" = {     
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-shipments-dev"
    },
    "rating-maintenance-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-ratingmaintenance-dev"
    },
    "alert-service-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-alert-service-dev"
    },
    "notificationservice-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-notificationservice-dev"
    },
    "configuration-ui-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-configuration-ui-dev"
    },
    "sidekick-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-sidekick-dev"
    },
    "op-job-scheduler-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-op-job-scheduler-dev"
    },
    "checkcallkafkastreamapp-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-checkcallkafkastreamapp-dev"
    },
    "rates-and-lanes-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-rates-and-lanes-dev"
      timeout_sec           = 60
    },
    "dcmengine-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-dcmengine-dev"
    },
    "optimizefacade-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-optimizefacade-dev"
    },
    "optimizemediator-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-optimizemediator-dev"
    },
    "opconsumer-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-opconsumer-dev"
    },
    "opconsumer-cr-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-opconsumer-cr-dev"
    },
    "opconsumer-faq-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-opconsumer-faq-dev"
    },
    "opconsumer-nom-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-opconsumer-nom-dev"
    },
    "opconsumer-pop-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-opconsumer-pop-dev"
    },
    "parcelcarrierapiservice-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-parcelcarrierapiservice-dev"
    },
    "javajunction-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-javajunction-dev"
    },
    "externalrates-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-externalrates-dev"
    },
    "carrierauctionservice-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-carrierauctionservice-dev"
    },
    "integrated-price-link-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-integrated-price-link-dev"
    },
    "tp-kafka-connect-jdbc-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-tp-kafka-connect-jdbc-dev"
    },
    "documentai-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-documentai-dev"
    },
    "ratingsearch-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-ratingsearch-dev"
    },
    "routing-service-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-routing-service-dev"
    },
    "ratingregressionsuite-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-ratingregressionsuite-dev"
    },
    "riskpulse-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-riskpulse-dev"
    },
    "tracking-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-tracking-dev"
    },
    "monorepotracking-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-monorepotracking-dev"
    },
    "tenderservice-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-tenderservice-dev"
    },
    "radeon-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-radeon-dev"
    },
    "draco-es-client-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-draco-es-client-dev"
    },
    "ect-ui-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-ect-ui-dev"
    },
    "ect-ui-v2-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-ect-ui-v2"
    },
    "cp2-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-p/regions/us-south1/backendServices/rbs-cp-dev"
    },
  }
}

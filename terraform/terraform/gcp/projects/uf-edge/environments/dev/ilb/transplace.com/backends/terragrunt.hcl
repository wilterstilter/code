inputs = {
  backends = {
    "tms-test" = {
      neg_links             = [for zone, link in dependency.tms-test.outputs.neg_self_link: link]
      health_check          = "tms-test"
      timeout_sec           = 900
      security_policy       = dependency.cloud_armor.outputs.security_policy_self_link
    },
    "tmsservices-test" = {
      neg_links             = [for zone, link in dependency.tmsservices-test.outputs.neg_self_link: link]
      health_check          = "tms-test"
      timeout_sec           = 900
      security_policy       = dependency.cloud_armor.outputs.security_policy_self_link
    },
    "ocp-test" = {
      neg_links             = [for zone, link in dependency.ocp-test.outputs.neg_self_link: link]
      health_check          = "ocp-test"
    },
    "optimize-test" = {
      neg_links             = [for zone, link in dependency.optimize-test.outputs.neg_self_link: link]
      health_check          = "optimize-test"
      security_policy       = dependency.cloud_armor.outputs.security_policy_self_link    
    },
    "optimizeengine-test" = {
      neg_links             = [for zone, link in dependency.optimize-test.outputs.neg_self_link: link]
      health_check          = "optimizeengine-test"
    },
    "optimizerest-test" = {
      neg_links             = [for zone, link in dependency.optimize-test.outputs.neg_self_link: link]
      health_check          = "optimizerest-test"
    },
    "correctaddress-test" = {
      neg_links             = [for zone, link in dependency.correctaddress-test.outputs.neg_self_link: link]
      health_check          = "correctaddress-test"
    },
    "rating-test" = {
      neg_links             = [for zone, link in dependency.rating-test.outputs.neg_self_link: link]
      health_check          = "rating-test"
    },
    "oca-test" = {
      neg_links             = [for zone, link in dependency.oca-test.outputs.neg_self_link: link]
      health_check          = "oca-test"
      timeout_sec           = 300
    },
    "rmc-test" = {
      neg_links             = [for zone, link in dependency.rmceng19-test.outputs.neg_self_link: link]
      health_check          = "rmc-test"
      timeout_sec           = 300
    },
    "dms-test" = {
      neg_links             = [for zone, link in dependency.dms-test.outputs.neg_self_link: link]
      health_check          = "dms-test"
      timeout_sec            = 600
    },
    "smp-test" = {
      neg_links             = [for zone, link in dependency.smp-test.outputs.neg_self_link: link]
      health_check          = "smp-test"
      timeout_sec           = 600
    },
    "ptms-test" = {
      neg_links             = [for zone, link in dependency.ptms-test.outputs.neg_self_link: link]
      health_check          = "ptms-test"
    },
    "cp-test" = {
      neg_links             = [for zone, link in dependency.cp-test.outputs.neg_self_link: link]
      health_check          = "cp-test"
      security_policy       = dependency.cloud_armor.outputs.security_policy_self_link
      timeout_sec           = 600
    },
    "ratingmaintenance-test" = {
      neg_links             = [for zone, link in dependency.rating-test.outputs.neg_self_link: link]
      health_check          = "ratingmaintenance-test"
    },
    "ratingengine-test" = {
      neg_links             = [for zone, link in dependency.rating-test.outputs.neg_self_link: link]
      health_check          = "ratingengine-test"
    },
    "ratingexternal-test" = {
      neg_links             = [for zone, link in dependency.rating-test.outputs.neg_self_link: link]
      health_check          = "ratingexternal-test"
    },
    "optimizeservice-test" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-optimize-service-test"
      health_check          = "optimize-test"
    },
    "mit-test" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-mit-test"
      health_check          = "mit-test"
    },
    "configserver-v2-test" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-configserver-v2-test"
      health_check          = "gke-nginx" 
    },
    "yms-test" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-yms-test"
    },
    "carrier-portal-test" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-cp-test"
    },
    "security-test" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-security-test"
      timeout_sec            = 300
    },
    "cms-test" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-cms-test"
    },
    "sku-test" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-sku-test"
    },
    "draco-test" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-draco-test"
    },
    "mobile-api-test" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-mobile-api-test"
    },
    "control-tower-test" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-control-tower-test"
    },
    "drome-test" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-drome-test"
    },
     "drome-v2-test" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-drome-v2-test"
    },
    "rateapproval-test" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-rateapproval-test"
    },
    "location-test" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-location-test"
    },
    "locations-test" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-locations-test"
    },
    "tinyurlservice-test" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-tinyurlservice-test"
    },
    "settings-backend-test" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-settings-backend-test"
    },
    "settings-test" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-settings-test"
    },
    "srg-test" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-srg-test"
    },
    "ds-test" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ds-test"
    },
    "location-test" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-location-test"
    },
    "auctions-test" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-auctions-test"
    },
    "earbuds-test" = {
     
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-earbuds-test"
    },
    "carrier-test" = {     
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-carrier"
    },
    "distance-test" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-distance-test"
    },
    "isd-test" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-isd-test"
    },
    "sp-test" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-sp-test"
    },
    "tracking-portal-ui-test" = {     
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-tracking-portal-ui-test"
    },
    "trackingportalservice-test" = {     
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-trackingportalservice-test"
    },
    "web-smp-test" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-smp-test"
    },
    "se-test" = {     
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-se-test"
    },
    "sec-test" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-sec-test"
    },
    "parcel-ui-test" =  { 
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-parcel-ui-test"
    },
    "configuration-ui-test" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-configuration-ui-test"
    },
    "config-app-test" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-config-app-test"
    },
    "orders-test" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-orders-test"
    },
    "shipments-test" = {     
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-shipments-test"
    },
    "rating-maintenance-test" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ratingmaintenance-test"
    },
    "alert-service-test" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-alert-service-test"
    },
    "notificationservice-test" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-notificationservice-test"
    },
    "configuration-ui-test" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-configuration-ui-test"
    },
    "sidekick-test" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-sidekick-test"
    },
    "op-job-scheduler-test" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-op-job-scheduler-test"
    },
    "rates-and-lanes-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-rates-and-lanes-test"
      timeout_sec           = 60
    },
    "optimizefacade-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-optimizefacade-test"
    },
    "optimizemediator-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-optimizemediator-test"
    },
    "opconsumer-cr-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-opconsumer-cr-test"
    },
    "opconsumer-faq-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-opconsumer-faq-test"
    },
    "opconsumer-nom-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-opconsumer-nom-test"
    },
    "opconsumer-pop-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-opconsumer-pop-test"
    },
    "parcelcarrierapiservice-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-parcelcarrierapiservice-test"
    },
    "parcellogisticsservice-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-parcellogisticsservice-test"
    },
    "parcelratingservice-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-parcelratingservice"
    },
    "parcelserviceprovider-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-parcelserviceprovider-test"
    },
    "javajunction-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-javajunction-test"
    },
    "externalrates-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-externalrates-test"
    },
    "carrierauctionservice-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-carrierauctionservice-test"
    },
    "integrated-price-link-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-integrated-price-link-test"
    },
    "documentai-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-documentai-test"
    },
    "ltlcarrierapiservice-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ltlcarrierapiservice-test"
    },
    "ratingsearch-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ratingsearch-test"
    },
    "routing-service-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-routing-service-test"
    },
    "ratingregressionsuite-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ratingregressionsuite-test"
    },
    "riskpulse-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-riskpulse-test"
    },
    "tracking-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-tracking-test"
    },
    "monorepotracking-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-monorepotracking"
    },
    "tenderservice-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-tenderservice-test"
    },
    "radeon-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-radeon-test"
    },
    "draco-es-client-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-draco-es-client-test"
    },
    "draco-es-client-svc-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-draco-es-client-svc-test"
    },
    "ect-ui-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ect-ui-test"
    },
    "ect-ui-v2-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ect-ui-v2"
    },
    "ptms-cvs-adminapi-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ptms-cvs-adminapi-test"
    },
    "ptms-cvs-labelapi-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ptms-cvs-labelapi-test"
    },
    "ptms-cvs-manifestapi-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ptms-cvs-manifestapi-test"
    },
    "ptms-cvs-ratingapi-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ptms-cvs-ratingapi-test"
    },
    "ptms-cvs-ratingexternalapi-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ptms-cvs-ratingexternalapi-test"
    },
    "ptms-cvs-reportsapi-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ptms-cvs-reportsapi-test"
    },
    "ptms-cvs-shippingapi-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ptms-cvs-shippingapi-test"
    },
    "ptms-cvs-shippingexternalapi-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ptms-cvs-shippingexternalapi-test"
    },
    "ptms-cvs-trackingapi-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ptms-cvs-trackingapi-test"
    },
    "ptms-cvs-authapi-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ptms-cvs-authapi-test"
    },
     "ptms-cvs-inductionui-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ptms-cvs-inductionui-test"
    },
    "ptms-cvs-adminui-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ptms-cvs-adminui-test"
    },




    ##### DEV backends #### 
    "tms-dev" = {
      neg_links             = [for zone, link in dependency.tms-dev.outputs.neg_self_link: link]
      health_check          = "tms-dev"
      timeout_sec            = 60
    },
    "ocp-dev" = {
      neg_links             = [for zone, link in dependency.ocp-dev.outputs.neg_self_link: link]
      health_check          = "ocp-dev"
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
    "smp-dev" = {
      neg_links             = [for zone, link in dependency.smp-dev.outputs.neg_self_link: link]
      health_check          = "smp-dev"
    },
    "ptms-dev" = {
      neg_links             = [for zone, link in dependency.ptms-dev.outputs.neg_self_link: link]
      health_check          = "ptms-dev"
    },
    "cp-dev" = {
      neg_links             = [for zone, link in dependency.cp-dev.outputs.neg_self_link: link]
      health_check          = "cp-dev"
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
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-optimize-service-dev"
      health_check          = "optimize-dev"
    },
    "mit-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-mit-dev"
      health_check          = "mit-dev"
    },
    "configserver-v2-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-configserver-v2-dev"
      health_check          = "gke-nginx" 
    },
    "yms-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-yms-dev"
    },
    "dcmservice-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-dcmservice-dev"
    },
    "security-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-security-dev"
      timeout_sec           = 300
    },
    "cms-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-cms-dev"
    },
    "sku-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-sku-dev"
    },
    "draco-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-draco-dev"
    },
    "mobile-api-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-mobile-api-dev"
    },
    "control-tower-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-control-tower-dev"
    },
    "drome-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-drome-dev"
    },
    "rateapproval-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-rateapproval-dev"
    },
    "location-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-location-dev"
    },
    "tinyurlservice-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-tinyurlservice-dev"
    },
    "settings-backend-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-settings-backend-dev"
    },
    "settings-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-settings-dev"
    },
    "srg-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-srg-dev"
    },
    "ds-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ds-dev"
    },
    "location-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-location-dev"
    },
    "auctions-dev" = {    
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-auctions-dev"
    },
    "earbuds-dev" = {
     
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-earbuds-dev"
    },
    "carrier-dev" = {     
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-carrier"
    },
    "distance-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-distance-dev"
    },
    "isd-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-isd-dev"
    },
    "sp-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-sp-dev"
    },
    "tracking-portal-ui-dev" = {     
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-tracking-portal-ui-dev"
    },
    "web-smp-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-smp-dev"
    },
    "se-dev" = {     
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-se-dev"
    },
    "sec-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-sec-dev"
    },
    "parcel-ui-dev" =  { 
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-parcel-ui-dev"
    },
    "dcm-ui-dev" = {     
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-dcm-ui-dev"
    },
    "configuration-ui-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-configuration-ui-dev"
    },
    "tpangular-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-tp-angular-dev"
    },
    "orders-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-orders-dev"
    },
    "shipments-dev" = {     
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-shipments-dev"
    },
    "rating-maintenance-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ratingmaintenance-dev"
    },
    "alert-service-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-alert-service-dev"
    },
    "notificationservice-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-notificationservice-dev"
    },
    "configuration-ui-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-configuration-ui-dev"
    },
    "sidekick-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-sidekick-dev"
    },
    "op-job-scheduler-dev" = {      
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-op-job-scheduler-dev"
    },
    "rates-and-lanes-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-rates-and-lanes-dev"
      timeout_sec           = 60
    },
    "dcmengine-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-dcmengine-dev"
    },
    "optimizefacade-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-optimizefacade-dev"
    },
    "optimizemediator-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-optimizemediator-dev"
    },
    "opconsumer-cr-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-opconsumer-cr-dev"
    },
    "opconsumer-faq-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-opconsumer-faq-dev"
    },
    "opconsumer-nom-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-opconsumer-nom-dev"
    },
    "opconsumer-pop-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-opconsumer-pop-dev"
    },
    "parcelcarrierapiservice-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-parcelcarrierapiservice-dev"
    },
    "javajunction-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-javajunction-dev"
    },
    "externalrates-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-externalrates-dev"
    },
    "carrierauctionservice-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-carrierauctionservice-dev"
    },
    "integrated-price-link-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-integrated-price-link-dev"
    },
    "tp-kafka-connect-jdbc-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-tp-kafka-connect-jdbc-dev"
    },
    "documentai-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-documentai-dev"
    },
    "ratingsearch-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ratingsearch-dev"
    },
    "routing-service-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-routing-service-dev"
    },
    "ratingregressionsuite-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ratingregressionsuite-dev"
    },
    "riskpulse-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-riskpulse-dev"
    },
    "tracking-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-tracking-dev"
    },
    "monorepotracking-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-monorepotracking-dev"
    },
    "tenderservice-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-tenderservice-dev"
    },
    "radeon-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-radeon-dev"
    },
    "draco-es-client-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-draco-es-client-dev"
    },
    "ect-ui-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ect-ui-dev"
    },
    "ect-ui-v2-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ect-ui-v2"
    },
    "awx-gke-dev" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-awx-gke-dev"
    },
    "ast-grafana-test" = {
      cross_project_backend = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/regions/us-south1/backendServices/rbs-ast-grafana-test"
    },
  }
}

inputs = {
  port                  = 443
  enable_host_rewrite   = true
  enable_https_redirects = true
  ip_address            = "10.255.252.251"
  default_backend       = "tms-dev"
  url_map = [
    {
      path        = "/tms/"
      backend     = "tms-dev"
      host_rewrite = true
      priority    = 100
    },
    {
      path        = "/yms/"
      backend     = "yms-dev"
      host_rewrite = true
      priority    = 110
    },
    {
      path        = "/tracking/"
      backend     = "tracking-dev"
      host_rewrite = true
      priority    = 120
    },
    {
      path        = "/security/"
      backend     = "security-dev"
      host_rewrite = true
      priority    = 130
    },
    {
      path        = "/nginx/"
      backend     = "nginx-dev"
      host_rewrite = true
      priority    = 140
    },
    {
      path        = "/optimizeengine/"
      backend     = "optimizeengine-dev"
      host_rewrite = true
      priority    = 150
    },
    {
      path        = "/sptresult/"
      backend     = "tms-dev"
      host_rewrite = true
      priority    = 160
    },
    {
      path        = "/optimizerest/"
      backend     = "optimizerest-dev"
      host_rewrite = true
      priority    = 170
    },
    {
      path        = "/correctaddress/"
      backend     = "correctaddress-dev"
      host_rewrite = true
      priority    = 180
    },
    {
      path        = "/ratingmaintenance/"
      backend     = "ratingmaintenance-dev"
      host_rewrite = true
      priority    = 190
    },
    {
      path        = "/oca/"
      backend     = "oca-dev"
      host_rewrite = true
      priority    = 200
    },
    {
      path        = "/ratingengine/"
      backend     = "ratingengine-dev"
      host_rewrite = true
      priority    = 210
    },
    {
      path        = "/rmcengine19/"
      backend     = "rmc-dev"
      host_rewrite = true
      priority    = 220
    },
    {
      path        = "/dms/"
      backend     = "dms-dev"
      host_rewrite = true
      priority    = 230
    },
    {
      path        = "/smp/"
      backend     = "smp-dev"
      host_rewrite = true
      priority    = 240
    },
    {
      path        = "/alert-service/"
      backend     = "alert-service-dev"
      host_rewrite = true
      priority    = 250
    },
    {
      path        = "/notification/"
      backend     = "notificationservice-dev"
      host_rewrite = true
      priority    = 260
    },
    {
      path        = "/check-call-stream-api/"
      backend     = "checkcallkafkastreamapp-dev"
      host_rewrite = true
      priority    = 270
    },
    {
      path        = "/rating-service/"
      backend     = "ocp-dev"
      host_rewrite = true
      priority    = 280
    },
    {
      path        = "/rates-and-lanes/"
      backend     = "rates-and-lanes-dev"
      host_rewrite = true
      priority    = 290
    },
    {
      path        = "/parcel/"
      backend     = "parcel-ui-dev"
      host_rewrite = true
      priority    = 300
    },
    {
      path        = "/dcm-service/"
      backend     = "dcmservice-dev"
      host_rewrite = true
      priority    = 310
    },
    {
      path        = "/dcm/"
      backend     = "dcmengine-dev"
      host_rewrite = true
      priority    = 320
    },
    {
      path        = "/rating/maintenance/"
      backend     = "rating-maintenance-dev"
      host_rewrite = true
      priority    = 330
    },
    {
      path        = "/mit/"
      backend     = "mit-dev"
      host_rewrite = true
      priority    = 340
    },
    {
      path        = "/ltlcarrierapiservice/"
      backend     = "ocp-dev"
      host_rewrite = true
      priority    = 350
    },
    {
      path        = "/op-job-scheduler/"
      backend     = "op-job-scheduler-dev"
      host_rewrite = true
      priority    = 360
    },
    {
      path        = "/optimize-service/"
      backend     = "optimizeservice-dev"
      host_rewrite = true
      priority    = 370
    },
    {
      path        = "/optimizefacade/"
      backend     = "optimizefacade-dev"
      host_rewrite = true
      priority    = 380
    },
    {
      path        = "/optimizemediator/"
      backend     = "optimizemediator-dev"
      host_rewrite = true
      priority    = 390
    },
    {
      path        = "/op-consumer/"
      backend     = "opconsumer-dev"
      host_rewrite = true
      priority    = 400
    },
    {
      path        = "/opconsumer-cr/"
      backend     = "opconsumer-cr-dev"
      host_rewrite = true
      priority    = 410
    },
    {
      path        = "/opconsumer-faq/"
      backend     = "opconsumer-faq-dev"
      host_rewrite = true
      priority    = 420
    },
    {
      path        = "/opconsumer-nom/"
      backend     = "opconsumer-nom-dev"
      host_rewrite = true
      priority    = 430
    },
    {
      path        = "/opconsumer-pop/"
      backend     = "opconsumer-pop-dev"
      host_rewrite = true
      priority    = 440
    },
    {
      path        = "/parcel-carrier-api-service/"
      backend     = "parcelcarrierapiservice-dev"
      host_rewrite = true
      priority    = 450
    },
    {
      path        = "/junction/"
      backend     = "javajunction-dev"
      host_rewrite = true
      priority    = 460
    },
    {
      path        = "/spring-config/"
      backend     = "configserver-v2-dev"
      host_rewrite = true
      priority    = 470
    },
    {
      path        = "/spring-config-v2/"
      backend     = "configserver-v2-dev"
      host_rewrite = true
      priority    = 480
    },
    {
      path        = "/externalrates/"
      backend     = "externalrates-dev"
      host_rewrite = true
      priority    = 490
    },
    {
      path        = "/carrier-auction-service/"
      backend     = "carrierauctionservice-dev"
      host_rewrite = true
      priority    = 500
    },
    {
      path        = "/ipl/"
      backend     = "integrated-price-link-dev"
      host_rewrite = true
      priority    = 510
    },
    {
      path        = "/tp-kafka-connect-jdbc/"
      backend     = "tp-kafka-connect-jdbc-dev"
      host_rewrite = true
      priority    = 520
    },
    {
      path        = "/ops/"
      backend     = "documentai-dev"
      host_rewrite = true
      priority    = 530
    },
    {
      path        = "/ratingsearch/"
      backend     = "ratingsearch-dev"
      host_rewrite = true
      priority    = 540
    },
    {
      path        = "/routing-service/"
      backend     = "routing-service-dev"
      host_rewrite = true
      priority    = 550
    },
    {
      path        = "/rating-regression/"
      backend     = "ratingregressionsuite-dev"
      host_rewrite = true
      priority    = 560
    },
    {
      path        = "/riskpulse/"
      backend     = "riskpulse-dev"
      host_rewrite = true
      priority    = 570
    },
    {
      path        = "/tracking/"
      backend     = "tracking-dev"
      host_rewrite = true
      priority    = 580
    },
    {
      path        = "/tenderservice/"
      backend     = "tenderservice-dev"
      host_rewrite = true
      priority    = 590
    },
    {
      path        = "/radeon/"
      backend     = "radeon-dev"
      host_rewrite = true
      priority    = 600
    },
    {
      path        = "/sidekick/"
      backend     = "sidekick-dev"
      host_rewrite = true
      priority    = 610
    },
  ]
}
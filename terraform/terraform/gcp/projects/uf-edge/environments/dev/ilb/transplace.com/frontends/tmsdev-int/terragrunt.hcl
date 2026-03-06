inputs = {
  port                  = 80
  ip_address            = "10.227.10.23"
  default_backend       = "tms-dev"
  url_map = [
    {
      path        = "/tms/"
      backend     = "tms-dev"
      priority    = 100
    },
    {
      path        = "/yms/"
      backend     = "yms-dev"
      priority    = 110
    },
    {
      path        = "/tracking/"
      backend     = "tracking-dev"
      priority    = 120
    },
    {
      path        = "/security/"
      backend     = "security-dev"
      priority    = 130
    },
    {
      path        = "/optimizeengine/"
      backend     = "optimizeengine-dev"
      priority    = 150
    },
    {
      path        = "/sptresult/"
      backend     = "tms-dev"
      priority    = 160
    },
    {
      path        = "/optimizerest/"
      backend     = "optimizerest-dev"
      priority    = 170
    },
    {
      path        = "/correctaddress/"
      backend     = "correctaddress-dev"
      priority    = 180
    },
    {
      path        = "/ratingmaintenance/"
      backend     = "ratingmaintenance-dev"
      priority    = 190
    },
    {
      path        = "/oca/"
      backend     = "oca-dev"
      priority    = 200
    },
    {
      path        = "/ratingengine/"
      backend     = "ratingengine-dev"
      priority    = 210
    },
    {
      path        = "/rmcengine19/"
      backend     = "rmc-dev"
      priority    = 220
    },
    {
      path        = "/dms/"
      backend     = "dms-dev"
      priority    = 230
    },
    {
      path        = "/smp/"
      backend     = "smp-dev"
      priority    = 240
    },
    {
      path        = "/alert-service/"
      backend     = "alert-service-dev"
      priority    = 250
    },
    {
      path        = "/notification/"
      backend     = "notificationservice-dev"
      priority    = 260
    },
    {
      path        = "/rating-service/"
      backend     = "rating-dev"
      priority    = 280
    },
    {
      path        = "/rates-and-lanes/"
      backend     = "rates-and-lanes-dev"
      priority    = 290
    },
    {
      path        = "/parcel/"
      backend     = "parcel-ui-dev"
      priority    = 300
    },
    {
      path        = "/dcm/dcm-service/"
      backend     = "dcmservice-dev"
      priority    = 310
    },
    {
      path        = "/dcm/dcm-engine/"
      backend     = "dcmengine-dev"
      priority    = 320
    },
    {
      path        = "/rating/maintenance/"
      backend     = "rating-maintenance-dev"
      priority    = 330
    },
    {
      path        = "/mit/"
      backend     = "mit-dev"
      priority    = 340
    },
    {
      path        = "/ltlcarrierapiservice/"
      backend     = "ocp-dev"
      priority    = 350
    },
    {
      path        = "/op-job-scheduler/"
      backend     = "op-job-scheduler-dev"
      priority    = 360
    },
    {
      path        = "/optimize-service/"
      backend     = "optimizeservice-dev"
      priority    = 370
    },
    {
      path        = "/optimizefacade/"
      backend     = "optimizefacade-dev"
      priority    = 380
    },
    {
      path        = "/optimizemediator/"
      backend     = "optimizemediator-dev"
      priority    = 390
    },
    {
      path        = "/opconsumer-cr/"
      backend     = "opconsumer-cr-dev"
      priority    = 410
    },
    {
      path        = "/opconsumer-faq/"
      backend     = "opconsumer-faq-dev"
      priority    = 420
    },
    {
      path        = "/opconsumer-nom/"
      backend     = "opconsumer-nom-dev"
      priority    = 430
    },
    {
      path        = "/opconsumer-pop/"
      backend     = "opconsumer-pop-dev"
      priority    = 440
    },
    {
      path        = "/parcel-carrier-api-service/"
      backend     = "parcelcarrierapiservice-dev"
      priority    = 450
    },
    {
      path        = "/junction/"
      backend     = "javajunction-dev"
      priority    = 460
    },
    {
      path        = "/spring-config/"
      backend     = "configserver-v2-dev"
      priority    = 470
    },
    {
      path        = "/spring-config-v2/"
      backend     = "configserver-v2-dev"
      priority    = 480
    },
    {
      path        = "/externalrates/"
      backend     = "externalrates-dev"
      priority    = 490
    },
    {
      path        = "/carrier-auction-service/"
      backend     = "carrierauctionservice-dev"
      priority    = 500
    },
    {
      path        = "/ipl/"
      backend     = "integrated-price-link-dev"
      priority    = 510
    },
    {
      path        = "/tp-kafka-connect-jdbc/"
      backend     = "tp-kafka-connect-jdbc-dev"
      priority    = 520
    },
    {
      path        = "/ops/"
      backend     = "documentai-dev"
      priority    = 530
    },
    {
      path        = "/ratingsearch/"
      backend     = "ratingsearch-dev"
      priority    = 540
    },
    {
      path        = "/routing-service/"
      backend     = "routing-service-dev"
      priority    = 550
    },
    {
      path        = "/rating-regression/"
      backend     = "ratingregressionsuite-dev"
      priority    = 560
    },
    {
      path        = "/riskpulse/"
      backend     = "riskpulse-dev"
      priority    = 570
    },
    {
      path        = "/tracking/"
      backend     = "tracking-dev"
      priority    = 580
    },
    {
      path        = "/tenderservice/"
      backend     = "tenderservice-dev"
      priority    = 590
    },
    {
      path        = "/radeon/"
      backend     = "radeon-dev"
      priority    = 600
    },
    {
      path        = "/sidekick/"
      backend     = "sidekick-dev"
      priority    = 610
    },
  ]
}
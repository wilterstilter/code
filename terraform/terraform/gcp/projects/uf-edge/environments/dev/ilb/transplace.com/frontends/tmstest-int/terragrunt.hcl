inputs = {
  port                  = 80
  ip_address            = "10.227.10.14"
  default_backend       = "tms-test"
  url_map = [
    {
      path        = "/tms/"
      backend     = "tms-test"
      priority    = 100
    },
    {
      path        = "/arg/route/"
      backend     = "tms-test"
      priority    = 101
    },
    {
      path        = "/yms/"
      backend     = "yms-test"
      priority    = 110
    },
    {
      path        = "/tracking/"
      backend     = "tracking-test"
      priority    = 120
    },
    {
      path        = "/security/"
      backend     = "security-test"
      priority    = 130
    },
    {
      path        = "/optimizeengine/"
      backend     = "optimizeengine-test"
      priority    = 150
    },
    {
      path        = "/sptresult/"
      backend     = "tms-test"
      priority    = 160
    },
    {
      path        = "/optimizerest/"
      backend     = "optimizerest-test"
      priority    = 170
    },
    {
      path        = "/correctaddress/"
      backend     = "correctaddress-test"
      priority    = 180
    },
    {
      path        = "/ratingmaintenance/"
      backend     = "ratingmaintenance-test"
      priority    = 190
    },
    {
      path        = "/oca/"
      backend     = "oca-test"
      priority    = 200
    },
    {
      path        = "/ratingengine/"
      backend     = "ratingengine-test"
      priority    = 210
    },
    {
      path        = "/rmcengine19/"
      backend     = "rmc-test"
      priority    = 220
    },
    {
      path        = "/dms/"
      backend     = "dms-test"
      priority    = 230
    },
    {
      path        = "/smp/"
      backend     = "smp-test"
      priority    = 240
    },
    {
      path        = "/alert-service/"
      backend     = "alert-service-test"
      priority    = 250
    },
    {
      path        = "/notification/"
      backend     = "notificationservice-test"
      priority    = 260
    },
    {
      path        = "/rating-service/"
      backend     = "parcelratingservice-test"
      priority    = 280
    },
    {
      path        = "/parcel/service-provider/"
      backend     = "parcelserviceprovider-test"
      priority    = 285
    },
    {
      path        = "/rates-and-lanes/"
      backend     = "rates-and-lanes-test"
      priority    = 290
    },
    {
      path        = "/web/parcel-ui/"
      backend     = "parcel-ui-test"
      priority    = 300
    },
    {
      path        = "/rating/maintenance/"
      backend     = "rating-maintenance-test"
      priority    = 330
    },
    {
      path        = "/mit/"
      backend     = "mit-test"
      priority    = 340
    },
    {
      path        = "/ltlcarrierapiservice/"
      backend     = "ltlcarrierapiservice-test"
      priority    = 350
    },
    {
      path        = "/op-job-scheduler/"
      backend     = "op-job-scheduler-test"
      priority    = 360
    },
    {
      path        = "/optimize-service/"
      backend     = "optimizeservice-test"
      priority    = 370
    },
    {
      path        = "/optimizefacade/"
      backend     = "optimizefacade-test"
      priority    = 380
    },
    {
      path        = "/optimizemediator/"
      backend     = "optimizemediator-test"
      priority    = 390
    },
    {
      path        = "/opconsumer-cr/"
      backend     = "opconsumer-cr-test"
      priority    = 410
    },
    {
      path        = "/opconsumer-faq/"
      backend     = "opconsumer-faq-test"
      priority    = 420
    },
    {
      path        = "/opconsumer-nom/"
      backend     = "opconsumer-nom-test"
      priority    = 430
    },
    {
      path        = "/opconsumer-pop/"
      backend     = "opconsumer-pop-test"
      priority    = 440
    },
    {
      path        = "/parcel-carrier-api-service/"
      backend     = "parcelcarrierapiservice-test"
      priority    = 450
    },
    {
      path        = "/parcel/logistics-service/"
      backend     = "parcellogisticsservice-test"
      priority    = 455
    },
    {
      path        = "/junction/"
      backend     = "javajunction-test"
      priority    = 460
    },
    {
      path        = "/spring-config-v2/"
      backend     = "configserver-v2-test"
      priority    = 480
    },
    {
      path        = "/externalrates/"
      backend     = "externalrates-test"
      priority    = 490
    },
    {
      path        = "/carrier-auction-service/"
      backend     = "carrierauctionservice-test"
      priority    = 500
    },
    {
      path        = "/ipl/"
      backend     = "integrated-price-link-test"
      priority    = 510
    },
    {
      path        = "/ops/"
      backend     = "documentai-test"
      priority    = 530
    },
    {
      path        = "/ratingsearch/"
      backend     = "ratingsearch-test"
      priority    = 540
    },
    {
      path        = "/routing-service/"
      backend     = "routing-service-test"
      priority    = 550
    },
    {
      path        = "/rating-regression/"
      backend     = "ratingregressionsuite-test"
      priority    = 560
    },
    {
      path        = "/riskpulse/"
      backend     = "riskpulse-test"
      priority    = 570
    },
    {
      path        = "/tracking/"
      backend     = "tracking-test"
      priority    = 580
    },
    {
      path        = "/tenderservice/"
      backend     = "tenderservice-test"
      priority    = 590
    },
    {
      path        = "/radeon/"
      backend     = "radeon-test"
      priority    = 600
    },
    {
      path        = "/sidekick/"
      backend     = "sidekick-test"
      priority    = 610
    },
    {
      path        = "/api/admin/"
      backend     = "ptms-cvs-adminapi-test"
      priority    = 620
    },
    {
      path        = "/api/label/"
      backend     = "ptms-cvs-labelapi-test"
      priority    = 630
    },
    {
      path        = "/api/manifest/"
      backend     = "ptms-cvs-manifestapi-test"
      priority    = 640
    },
    {
      path        = "/api/rating/"
      backend     = "ptms-cvs-ratingapi-test"
      priority    = 650
    },
    {
      path        = "/api/ptmsratingexternal/"
      backend     = "ptms-cvs-ratingexternalapi-test"
      priority    = 655
    },
    {
      path        = "/api/reports/"
      backend     = "ptms-cvs-reportsapi-test"
      priority    = 660
    },
    {
      path        = "/api/shipping/"
      backend     = "ptms-cvs-shippingapi-test"
      priority    = 670
    },
    {
      path        = "/api/shippingexternal/"
      backend     = "ptms-cvs-shippingexternalapi-test"
      priority    = 680
    },
    {
      path        = "/api/tracking/"
      backend     = "ptms-cvs-trackingapi-test"
      priority    = 690
    },
  ]
}

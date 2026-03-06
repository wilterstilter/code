inputs = {
  port                  = 80
  ip_address            = "10.223.10.14"
  default_backend       = "tms-staging"
  url_map = [
    {
      path        = "/tms/"
      backend     = "tms-staging"
      priority    = 100
    },
    {
      path        = "/arg/route/"
      backend     = "tms-staging"
      priority    = 101
    },
    {
      path        = "/yms/"
      backend     = "yms-staging"
      priority    = 110
    },
    {
      path        = "/tracking/"
      backend     = "tracking-staging"
      priority    = 120
    },
    {
      path        = "/security/"
      backend     = "security-staging"
      priority    = 130
    },
    {
      path        = "/optimizeengine/"
      backend     = "optimizeengine-staging"
      priority    = 150
    },
    {
      path        = "/sptresult/"
      backend     = "tms-staging"
      priority    = 160
    },
    {
      path        = "/optimizerest/"
      backend     = "optimizerest-staging"
      priority    = 170
    },
    {
      path        = "/correctaddress/"
      backend     = "correctaddress-staging"
      priority    = 180
    },
    {
      path        = "/ratingmaintenance/"
      backend     = "ratingmaintenance-staging"
      priority    = 190
    },
    {
      path        = "/oca/"
      backend     = "oca-staging"
      priority    = 200
    },
    {
      path        = "/ratingengine/"
      backend     = "ratingengine-staging"
      priority    = 210
    },
    {
      path        = "/rmcengine19/"
      backend     = "rmc-staging"
      priority    = 220
    },
    {
      path        = "/dms/"
      backend     = "dms-staging"
      priority    = 230
    },
    {
      path        = "/smp/"
      backend     = "smp-staging"
      priority    = 240
    },
    {
      path        = "/alert-service/"
      backend     = "alert-service-staging"
      priority    = 250
    },
    {
      path        = "/notification/"
      backend     = "notificationservice-staging"
      priority    = 260
    },
    {
      path        = "/rating-service/"
      backend     = "parcelratingservice-staging"
      priority    = 280
    },
    {
      path        = "/rates-and-lanes/"
      backend     = "rates-and-lanes-staging"
      priority    = 290
    },
    {
      path        = "/web/parcel-ui/"
      backend     = "parcel-ui-staging"
      priority    = 300
    },
    {
      path        = "/rating/maintenance/"
      backend     = "rating-maintenance-staging"
      priority    = 330
    },
    {
      path        = "/mit/"
      backend     = "mit-staging"
      priority    = 340
    },
    {
      path        = "/ltlcarrierapiservice/"
      backend     = "ltlcarrierapiservice-staging"
      priority    = 350
    },
    {
      path        = "/op-job-scheduler/"
      backend     = "op-job-scheduler-staging"
      priority    = 360
    },
    {
      path        = "/optimize-service/"
      backend     = "optimizeservice-staging"
      priority    = 370
    },
    {
      path        = "/optimizefacade/"
      backend     = "optimizefacade-staging"
      priority    = 380
    },
    {
      path        = "/optimizemediator/"
      backend     = "optimizemediator-staging"
      priority    = 390
    },
    {
      path        = "/junction/"
      backend     = "javajunction-staging"
      priority    = 460
    },
    {
      path        = "/spring-config-v2/"
      backend     = "configserver-v2-staging"
      priority    = 480
    },
    {
      path        = "/externalrates/"
      backend     = "externalrates-staging"
      priority    = 490
    },
    {
      path        = "/carrier-auction-service/"
      backend     = "carrierauctionservice-staging"
      priority    = 500
    },
    {
      path        = "/ipl/"
      backend     = "integrated-price-link-staging"
      priority    = 510
    },
    {
      path        = "/ratingsearch/"
      backend     = "ratingsearch-staging"
      priority    = 540
    },
    {
      path        = "/routing-service/"
      backend     = "routing-service-staging"
      priority    = 550
    },
    {
      path        = "/riskpulse/"
      backend     = "riskpulse-staging"
      priority    = 570
    },
    {
      path        = "/tracking/"
      backend     = "tracking-staging"
      priority    = 580
    },
    {
      path        = "/tenderservice/"
      backend     = "tenderservice-staging"
      priority    = 590
    },
    {
      path        = "/radeon/"
      backend     = "radeon-staging"
      priority    = 600
    },
    {
      path        = "/sidekick/"
      backend     = "sidekick-staging"
      priority    = 610
    }
  ]
}

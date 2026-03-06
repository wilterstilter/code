inputs = {
  port                  = 443
  enable_https_redirects = true
  ip_address            = "10.227.10.15"
  default_backend       = "tms-test"
  url_map = [
    {
      path        = "/tms/"
      backend     = "tms-test"
      host_rewrite = true
      priority    = 100
    },
    {
      path        = "/cp/"
      backend     = "cp-test"
      host_rewrite = true
      priority    = 110
    },
    {
      path        = "/cp2/"
      backend     = "carrier-portal-test"
      host_rewrite = true
      priority    = 112
    },
    {
      path        = "/ptms/"
      backend     = "ptms-test"
      host_rewrite = true
      priority    = 120
    },
    {
      path        = "/yms/"
      backend     = "yms-test"
      priority    = 130
    },
    {
      path        = "/tracking/"
      backend     = "trackingportalservice-test"
      host_rewrite = true
      priority    = 140
    },
    {
      path        = "/security/"
      backend     = "security-test"
      host_rewrite = true
      priority    = 150
    },
    {
      path        = "/cms/"
      backend     = "cms-test"
      host_rewrite = true
      priority    = 160
    },
    {
      path        = "/sku/"
      backend     = "sku-test"
      host_rewrite = true
      priority    = 170
    },
    {
      path        = "/draco/"
      backend     = "draco-test"
      host_rewrite = true
      priority    = 180
    },
    {
      path        = "/mobile-access/"
      backend     = "mobile-api-test"
      priority    = 190
    },
    {
      path        = "/ct/"
      backend     = "control-tower-test"
      host_rewrite = true
      priority    = 200
    },
    {
      path        = "/drome/"
      backend     = "drome-test"
      host_rewrite = true
      priority    = 210
    },
    {
      path        = "/rateapproval/"
      backend     = "rateapproval-test"
      host_rewrite = true
      priority    = 220
    },
    {
      path        = "/location-web/"
      backend     = "location-test"
      host_rewrite = true
      priority    = 230
    },
    {
      path        = "/io/"
      backend     = "tinyurlservice-test"
      host_rewrite = true
      priority    = 250
    },
    {
      path        = "/settings/"
      backend     = "settings-backend-test"
      priority    = 260
    },
    {
      path        = "/web/settings/"
      backend     = "settings-test"
      priority    = 270
    },
    {
      path        = "/web/srg/"
      backend     = "srg-test"
      priority    = 280
    },
    {
      path        = "/web/ds/"
      backend     = "ds-test"
      host_rewrite = true
      priority    = 290
    },
    {
      path        = "/web/locations/"
      backend     = "locations-test"
      priority    = 300
    },
    {
      path        = "/web/tracking/"
      backend     = "monorepotracking-test"
      priority    = 310
    },
    {
      path        = "/web/auctions/"
      backend     = "auctions-test"
      priority    = 320
    },
    {
      path        = "/web/earbuds-docs/"
      backend     = "earbuds-test"
      priority    = 330
    },
    {
      path        = "/web/carrier/"
      backend     = "carrier-test"
      priority    = 340
    },
    {
      path        = "/web/distance/"
      backend     = "distance-test"
      priority    = 350
    },
    {
      path        = "/web/isd/"
      backend     = "isd-test"
      priority    = 360
    },
    {
      path        = "/web/sp/"
      backend     = "sp-test"
      priority    = 370
    },
    {
      path        = "/web/tracking-portal-ui/"
      backend     = "tracking-portal-ui-test"
      priority    = 380
    },
    {
      path        = "/web/se/smp/"
      backend     = "web-smp-test"
      priority    = 390
    },
    {
      path        = "/web/se/"
      backend     = "se-test"
      priority    = 400
    },
    {
      path        = "/web/sec/"
      backend     = "sec-test"
      priority    = 410
    },
    {
      path        = "/web/parcel-ui/"
      backend     = "parcel-ui-test"
      priority    = 420
    },
    {
      path        = "/web/ect-ui/v2"
      backend     = "ect-ui-v2-test"
      priority    = 440
    },
    {
      path        = "/web/ect-ui"
      backend     = "ect-ui-test"
      priority    = 450
    },
    {
      path        = "/web/configuration-ui/"
      backend     = "configuration-ui-test"
      priority    = 460
    },
    {
      path        = "/web/orders/"
      backend     = "orders-test"
      priority    = 480
    },
    {
      path        = "/web/shipments/"
      backend     = "shipments-test"
      priority    = 490
    },
    {
      path        = "/ratingmaintenance/"
      backend     = "ratingmaintenance-test"
      host_rewrite = true
      priority    = 500
    },
    {
      path        = "/ratingexternal/"
      backend     = "ratingexternal-test"
      host_rewrite = true
      priority    = 510
    },
    {
      path        = "/dms/"
      backend     = "dms-test"
      host_rewrite = true
      priority    = 520
    },
    {
      path        = "/smp/"
      backend     = "smp-test"
      host_rewrite = true
      priority    = 530
    },
    {
      path        = "/alert-service/"
      backend     = "alert-service-test"
      host_rewrite = true
      priority    = 540
    },
    {
      path        = "/notification/"
      backend     = "notificationservice-test"
      priority    = 550
    },
    {
      path        = "/configuration/"
      backend     = "config-app-test"
      priority    = 560
    },
    {
      path        = "/sidekick/"
      backend     = "sidekick-test"
      host_rewrite = true
      priority    = 570
    },
    {
      path        = "/draco-esclient-svc/"
      backend     = "draco-es-client-svc-test"
      host_rewrite = true
      priority    = 580
    },
  ]
  forbidden_uris = [
    {
      path_pattern = "/tms/UpdateServlet"
      priority     = 10
      status_code  = 403
      message      = "Access Forbidden"
    },
    {
      path_pattern = "/security/UpdateServlet"
      priority     = 15
      status_code  = 403
      message      = "Access Forbidden"
    },
    {
      path_pattern = "/cms/UpdateServlet"
      priority     = 20
      status_code  = 403
      message      = "Access Forbidden"
    },
    {
      path_pattern = "/sku/UpdateServlet"
      priority     = 25
      status_code  = 403
      message      = "Access Forbidden"
    }
  ]
}

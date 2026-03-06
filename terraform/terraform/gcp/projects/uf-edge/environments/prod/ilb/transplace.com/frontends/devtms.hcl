inputs = {
  port                  = 443
  enable_host_rewrite   = true
  enable_https_redirects = true
  ip_address            = "10.247.10.15"
  default_backend       = "tms-dev"
  url_map = [
    {
      path        = "/tms/"
      backend     = "tms-dev"
      host_rewrite = true
      priority    = 100
    },
    {
      path        = "/cp/"
      backend     = "cp-dev"
      host_rewrite = true
      priority    = 110
    },
    {
      path        = "/ptms/"
      backend     = "ptms-dev"
      host_rewrite = true
      priority    = 120
    },
    {
      path        = "/yms/"
      backend     = "yms-dev"
      priority    = 130
    },
    {
      path        = "/tracking/"
      backend     = "tracking-dev"
      host_rewrite = true
      priority    = 140
    },
    {
      path        = "/security/"
      backend     = "security-dev"
      host_rewrite = true
      priority    = 150
    },
    {
      path        = "/cms/"
      backend     = "cms-dev"
      priority    = 160
    },
    {
      path        = "/sku/"
      backend     = "sku-dev"
      priority    = 170
    },
    {
      path        = "/draco/"
      backend     = "draco-dev"
      priority    = 180
    },
    {
      path        = "/mobile-access/"
      backend     = "mobile-api-dev"
      priority    = 190
    },
    {
      path        = "/ct/"
      backend     = "ocp-dev"
      host_rewrite = true
      priority    = 200
    },
    {
      path        = "/drome/"
      backend     = "drome-dev"
      host_rewrite = true
      priority    = 210
    },
    {
      path        = "/rateapproval/"
      backend     = "rateapproval-dev"
      priority    = 220
    },
    {
      path        = "/location-web/"
      backend     = "location-dev"
      priority    = 230
    },
    {
      path        = "/eda-service/"
      backend     = "eventmediator-dev"
      priority    = 240
    },
    {
      path        = "/io/"
      backend     = "tinyurlservice-dev"
      priority    = 250
    },
    {
      path        = "/settings/"
      backend     = "settings-backend-dev"
      priority    = 260
    },
    {
      path        = "/web/settings/"
      backend     = "settings-dev"
      priority    = 270
    },
    {
      path        = "/web/srg/"
      backend     = "srg-dev"
      priority    = 280
    },
    {
      path        = "/web/ds/"
      backend     = "ds-dev"
      priority    = 290
    },
    {
      path        = "/web/locations/"
      backend     = "location-dev"
      priority    = 300
    },
    {
      path        = "/web/tracking/"
      backend     = "ocp-dev"
      priority    = 310
    },
    {
      path        = "/web/auctions/"
      backend     = "auctions-dev"
      priority    = 320
    },
    {
      path        = "/web/earbuds-docs/"
      backend     = "earbuds-dev"
      priority    = 330
    },
    {
      path        = "/web/carrier/"
      backend     = "carrier-dev"
      priority    = 340
    },
    {
      path        = "/web/distance/"
      backend     = "distance-dev"
      priority    = 350
    },
    {
      path        = "/web/isd/"
      backend     = "isd-dev"
      priority    = 360
    },
    {
      path        = "/web/sp/"
      backend     = "sp-dev"
      priority    = 370
    },
    {
      path        = "/web/tracking-portal-ui/"
      backend     = "tracking-portal-ui-dev"
      priority    = 380
    },
    {
      path        = "/web/se/smp/"
      backend     = "web-smp-dev"
      priority    = 390
    },
    {
      path        = "/web/se/"
      backend     = "se-dev"
      priority    = 400
    },
    {
      path        = "/web/sec/"
      backend     = "sec-dev"
      priority    = 410
    },
    {
      path        = "/web/parcel-ui/"
      backend     = "parcel-ui-dev"
      priority    = 420
    },
    {
      path        = "/web/dcm-ui/"
      backend     = "dcm-ui-dev"
      priority    = 430
    },
    {
      path        = "/web/ect-ui/v2"
      backend     = "ect-ui-v2-dev"
      priority    = 440
    },
    {
      path        = "/web/ect-ui"
      backend     = "ect-ui-dev"
      priority    = 450
    },
    {
      path        = "/web/configuration-ui/"
      backend     = "configuration-ui-dev"
      priority    = 460
    },
    {
      path        = "/web/tpangular/"
      backend     = "tpangular-dev"
      priority    = 470
    },
    {
      path        = "/web/orders/"
      backend     = "orders-dev"
      priority    = 480
    },
    {
      path        = "/web/shipments/"
      backend     = "shipments-dev"
      priority    = 490
    },
    {
      path        = "/ratingmaintenance/"
      backend     = "ratingmaintenance-dev"
      host_rewrite = true
      priority    = 500
    },
    {
      path        = "/ratingexternal/"
      backend     = "ratingexternal-dev"
      host_rewrite = true
      priority    = 510
    },
    {
      path        = "/dms/"
      backend     = "dms-dev"
      host_rewrite = true
      priority    = 520
    },
    {
      path        = "/smp/"
      backend     = "smp-dev"
      host_rewrite = true
      priority    = 530
    },
    {
      path        = "/alert-service/"
      backend     = "alert-service-dev"
      priority    = 540
    },
    {
      path        = "/notification/"
      backend     = "notificationservice-dev"
      priority    = 550
    },
    {
      path        = "/configuration/"
      backend     = "configuration-ui-dev"
      priority    = 560
    },
    {
      path        = "/sidekick/"
      backend     = "sidekick-dev"
      host_rewrite = true
      priority    = 570
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

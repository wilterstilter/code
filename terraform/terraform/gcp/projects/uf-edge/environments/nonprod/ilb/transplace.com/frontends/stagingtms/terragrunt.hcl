inputs = {
  port                  = 443
  enable_https_redirects = true
  ip_address            = "10.223.10.15"
  default_backend       = "tms-staging"
  url_map = [
    {
      path        = "/tms/"
      backend     = "tms-staging"
      host_rewrite = true
      priority    = 100
    },
    {
      path        = "/cp/"
      backend     = "cp-staging"
      host_rewrite = true
      priority    = 110
    },
    {
      path        = "/ptms/"
      backend     = "ptms-staging"
      host_rewrite = true
      priority    = 120
    },
    {
      path        = "/yms/"
      backend     = "yms-staging"
      priority    = 130
    },
    {
      path        = "/tracking/"
      backend     = "trackingportalservice-staging"
      host_rewrite = true
      priority    = 140
    },
    {
      path        = "/security/"
      backend     = "security-staging"
      host_rewrite = true
      priority    = 150
    },
    {
      path        = "/cms/"
      backend     = "cms-staging"
      host_rewrite = true
      priority    = 160
    },
    {
      path        = "/sku/"
      backend     = "sku-staging"
      host_rewrite = true
      priority    = 170
    },
    {
      path        = "/draco/"
      backend     = "draco-staging"
      host_rewrite = true
      priority    = 180
    },
    {
      path        = "/mobile-access/"
      backend     = "mobile-api-staging"
      priority    = 190
    },
    {
      path        = "/ct/"
      backend     = "control-tower-staging"
      host_rewrite = true
      priority    = 200
    },
    {
      path        = "/drome/"
      backend     = "drome-staging"
      host_rewrite = true
      priority    = 210
    },
    {
      path        = "/rateapproval/"
      backend     = "rateapproval-staging"
      host_rewrite = true
      priority    = 220
    },
    {
      path        = "/location-web/"
      backend     = "location-staging"
      host_rewrite = true
      priority    = 230
    },
    {
      path        = "/io/"
      backend     = "tinyurlservice-staging"
      host_rewrite = true
      priority    = 250
    },
    {
      path        = "/settings/"
      backend     = "settings-backend-staging"
      priority    = 260
    },
    {
      path        = "/web/srg/"
      backend     = "srg-staging"
      priority    = 280
    },
    {
      path        = "/web/ds/"
      backend     = "ds-staging"
      host_rewrite = true
      priority    = 290
    },
    {
      path        = "/web/carrier/"
      backend     = "carrier-staging"
      priority    = 340
    },
    {
      path        = "/web/distance/"
      backend     = "distance-staging"
      priority    = 350
    },
    {
      path        = "/web/isd/"
      backend     = "isd-staging"
      priority    = 360
    },
    {
      path        = "/web/sp/"
      backend     = "sp-staging"
      priority    = 370
    },
    {
      path        = "/web/tracking-portal-ui/"
      backend     = "tracking-portal-ui-staging"
      priority    = 380
    },
    {
      path        = "/web/se/smp/"
      backend     = "web-smp-staging"
      priority    = 390
    },
    {
      path        = "/web/se/"
      backend     = "se-staging"
      priority    = 400
    },
    {
      path        = "/web/sec/"
      backend     = "sec-staging"
      priority    = 410
    },
    {
      path        = "/web/parcel-ui/"
      backend     = "parcel-ui-staging"
      priority    = 420
    },
    {
      path        = "/web/ect-ui/v2"
      backend     = "ect-ui-v2-staging"
      priority    = 440
    },
    {
      path        = "/web/ect-ui"
      backend     = "ect-ui-staging"
      priority    = 450
    },
    {
      path        = "/web/configuration-ui/"
      backend     = "configuration-ui-staging"
      priority    = 460
    },
    {
      path        = "/ratingmaintenance/"
      backend     = "ratingmaintenance-staging"
      host_rewrite = true
      priority    = 500
    },
    {
      path        = "/ratingexternal/"
      backend     = "ratingexternal-staging"
      host_rewrite = true
      priority    = 510
    },
    {
      path        = "/dms/"
      backend     = "dms-staging"
      host_rewrite = true
      priority    = 520
    },
    {
      path        = "/smp/"
      backend     = "smp-staging"
      host_rewrite = true
      priority    = 530
    },
    {
      path        = "/alert-service/"
      backend     = "alert-service-staging"
      host_rewrite = true
      priority    = 540
    },
    {
      path        = "/notification/"
      backend     = "notificationservice-staging"
      priority    = 550
    },
    {
      path        = "/configuration/"
      backend     = "config-app-staging"
      priority    = 560
    },
    {
      path        = "/sidekick/"
      backend     = "sidekick-staging"
      host_rewrite = true
      priority    = 570
    },
    {
      path        = "/draco-esclient-svc/"
      backend     = "draco-es-client-svc-staging"
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

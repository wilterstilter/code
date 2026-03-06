inputs = {
  port                  = 443
  enable_https_redirects = true
  ip_address             = "10.227.10.25"
  default_backend        = "ptms-tmob-shippingapi-dev"
  url_map = [
    {
        path        = "/ptms/t-mobile/api/shipping/"
        backend     = "ptms-tmob-shippingapi-dev"
        priority    = 620
      },
      {
        path        = "/ptms/t-mobile/api/admin/"
        backend     = "ptms-tmob-adminapi-dev"
        priority    = 630
      },
      {
        path        = "/ptms/t-mobile/api/config/"
        backend     = "ptms-tmob-configapi-dev"
        priority    = 640
      },
      {
        path        = "/ptms/t-mobile/api/label/"
        backend     = "ptms-tmob-labelapi-dev"
        priority    = 650
      },
      {
        path        = "/ptms/t-mobile/api/rating/"
        backend     = "ptms-tmob-ratingapi-dev"
        priority    = 660
      },
      {
        path        = "/ptms/t-mobile/api/ratingexternal/"
        backend     = "ptms-tmob-ratingexternalapi-dev"
        priority    = 670
      },
      {
        path        = "/ptms/t-mobile/api/shippingexternal/"
        backend     = "ptms-tmob-shippingexternalapi-dev"
        priority    = 680
      },
      {
        path        = "/ptms/t-mobile/api/labelexternal/"
        backend     = "ptms-tmob-labelexternalapi-dev"
        priority    = 690
      },
      {
        path        = "/ptms/t-mobile/api/manifest/"
        backend     = "ptms-tmob-manifestapi-dev"
        priority    = 700
      },
      {
        path        = "/ptms/t-mobile/api/reports/"
        backend     = "ptms-tmob-reportsapi-dev"
        priority    = 710
      },
      {
        path        = "/ptms/t-mobile/admin/"
        backend     = "ptms-tmob-adminui-dev"
        priority    = 720
      },
      {
        path        = "/ptms/t-mobile/induction/"
        backend     = "ptms-tmob-inductionui-dev"
        priority    = 730
      }
    ]
}

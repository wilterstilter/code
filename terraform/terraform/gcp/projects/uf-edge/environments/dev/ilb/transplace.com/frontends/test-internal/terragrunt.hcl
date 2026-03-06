inputs = {
  port                  = 443
  enable_https_redirects = true
  ip_address            = "10.227.10.17"
  default_backend       = "ptms-cvs-ratingapi-test"
  url_map = [
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
    {
      path        = "/ptmscvs-induction/"
      backend     = "ptms-cvs-inductionui-test"
      priority    = 700
    },
    {
      path        = "/ptmscvs-admin/"
      backend     = "ptms-cvs-adminui-test"
      priority    = 710
    },
    {
      path        = "/api/auth/"
      backend     = "ptms-cvs-authapi-test"
      priority    = 720
    },
    {
      path        = "/ast/"
      backend     = "ast-grafana-test"
      priority    = 730
    },
    {
      path        = "/"
      backend     = "awx-gke-dev"
      priority    = 740
      path_prefix_rewrite = true
    },
  ]
}

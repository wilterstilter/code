inputs = {
  port                  = 443
  enable_host_rewrite   = true
  enable_https_redirects = true
  ip_address            = "10.247.10.17"
  default_backend       = "ocp-dev"
  url_map = [
    {
      path        = "/tms/"
      backend     = "tms-dev"
      priority    = 100
    },
    {
      path        = "/tracking/"
      backend     = "ocp-dev"
      priority    = 110
    },
    {
      path        = "/alive/"
      backend     = "alive-dev"
      priority    = 120
    },
    {
      path        = "/nginx/"
      backend     = "nginx-dev"
      priority    = 130
    },
  ]
}

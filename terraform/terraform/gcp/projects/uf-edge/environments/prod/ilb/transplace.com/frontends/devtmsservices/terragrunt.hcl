inputs = {
  port                  = 443
  enable_host_rewrite   = true
  enable_https_redirects = true
  ip_address            = "10.247.10.12"
  default_backend       = "tms-dev"
  url_map = [
    {
      path     = "/tms/"
      backend  = "tms-dev"
      priority = 100
    },
    {
      path     = "/yms/"
      backend  = "yms-dev"
      priority = 110
    },
    {
      path     = "/tracking/"
      backend  = "tracking-dev"
      priority = 120
    },
    {
      path     = "/security/"
      backend  = "security-dev"
      priority = 130
    },
    {
      path     = "/alive/"
      backend  = "alive-dev"
      priority = 140
    },
    {
      path     = "/nginx/"
      backend  = "nginx-dev"
      priority = 150
    },
  ]
}

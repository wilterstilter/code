inputs = {
  port                  = 443
  enable_https_redirects = true
  ip_address            = "10.223.10.12"
  default_backend       = "tmsservices-staging"
  url_map = [
    {
      path     = "/tms/"
      backend  = "tmsservices-staging"
      priority = 100
    },
    {
      path     = "/tracking/"
      backend  = "tracking-staging"
      priority = 105
    },
    {
      path     = "/yms/"
      backend  = "yms-staging"
      priority = 110
    },
    {
      path     = "/security/"
      backend  = "security-staging"
      priority = 115
    },
  ]
}

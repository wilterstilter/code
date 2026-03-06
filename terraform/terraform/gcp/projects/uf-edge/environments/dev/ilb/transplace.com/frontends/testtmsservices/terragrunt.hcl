inputs = {
  port                  = 443
  enable_https_redirects = true
  ip_address            = "10.227.10.12"
  default_backend       = "tmsservices-test"
  url_map = [
    {
      path     = "/tms/"
      backend  = "tmsservices-test"
      priority = 100
    },
    {
      path     = "/tracking/"
      backend  = "tracking-test"
      priority = 105
    },
    {
      path     = "/yms/"
      backend  = "yms-test"
      priority = 110
    },
    {
      path     = "/security/"
      backend  = "security-test"
      priority = 115
    },
  ]
}

inputs = {
  port                  = 443
  enable_https_redirects = true
  ip_address            = "10.223.10.16"
  default_backend       = "tms-staging"
  url_map = [
    {
      path        = "/draco-es-client/"
      backend     = "draco-es-client-staging"
      priority    = 100
    },
    {
      path        = "/draco-es-client-svc/"
      backend     = "draco-es-client-svc-staging"
      priority    = 105
    }
  ]
}

inputs = {
  port                  = 443
  enable_https_redirects = true
  ip_address            = "10.227.10.16"
  default_backend       = "tms-test"
  url_map = [
    {
      path        = "/draco-es-client/"
      backend     = "draco-es-client-test"
      priority    = 100
    },
    {
      path        = "/draco-es-client-svc/"
      backend     = "draco-es-client-svc-test"
      priority    = 105
    }
  ]
}

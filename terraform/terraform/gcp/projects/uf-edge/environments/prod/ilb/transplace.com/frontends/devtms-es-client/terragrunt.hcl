inputs = {
  port                  = 443
  enable_host_rewrite   = true
  enable_https_redirects = true
  ip_address            = "10.247.10.16"
  default_backend       = "tms-dev"
  url_map = [
    {
      path        = "/draco-es-client/"
      backend     = "draco-es-client-dev"
      priority    = 100
    }
  ]
}

inputs = {
  port                  = 80
  ip_address            = "10.227.10.19"
  default_backend       = "tms-dev"
  url_map = [
    {
      path     = "/yms/"
      backend  = "yms-dev"
      priority = 100
    },
    {
      path     = "/tracking/"
      backend  = "tracking-dev"
      priority = 110
    }
  ]
}

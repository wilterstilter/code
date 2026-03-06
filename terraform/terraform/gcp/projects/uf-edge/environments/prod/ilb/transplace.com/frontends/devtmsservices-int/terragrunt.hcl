inputs = {
  port                  = 80
  ip_address            = "10.247.10.13"
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

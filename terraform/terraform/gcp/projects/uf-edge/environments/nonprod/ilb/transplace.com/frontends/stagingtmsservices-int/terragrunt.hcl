inputs = {
  port                  = 80
  ip_address            = "10.223.10.13"
  default_backend       = "tms-staging"
  url_map = [
    {
      path     = "/yms/"
      backend  = "yms-staging"
      priority = 100
    },
    {
      path     = "/tracking/"
      backend  = "tracking-staging"
      priority = 110
    }
  ]
}

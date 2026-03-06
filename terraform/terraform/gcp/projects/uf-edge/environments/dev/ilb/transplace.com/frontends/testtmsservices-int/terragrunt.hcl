inputs = {
  port                  = 80
  ip_address            = "10.227.10.13"
  default_backend       = "tms-test"
  url_map = [
    {
      path     = "/yms/"
      backend  = "yms-test"
      priority = 100
    },
    {
      path     = "/tracking/"
      backend  = "tracking-test"
      priority = 110
    }
  ]
}

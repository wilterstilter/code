inputs = {
  port                  = 443
  enable_https_redirects = true
  ip_address             = "10.227.10.24"
  default_backend        = "jenkins-test"
  url_map = [
      {
        path     = "/jenkinsv2"
        backend  = "jenkins-test"
        priority = 290
      }
    ]
}

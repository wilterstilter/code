inputs = {
  health_checks = {
    "jenkins-test" = {
      port                = 8080
      path                = "/jenkinsv2/login"
    }
  }
}

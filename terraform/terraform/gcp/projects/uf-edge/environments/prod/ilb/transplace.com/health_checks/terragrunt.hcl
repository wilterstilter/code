inputs = {
  health_checks = {
    "ocp-dev" = {
      path = "/healthz"
      port = 1936
    },
    "tms-dev" = {
      path = "/tms/version.jsp"
      port = 7077
    },
    "cp-dev" = {
      path = "/cp/index.html"
      port = 7092
    },
    "ptms-dev" = {
      path = "/ptms/index.html"
      port = 80
    },
    "gke-nginx" = {
      path = "/"
      port = 80
    },
    "dms-dev" = {
      path = "/dms/index.html"
      port = 7042
    },
    "smp-dev" = {
      path = "/smp/index.html"
      port = 8080
    },
    "rmc-dev" = {
      path = "/rmcengine19/index.html"
      port = 8180
    },
    "ratingmaintenance-dev" = {
      path = "/ratingmaintenance/index.html"
      port = 8080
    },
    "rating-dev" = {
      path = "/ratingengine/index.html"
      port = 8080
    },
    "ratingengine-dev" = {
      path = "/ratingengine/index.html"
      port = 8080
    },
    "ratingexternal-dev" = {
      path = "/ratingexternal/index.html"
      port = 8080
    },
    "oca-dev" = {
      path = "/info"
      port = 8180
    },
    "optimize-dev" = {
      path = "/optimizeengine/index.jsp"
      port = 8080
    },
    "optimizeengine-dev" = {
      path = "/optimizeengine/index.jsp"
      port = 8080
    },
    "optimizerest-dev" = {
      path = "/maoptimizerest/index.jsp"
      port = 8080
    },
    "correctaddress-dev" = {
      path = "/correctAddress/"
      port = 8080
    },
    "mit-dev" = {
      path = "/mit/actuator/health"
      port = 8080
    }
  }
}

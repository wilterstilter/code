inputs = {
  health_checks = {
    "ocp-staging" = {
      path = "/healthz"
      port = 1936
    },
    "tms-staging" = {
      path = "/tms/version.jsp"
      port = 7077
    },
    "cp-staging" = {
      path = "/cp/index.html"
      port = 7092
    },
    "ptms-staging" = {
      path = "/ptms/index.html"
      port = 80
    },
    "dms-staging" = {
      path = "/dms/index.html"
      port = 7042
    },
    "smp-staging" = {
      path = "/smp/index.html"
      port = 8080
    },
    "rmc-staging" = {
      path = "/rmcengine19/index.html"
      port = 8180
    },
    "ratingmaintenance-staging" = {
      path = "/ratingmaintenance/index.html"
      port = 8080
    },
    "rating-staging" = {
      path = "/ratingengine/index.html"
      port = 8080
    },
    "ratingengine-staging" = {
      path = "/ratingengine/index.html"
      port = 8080
    },
    "ratingexternal-staging" = {
      path = "/ratingexternal/index.html"
      port = 8080
    },
    "oca-staging" = {
      path = "/info"
      port = 8280
    },
    "optimize-staging" = {
      path = "/optimizeengine/index.jsp"
      port = 8080
    },
    "optimizeengine-staging" = {
      path = "/optimizeengine/index.jsp"
      port = 8080
    },
    "optimizerest-staging" = {
      path = "/maoptimizerest/index.jsp"
      port = 8080
    },
    "correctaddress-staging" = {
      path = "/correctAddress/"
      port = 8080
    },
    "mit-staging" = {
      path = "/mit/actuator/health"
      port = 8080
    }
  }
}

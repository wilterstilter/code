inputs = {
  health_checks = {
    "ocp-test" = {
      path = "/healthz"
      port = 1936
    },
    "tms-test" = {
      path = "/tms/version.jsp"
      port = 7077
    },
    "cp-test" = {
      path = "/cp/index.html"
      port = 7092
    },
    "ptms-test" = {
      path = "/ptms/index.html"
      port = 80
    },
    "dms-test" = {
      path = "/dms/index.html"
      port = 7042
    },
    "smp-test" = {
      path = "/smp/index.html"
      port = 8080
    },
    "rmc-test" = {
      path = "/rmcengine19/index.html"
      port = 8180
    },
    "ratingmaintenance-test" = {
      path = "/ratingmaintenance/index.html"
      port = 8080
    },
    "rating-test" = {
      path = "/ratingengine/index.html"
      port = 8080
    },
    "ratingengine-test" = {
      path = "/ratingengine/index.html"
      port = 8080
    },
    "ratingexternal-test" = {
      path = "/ratingexternal/index.html"
      port = 8080
    },
    "oca-test" = {
      path = "/info"
      port = 8280
    },
    "optimize-test" = {
      path = "/optimizeengine/index.jsp"
      port = 8080
    },
    "optimizeengine-test" = {
      path = "/optimizeengine/index.jsp"
      port = 8080
    },
    "optimizerest-test" = {
      path = "/maoptimizerest/index.jsp"
      port = 8080
    },
    "correctaddress-test" = {
      path = "/correctAddress/"
      port = 8080
    },
    "mit-test" = {
      path = "/mit/actuator/health"
      port = 8080
    },




    ### DEV ##
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
      port = 8280
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

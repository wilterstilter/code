include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-edge/modules/cloud-armor"
}

include "common" {
    path = find_in_parent_folders("common.hcl")
    expose = true
}

inputs = {
  name = include.common.locals.name
  region = "us-south1"
  rules = [
    {
      priority    = 1000
      action      = "deny(403)"
      expression  = "request.query.contains('() {')"
      description = "Deny requests with Shellshock pattern in query string"
      preview     = false
    },
    {
      priority    = 1001
      action      = "deny(403)"
      expression  = "request.headers['cookie'].matches('^TS(?:[0-9a-fA-F]{6,8})(?:$|_[0-9]+$)')"
      description = "Deny requests with ASM cookies"
      preview     = false
    }
  ]
}

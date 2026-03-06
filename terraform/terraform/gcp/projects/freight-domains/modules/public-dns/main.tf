locals {
  domain_name = (
    strcontains(var.domain, "in-addr.arpa")
    ? replace("rdns-${var.domain}", ".", "-")
    : can(tonumber(substr(var.domain, 0, 1)))
    ? replace("domain-${var.domain}", ".", "-")
    : replace(var.domain, ".", "-")
  )
}

module "public-dns" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "5.2.0"

  project_id = var.project_id

  # Zone name must begin with a letter, end with a letter or digit, and only contain lowercase letters, digits or dashes.
  # Example: example-zone-name. Zone name, must be unique within the project.
  name   = local.domain_name
  domain = "${var.domain}."

  type = "public"

  dnssec_config = {
    non_existence = "nsec3"
    state         = "on"
  }

  labels = {
    "team" : "network"
  }

  recordsets = var.recordsets
}


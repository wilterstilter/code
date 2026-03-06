include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/freight-domains/modules/public-dns"
}

include "domains" {
    path = find_in_parent_folders("domains.hcl")
    expose = true
}

inputs = {
    project_id = include.gcp.locals.project_id
    domain = include.domains.locals.domain
    recordsets =  [
        {
            name = ""
            type = "A"
            ttl  = 300
            records = [
                "65.64.216.155",
            ]
        },
        {
            name = "a"
            type = "A"
            ttl  = 300
            records = [
                "65.64.216.155",
            ]
        },
        {
            name = "d"
            type = "A"
            ttl  = 300
            records = [
                "65.64.216.155",
            ]
        },
        {
            name = "t"
            type = "A"
            ttl  = 300
            records = [
                "65.64.216.155",
            ]
        },
        {
            name = "u"
            type = "A"
            ttl  = 300
            records = [
                "65.64.216.155",
            ]
        },
        {
            name = "_pki-validation"
            type = "TXT"
            ttl  = 300
            records = [
              "792C-40B1-D1E0-915A-9DC7-D37E-1136-4CBF"
            ]
        },
        {
            name = ""
            type = "TXT"
            ttl  = 300
            records = [
              "_kja3u7ynkjpc9lgw67wecior6kptj0b",
              "_4e9m4tuhuzk9pzu6cljgu5ne7ovl5q0",
              "\"v=spf1 include:mail.zendesk.com include:_spf.salesforce.com include:cvent-planner.com include:spf.greatmail.com include:_spf.ultipro.com include:_spf.psm.knowbe4.com include:us._netblocks.mimecast.com ip4:54.240.8.0/24\" \" ip4:160.34.15.16/29 ip4:65.64.216.0/24 ip4:52.185.227.176/32 ip4:20.45.2.251/32 ip4:208.191.62.0/24 ~all\"",
            ]
        },
    ]
}

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
            name = "www"
            type = "A"
            ttl  = 300
            records = [
                "34.71.82.88",
            ]
        },
        {
            name = "tpmail"
            type = "A"
            ttl  = 300
            records = [
                "65.64.216.181",
            ]
        },
        {
            name = "smtp"
            type = "A"
            ttl  = 300
            records = [
                "65.64.216.137",
            ]
        },
        {
            name = "l8uagvl1"
            type = "A"
            ttl  = 300
            records = [
                "208.191.62.113",
            ]
        },
        {
            name = ""
            type = "TXT"
            ttl  = 300
            records = [
              "_u0f9ml7hxoysrgs0xmszg34q8w1qk03",
              "\"v=spf1 include:mail.zendesk.com include:_spf.salesforce.com include:cvent-planner.com include:spf.greatmail.com include:_spf.ultipro.com include:_spf.psm.knowbe4.com include:us._netblocks.mimecast.com ip4:54.240.8.0/24\" \" ip4:160.34.15.16/29 ip4:65.64.216.0/24 ip4:52.185.227.176/32 ip4:20.45.2.251/32 ip4:208.191.62.0/24 ~all\"",
            ]
        },
        {
            name = "autodiscover"
            type = "CNAME"
            ttl  = 300
            records = [
                "tpmail.transplace.net.",
            ]
        },
        {
            name = "d8ex10cvl1"
            type = "CNAME"
            ttl  = 300
            records = [
                "tpmail.transplace.net.",
            ]
        },
        {
            name = "legacy"
            type = "CNAME"
            ttl  = 300
            records = [
                "tpmail.transplace.net.",
            ]
        },
        {
            name = "mailrelay"
            type = "CNAME"
            ttl  = 300
            records = [
                "smtp.transplace.net.",
            ]
        },
    ]
}

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
            ttl = 300
            records = [
                "65.64.216.112",
            ]
        },
        {
            name = ""
            type = "MX"
            ttl = 300
            records = [
                "10 mail.eatonroute.com.",
            ]
        },
        {
            name = ""
            type = "TXT"
            ttl = 300
            records = [
                "\"v=spf1 include:mail.zendesk.com include:_spf.salesforce.com include:cvent-planner.com include:spf.greatmail.com include:_spf.ultipro.com include:_spf.psm.knowbe4.com include:us._netblocks.mimecast.com ip4:54.240.8.0/24\" \" ip4:160.34.15.16/29 ip4:65.64.216.0/24 ip4:52.185.227.176/32 ip4:20.45.2.251/32 ip4:208.191.62.0/24 ~all\"",
            ]
        },
        {
            name = "_pki-validation"
            type = "TXT"
            ttl = 300
            records = [
                "66B4-CFFE-1E18-2337-7039-4E21-2D4C-5F82",
            ]
        },
        {
            name = "ftp"
            type = "A"
            ttl = 300
            records = [
                "216.128.1.224",
            ]
        },
        {
            name = "localhost"
            type = "A"
            ttl = 300
            records = [
                "127.0.0.1",
            ]
        },
        {
            name = "mail"
            type = "A"
            ttl = 300
            records = [
                "216.128.11.8",
            ]
        },
        {
            name = "www"
            type = "CNAME"
            ttl = 300
            records = [
                "eatonroute.com.",
            ]
        },
        {
            name = "www.uat"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.195",
            ]
        },
    ]
}

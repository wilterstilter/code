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
                "64.239.109.1",
            ]
        },
		{
            name = "www"
            type = "CNAME"
            ttl = 300
            records = [
                "c5cad8a7abfff480.vercel-dns-013.com.",
            ]
        },
        {
            name = "_cf-custom-hostname"
            type = "TXT"
            ttl = 300
            records = [
                "6d4571e1-0b62-49a6-acdb-756a805ece34",
            ]
        },
        {
            name = "_vercel"
            type = "TXT"
            ttl = 300
            records = [
                "vercel-test",
            ]
        },
		{
            name = "_acme-challenge"
            type = "CNAME"
            ttl = 300
            records = [
                "transplace.org.kinstavalidation.app.",
            ]
        },
        {
            name = ""
            type = "TXT"
            ttl  = 300
            records = [
              "_9ueoxbybaatt00vxdklkns36cxqylw7",
              "\"v=spf1 include:mail.zendesk.com include:_spf.salesforce.com include:cvent-planner.com include:spf.greatmail.com include:_spf.ultipro.com include:_spf.psm.knowbe4.com include:us._netblocks.mimecast.com ip4:54.240.8.0/24\" \" ip4:160.34.15.16/29 ip4:65.64.216.0/24 ip4:52.185.227.176/32 ip4:20.45.2.251/32 ip4:208.191.62.0/24 ~all\"",
            ]
        },
    ]
}

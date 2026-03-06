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
            type = "CNAME"
            ttl  = 300
            records = [
                "c5cad8a7abfff480.vercel-dns-013.com.",
            ]
        },
        {
            name = ""
            type = "TXT"
            ttl  = 300
            records = [
                "_zp9s6c1nl2gwqoborymafc56ijx6jl2",
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
            name = ""
            type = "A"
            ttl = 300
            records = [
                "64.239.109.1",
            ]
        },
    ]
}

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
                "65.64.216.109",
            ]
        },
        {
            name = "autodiscover"
            type = "CNAME"
            ttl  = 300
            records = [
                "autodiscover.outlook.com.",
            ]
        },
        {
            name = "msoid"
            type = "CNAME"
            ttl  = 300
            records = [
                "clientconfig.microsoftonline-p.net.",
            ]
        },
    ]
}

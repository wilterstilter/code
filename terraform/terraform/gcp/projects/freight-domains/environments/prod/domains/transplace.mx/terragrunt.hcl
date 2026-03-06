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
            name = ""
            type = "TXT"
            ttl  = 300
            records = [
                "_abpwe9qsee8yfz64vj0b8newt7mrwcn",
            ]
        },
    ]
}

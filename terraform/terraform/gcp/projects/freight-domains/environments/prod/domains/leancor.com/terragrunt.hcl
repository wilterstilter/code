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
                "141.193.213.10",
                "141.193.213.11",
            ]
        },
        {
            name = ""
            type = "TXT"
            ttl = 300
            records = [
                "_3xwfn51oudzuzhu4ls78vzz68o6f9od",
                "google-site-verification=EmXa85RJ8D5hSCUydEzrBojh08i1EKr0vHqlHSIJgiY",
                "globalsign-domain-verification=0c8519e0ded8df3c5a296506f1f00931",
                "va8mkdd3jufhvkfg08h9npn2ij",
                "globalsign-domain-verification=703E82179115D6B4E801FEB233AF6E85",
                "globalsign-domain-verification=8BCCDAAA076CAEE9F7E6CFE727A95753",
                "globalsign-domain-verification=9EDBBD2433636F7ED937AEFFB26740A5",
            ]
        },
        {
            name = "ftp"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.162",
            ]
        },
        {
            name = "ftp2"
            type = "A"
            ttl = 300
            records = [
                "146.20.43.46",
            ]
        },
    ]
}

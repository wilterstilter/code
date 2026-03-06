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
            name = "nonprod-ldap"
            type = "A"
            ttl  = 300
            records = [
                "208.191.62.170",
            ]
        },
        {
            name = ""
            type = "TXT"
            ttl  = 300
            records = [
              "_68ctzwsdcpwbhzouk6bi1j064ihd2xg",
            ]
        },
        {
            name = "_pki-validation"
            type = "TXT"
            ttl  = 300
            records = [
              "8238-8FE9-5205-9AB4-C168-1149-8716-6F87",
            ]
        },
    ]
}

include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

include "domains" {
    path = find_in_parent_folders("domains.hcl")
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/freight-domains/modules/public-dns"
}

inputs = {
    project_id  = include.gcp.locals.project_id
    domain = include.domains.locals.domain
    recordsets =  [
        {
            name = "pa-edl"
            type = "A"
            ttl  = 300
            records = [
                "34.49.118.236",
            ]
        },
        {
            name = "us-east4.devpod"
            type = "A"
            ttl  = 300
            records = [
                "35.230.181.123",
            ]
        },
        {
            name = "*.us-east4.devpod"
            type = "A"
            ttl  = 300
            records = [
                "35.230.181.123",
            ]
        },
        {
            name = "_acme-challenge_lywjcbvrroxhgp7w.us-east4.devpod"
            type = "CNAME"
            ttl  = 300
            records = [
                "04cf3aac-e3d3-4ef1-b12e-a664133637c1.1.us-east4.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "testglb"
            type = "A"
            ttl  = 300
            records = [
                "34.160.36.26",
            ]
        },
        {
            name = ""
            type = "TXT"
            ttl  = 300
            records = [
                "_r65ipptrpqt8vkg7jx48jyx12r538r0",
            ]
        },
    ]
}

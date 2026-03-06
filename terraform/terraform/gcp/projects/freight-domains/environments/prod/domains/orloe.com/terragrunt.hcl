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
                "45.223.18.72",
            ]
        },
        {
            name = ""
            type = "TXT"
            ttl = 300
            records = [
                "_mm0hqh52ao7blemsqvrh3i1icwc57pa",
                "globalsign-domain-verification=E82DB5B012B8FD28D5F7A6B3A0237188",
                "globalsign-domain-verification=9561DF2DB876DBBF6690F3897B2EA284",
                "globalsign-domain-verification=C722694B2B171956CA357D9DF33CCEA1",
            ]
        },
        {
            name = "_pki-validation"
            type = "TXT"
            ttl = 300
            records = [
                "80E0-D61F-55B8-6175-B55C-F6BC-3D32-9797",
            ]
        },
        {
            name = "auth"
            type = "A"
            ttl = 300
            records = [
                "34.54.21.161",
            ]
        },
        {
            name = "autodiscover"
            type = "CNAME"
            ttl = 300
            records = [
                "autodiscover.emailsrvr.com.",
            ]
        },
        {
            name = "ct"
            type = "A"
            ttl = 300
            records = [
                "146.20.43.41",
            ]
        },
        {
            name = "demo"
            type = "A"
            ttl = 300
            records = [
                "146.20.43.45",
            ]
        },
        {
            name = "loadboard"
            type = "A"
            ttl = 300
            records = [
                "146.20.43.41",
            ]
        },
        {
            name = "loadplan"
            type = "A"
            ttl = 300
            records = [
                "34.54.21.161",
            ]
        },
        {
            name = "ninja-api"
            type = "A"
            ttl = 300
            records = [
                "34.54.21.161",
            ]
        },
        {
            name = "orders"
            type = "A"
            ttl = 300
            records = [
                "34.54.21.161",
            ]
        },
        {
            name = "pfep"
            type = "A"
            ttl = 300
            records = [
                "34.54.21.161",
            ]
        },
        {
            name = "rates"
            type = "A"
            ttl = 300
            records = [
                "34.54.21.161",
            ]
        },
        {
            name = "rdt"
            type = "A"
            ttl = 300
            records = [
                "34.54.21.161",
            ]
        },
        {
            name = "routing"
            type = "A"
            ttl = 300
            records = [
                "34.54.21.161",
            ]
        },
        {
            name = "srm"
            type = "A"
            ttl = 300
            records = [
                "34.54.21.161",
            ]
        },
        {
            name = "test"
            type = "A"
            ttl = 300
            records = [
                "146.20.43.45",
            ]
        },
        {
            name = "transit"
            type = "A"
            ttl = 300
            records = [
                "34.54.21.161",
            ]
        },
        {
            name = "transportation"
            type = "A"
            ttl = 300
            records = [
                "34.54.21.161",
            ]
        },
        {
            name = "weblinx-api"
            type = "A"
            ttl = 300
            records = [
                "146.20.43.41",
            ]
        },
        {
            name = "www"
            type = "A"
            ttl = 300
            records = [
                "34.54.21.161",
            ]
        },
        {
            name = "_acme-challenge.auth"
            type = "CNAME"
            ttl = 300
            records = [
                "387a57c0-92d6-4141-b76d-5fad04f26a4d.16.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "_acme-challenge"
            type = "CNAME"
            ttl = 300
            records = [
                "74170250-fb90-43fa-b209-d3bb5726a65c.17.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "auth"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.orloe.com",
            ]
        },
    ]
}

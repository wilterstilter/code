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
            type = "TXT"
            ttl  = 300
            records = [
                "_wcj0g0ecs5wp63vwofmm8oeaj2mu7gb",
            ]
        },
        {
            name = "*.ts16"
            type = "A"
            ttl = 300
            records = [
                "10.72.82.16",
            ]
        },
        {
            name = "*.ts17"
            type = "A"
            ttl = 300
            records = [
                "10.72.82.17",
            ]
        },
        {
            name = "*.uat"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.57",
            ]
        },
        {
            name = "_domainconnect"
            type = "CNAME"
            ttl = 300
            records = [
                "_domainconnect.gd.domaincontrol.com.",
            ]
        },
        {
            name = "_pki-validation"
            type = "TXT"
            ttl = 300
            records = [
                "B15B-4DB0-051E-C05E-D7D5-6D95-97F3-EEC4",
            ]
        },
        {
            name = "ftp.uat"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.57",
            ]
        },
        {
            name = "loadplan.uat"
            type = "A"
            ttl = 300
            records = [
                "34.36.198.173",
            ]
        },
        {
            name = "mydb"
            type = "A"
            ttl = 300
            records = [
                "10.2.244.148",
            ]
        },
        {
            name = "ninja-api.uat"
            type = "A"
            ttl = 300
            records = [
                "34.36.198.173",
            ]
        },
        {
            name = "orders.uat"
            type = "A"
            ttl = 300
            records = [
                "34.36.198.173",
            ]
        },
        {
            name = "orloe.uat"
            type = "A"
            ttl = 300
            records = [
                "34.36.198.173",
            ]
        },
        {
            name = "pfep.uat"
            type = "A"
            ttl = 300
            records = [
                "34.36.198.173",
            ]
        },
        {
            name = "rdt.uat"
            type = "A"
            ttl = 300
            records = [
                "34.36.198.173",
            ]
        },
        {
            name = "routing.uat"
            type = "A"
            ttl = 300
            records = [
                "34.36.198.173",
            ]
        },
        {
            name = "srm.uat"
            type = "A"
            ttl = 300
            records = [
                "34.36.198.173",
            ]
        },
        {
            name = "transit.uat"
            type = "A"
            ttl = 300
            records = [
                "34.36.198.173",
            ]
        },
        {
            name = "transportation.uat"
            type = "A"
            ttl = 300
            records = [
                "34.36.198.173",
            ]
        },
        {
            name = "uat"
            type = "TXT"
            ttl = 300
            records = [
                "globalsign-domain-verification=A56F8FF7852F234562C59A6901F34529",
                "globalsign-domain-verification=BC4AC6EA2D81A4E2EFD9BEC0549BB1B1",
            ]
        },
        {
            name = "www"
            type = "CNAME"
            ttl = 300
            records = [
                "orloetest.com.",
            ]
        },
        {
            name = "_acme-challenge.auth.uat"
            type = "CNAME"
            ttl = 300
            records = [
                "c3872cb7-8f04-4db5-9dab-01f490c74282.1.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "auth.uat"
            type = "A"
            ttl = 300
            records = [
                "34.36.198.173",
            ]
        },
        {
            name = "_acme-challenge.uat"
            type = "CNAME"
            ttl = 300
            records = [
                "22a01354-d099-4b1f-9564-52cad612c0fe.14.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "auth.uat"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.orloetest.com",
            ]
        },
    ]
}

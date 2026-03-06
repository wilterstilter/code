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
            name = "_d5dff507d7b0912c46f4a816b745cef3.test2-hellofresh"
            type = "CNAME"
            ttl = 300
            records = [
                "_b1d589d5a146624d7072b5f9d52e411a.jfrzftwwjs.acm-validations.aws.",
            ]
        },
        {
            name = ""
            type = "TXT"
            ttl = 300
            records = [
                "_zouo2x5wj2ufnfsahrtz60i8myuul1d",
            ]
        },
        {
            name = "_dnsauth"
            type = "TXT"
            ttl = 300
            records = [
                "dbcr18h36ttl422n3d3bp0sj1qs57s7v",
            ]
        },
        {
            name = "_pki-validation"
            type = "TXT"
            ttl = 300
            records = [
                "E908-052A-6193-19E7-8E77-56D8-3E87-11F2",
            ]
        },
        {
            name = "auth-bulkaddress"
            type = "A"
            ttl = 300
            records = [
                "3.12.70.24",
            ]
        },
        {
            name = "auth-hellofresh"
            type = "A"
            ttl = 300
            records = [
                "3.12.70.24",
            ]
        },
        {
            name = "auth-management"
            type = "A"
            ttl = 300
            records = [
                "3.12.70.24",
            ]
        },
        {
            name = "auth-reports"
            type = "A"
            ttl = 300
            records = [
                "3.12.70.24",
            ]
        },
        {
            name = "auth-shipping"
            type = "A"
            ttl = 300
            records = [
                "3.12.70.24",
            ]
        },
        {
            name = "auth-users"
            type = "A"
            ttl = 300
            records = [
                "3.12.70.24",
            ]
        },
        {
            name = "basic-demo"
            type = "A"
            ttl = 300
            records = [
                "3.15.72.250",
            ]
        },
        {
            name = "bulkaddress"
            type = "A"
            ttl = 300
            records = [
                "3.12.70.24",
            ]
        },
        {
            name = "carrierwebhooks"
            type = "A"
            ttl = 300
            records = [
                "3.12.70.24",
            ]
        },
        {
            name = "courier-demo"
            type = "A"
            ttl = 300
            records = [
                "3.15.72.250",
            ]
        },
        {
            name = "default"
            type = "A"
            ttl = 300
            records = [
                "18.219.6.216",
            ]
        },
        {
            name = "demo"
            type = "A"
            ttl = 300
            records = [
                "3.15.72.250",
            ]
        },
        {
            name = "demo2"
            type = "A"
            ttl = 300
            records = [
                "3.15.72.250",
            ]
        },
        {
            name = "demo3"
            type = "A"
            ttl = 300
            records = [
                "3.15.72.250",
            ]
        },
        {
            name = "demo4"
            type = "A"
            ttl = 300
            records = [
                "3.15.72.250",
            ]
        },
        {
            name = "hellofresh"
            type = "A"
            ttl = 300
            records = [
                "3.12.70.24",
            ]
        },
        {
            name = "hf-health"
            type = "A"
            ttl = 300
            records = [
                "3.12.70.24",
            ]
        },
        {
            name = "management"
            type = "A"
            ttl = 300
            records = [
                "3.12.70.24",
            ]
        },
        {
            name = "nord-management-test"
            type = "A"
            ttl = 300
            records = [
                "18.224.214.79",
            ]
        },
        {
            name = "nord-reports-test"
            type = "A"
            ttl = 300
            records = [
                "18.224.214.79",
            ]
        },
        {
            name = "nuget"
            type = "A"
            ttl = 300
            records = [
                "3.15.72.250",
            ]
        },
        {
            name = "reports"
            type = "A"
            ttl = 300
            records = [
                "3.12.70.24",
            ]
        },
        {
            name = "scy-api-dev"
            type = "A"
            ttl = 300
            records = [
                "18.219.6.216",
            ]
        },
        {
            name = "scy-api-tst"
            type = "A"
            ttl = 300
            records = [
                "18.219.6.216",
            ]
        },
        {
            name = "scy-ui-dev"
            type = "A"
            ttl = 300
            records = [
                "18.219.6.216",
            ]
        },
        {
            name = "scy-ui-tst"
            type = "A"
            ttl = 300
            records = [
                "18.219.6.216",
            ]
        },
        {
            name = "services"
            type = "A"
            ttl = 300
            records = [
                "18.219.6.216",
            ]
        },
        {
            name = "shipping"
            type = "A"
            ttl = 300
            records = [
                "3.12.70.24",
            ]
        },
        {
            name = "test-carrierwebhooks"
            type = "A"
            ttl = 300
            records = [
                "3.128.163.7",
            ]
        },
        {
            name = "test-hellofresh"
            type = "A"
            ttl = 300
            records = [
                "3.128.163.7",
            ]
        },
        {
            name = "test-management"
            type = "A"
            ttl = 300
            records = [
                "3.128.163.7",
            ]
        },
        {
            name = "test-reports"
            type = "A"
            ttl = 300
            records = [
                "3.128.163.7",
            ]
        },
        {
            name = "test-shipping"
            type = "A"
            ttl = 300
            records = [
                "3.128.163.7",
            ]
        },
        {
            name = "test-tp-tracking"
            type = "A"
            ttl = 300
            records = [
                "3.21.218.80",
            ]
        },
        {
            name = "test-users"
            type = "A"
            ttl = 300
            records = [
                "3.128.163.7",
            ]
        },
        {
            name = "test2-hellofresh"
            type = "A"
            ttl = 300
            records = [
                "3.12.70.24",
            ]
        },
        {
            name = "tp-test-api"
            type = "A"
            ttl = 300
            records = [
                "3.21.218.80",
            ]
        },
        {
            name = "tp-test-carrier-api"
            type = "A"
            ttl = 300
            records = [
                "3.21.218.80",
            ]
        },
        {
            name = "tp-test-rating-api"
            type = "A"
            ttl = 300
            records = [
                "3.21.218.80",
            ]
        },
        {
            name = "tp-tracking"
            type = "A"
            ttl = 300
            records = [
                "3.21.218.80",
            ]
        },
        {
            name = "uat-carrierwebhooks"
            type = "A"
            ttl = 300
            records = [
                "3.128.163.7",
            ]
        },
        {
            name = "uat-hellofresh"
            type = "A"
            ttl = 300
            records = [
                "3.128.163.7",
            ]
        },
        {
            name = "uat-management"
            type = "A"
            ttl = 300
            records = [
                "3.128.163.7",
            ]
        },
        {
            name = "uat-reports"
            type = "A"
            ttl = 300
            records = [
                "3.128.163.7",
            ]
        },
        {
            name = "uat-shipping"
            type = "A"
            ttl = 300
            records = [
                "3.128.163.7",
            ]
        },
        {
            name = "uat-users"
            type = "A"
            ttl = 300
            records = [
                "3.128.163.7",
            ]
        },
        {
            name = "users"
            type = "A"
            ttl = 300
            records = [
                "3.12.70.24",
            ]
        },
    ]
}

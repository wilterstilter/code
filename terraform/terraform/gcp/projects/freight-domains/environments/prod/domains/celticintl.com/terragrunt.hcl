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
            type = "MX"
            ttl = 300
            records = [
                "10 us-smtp-inbound-1.mimecast.com.",
                "10 us-smtp-inbound-2.mimecast.com.",
            ]
        },
        {
            name = ""
            type = "TXT"
            ttl = 300
            records = [
                "_ir45rszm7y6zamom0dy6txv1pcnovkl",
                "0ed1fe018a234555d3e8de46c4b1caf4339305bfb8",
                "MS=ms63073458",
                "MS=ms77825073",
                "\"v=spf1 redirect=8b84vndz._spf._d.mim.ec\"",
                "globalsign-domain-verification=E542DB6836A50E2C62B37C2065E8BCCA",
                "globalsign-domain-verification=652BCD8FB5951D55DF565F5D18935D60",
                "_hspaktuufkn3ooo1nv9mv6tu3f21ijl"
            ]
        },
        {
            name = "*"
            type = "CNAME"
            ttl = 300
            records = [
                "wp.wpenginepowered.com.",
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
        {
            name = "*.celtic-uat"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.29",
            ]
        },
        {
            name = "*.dispatch"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.79",
            ]
        },
        {
            name = "*.dispatch-test"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.213",
            ]
        },
        {
            name = "*.dispatch2"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.79",
            ]
        },
        {
            name = "*.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.84",
            ]
        },
        {
            name = "*.drayweb-prod"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.80",
            ]
        },
        {
            name = "*.drayweb-test"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.214",
            ]
        },
        {
            name = "*.xpress"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.79",
            ]
        },
        {
            name = "*.xpress1"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.79",
            ]
        },
        {
            name = "*.xpress2"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.79",
            ]
        },
        {
            name = "_dmarc"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=DMARC1;\" \"p=reject;\" \"rua=mailto:0d4b78f03768934@rep.dmarcanalyzer.com;\" \"ruf=mailto:0d4b78f03768934@for.dmarcanalyzer.com;\" \"fo=1;\"",
            ]
        },
        {
            name = "_pki-validation"
            type = "TXT"
            ttl = 300
            records = [
                "47C6-03CB-EF22-6924-7CF4-9110-3E83-696C",
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
            name = "app.response"
            type = "CNAME"
            ttl = 300
            records = [
                "now.eloqua.com.",
            ]
        },
        {
            name = "autodiscover"
            type = "CNAME"
            ttl = 300
            records = [
                "autodiscover.outlook.com.",
            ]
        },
        {
            name = "blume.celtic-uat"
            type = "A"
            ttl = 300
            records = [
                "35.244.158.253",
            ]
        },
        {
            name = "carriermgt.celtic-uat"
            type = "A"
            ttl = 300
            records = [
                "35.244.158.253",
            ]
        },
        {
            name = "carriermgt.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "celchi.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "celcin.celtic-uat"
            type = "A"
            ttl = 300
            records = [
                "35.244.158.253",
            ]
        },
        {
            name = "celcin.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "celdal.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "celdeh.celtic-uat"
            type = "A"
            ttl = 300
            records = [
                "35.244.158.253",
            ]
        },
        {
            name = "celdeh.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "celdei.celtic-uat"
            type = "A"
            ttl = 300
            records = [
                "35.244.158.253",
            ]
        },
        {
            name = "celdei.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "celill.celtic-uat"
            type = "A"
            ttl = 300
            records = [
                "35.244.158.253",
            ]
        },
        {
            name = "celill.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "celjac.celtic-uat"
            type = "A"
            ttl = 300
            records = [
                "35.244.158.253",
            ]
        },
        {
            name = "celjac.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "cellat.celtic-uat"
            type = "A"
            ttl = 300
            records = [
                "35.244.158.253",
            ]
        },
        {
            name = "cellat.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "cellos.celtic-uat"
            type = "A"
            ttl = 300
            records = [
                "35.244.158.253",
            ]
        },
        {
            name = "cellos.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "celmem.celtic-uat"
            type = "A"
            ttl = 300
            records = [
                "35.244.158.253",
            ]
        },
        {
            name = "celmem.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "celnap.celtic-uat"
            type = "A"
            ttl = 300
            records = [
                "35.244.158.253",
            ]
        },
        {
            name = "celnap.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "celnat.celtic-uat"
            type = "A"
            ttl = 300
            records = [
                "35.244.158.253",
            ]
        },
        {
            name = "celnat.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "celsph.celtic-uat"
            type = "A"
            ttl = 300
            records = [
                "35.244.158.253",
            ]
        },
        {
            name = "celsph.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "celspi.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "celspr.celtic-uat"
            type = "A"
            ttl = 300
            records = [
                "35.244.158.253",
            ]
        },
        {
            name = "celspr.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "celsps.celtic-uat"
            type = "A"
            ttl = 300
            records = [
                "35.244.158.253",
            ]
        },
        {
            name = "celsps.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "celspv.celtic-uat"
            type = "A"
            ttl = 300
            records = [
                "35.244.158.253",
            ]
        },
        {
            name = "celspv.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "celspx.celtic-uat"
            type = "A"
            ttl = 300
            records = [
                "35.244.158.253",
            ]
        },
        {
            name = "celspx.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "celten.celtic-uat"
            type = "A"
            ttl = 300
            records = [
                "35.244.158.253",
            ]
        },
        {
            name = "celten.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "celtic-uat-2"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.29",
            ]
        },
        {
            name = "celtrk.celtic-uat"
            type = "A"
            ttl = 300
            records = [
                "35.244.158.253",
            ]
        },
        {
            name = "celtrk.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "cust"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.79",
            ]
        },
        {
            name = "cust.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "customer.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "devpricing"
            type = "A"
            ttl = 300
            records = [
                "10.1.104.89",
            ]
        },
        {
            name = "dispatch"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.79",
            ]
        },
        {
            name = "dispatch"
            type = "MX"
            ttl = 300
            records = [
                "50 dispatch3.celticintl.com.",
            ]
        },
        {
            name = "dispatch"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=spf1 include:spf.protection.outlook.com ip4:207.211.31.0/25 ip4:207.211.30.0/24 ip4:205.139.110.0/24 ip4:205.139.111.0/24 ip4:216.205.24.0/24 ip4:63.128.21.0/24 ip4:205.217.25.135/32 ip4:205.217.25.132/32 ip4:207.211.41.113/32 ip4:65.64.216.177/32 ip4:6\" \"\" \"5.64.216.107/32 ip4:65.64.216.108/32 ip4:65.64.216.51/32 ip4:65.64.216.52/32 ip4:65.64.216.79/32 ip4:65.64.216.84/32 ~all\"",
            ]
        },
        {
            name = "dispatch-test"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.213",
            ]
        },
        {
            name = "dispatch-test"
            type = "MX"
            ttl = 300
            records = [
                "20 dispatch-prod.celticintl.com.",
            ]
        },
        {
            name = "dispatch-test"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=spf1\" \"ip4:208.191.62.213/31\" \"mx\" \"~all\"",
            ]
        },
        {
            name = "dispatch2"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.79",
            ]
        },
        {
            name = "dispatch3"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.84",
            ]
        },
        {
            name = "dispatch3"
            type = "MX"
            ttl = 300
            records = [
                "10 dispatch3.celticintl.com.",
            ]
        },
        {
            name = "dispatch3"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=spf1 include:mail.zendesk.com include:_spf.salesforce.com include:cvent-planner.com include:spf.greatmail.com include:_spf.ultipro.com include:_spf.psm.knowbe4.com include:us._netblocks.mimecast.com ip4:54.240.8.0/24\" \" ip4:160.34.15.16/29 ip4:65.64.216.0/24 ip4:52.185.227.176/32 ip4:20.45.2.251/32 ip4:208.191.62.0/24 ~all\"",
            ]
        },
        {
            name = "dispatch3-prod"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.84",
            ]
        },
        {
            name = "dk._domainkey.response"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=DKIM1;\" \"p=MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAM1xusIe2p5oBmvP2Rgv1BOyQdr0h/TTPSE/qZ1iPmhuQLUGjvNwu+aKNRqUiByO3rlIX+TeDXJSXsYuitNT/OcCAwEAAQ==;\"",
            ]
        },
        {
            name = "drayweb-prod"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.80",
            ]
        },
        {
            name = "drayweb-test-2"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.214",
            ]
        },
        {
            name = "express"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.79",
            ]
        },
        {
            name = "express1"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.79",
            ]
        },
        {
            name = "express2"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.79",
            ]
        },
        {
            name = "images.response"
            type = "CNAME"
            ttl = 300
            records = [
                "now.eloqua.com.edgesuite.net.",
            ]
        },
        {
            name = "mail"
            type = "CNAME"
            ttl = 300
            records = [
                "outlook.office365.com.",
            ]
        },
        {
            name = "mimecast20230714._domainkey"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAt324H8zJKLTMYZRF/QyY0hqcDQzmk9KgpYKqyXjeybpMdFrHKM9+ZVqUP4hgJdBXbVpFS7iJiSmCF3bgOmCROmVOO3rgXaz0BQTQu5GjdMf/ZJI1HdYddF9zyOdxc7ewSZDc5R/6xxyqFf9hVUjjtaEOU+j6\" \"2fK1orIiJi7ikZSO3crhERcCGa2GWvz12NgzlduVu/ii2uwq0U4D7rh82fGMq/0ugraXuXXedMpvbSArcK7IPi9sAz9l6nXEM1+m8VMZzWpcWO4pe34PB+kpE7UUwjzjyZsnCR6kzMUxY6Gwf8ZxcA6S1YfyshXxnoU2p2W+IwB5elSJcjNacpYKiQIDAQAB\"",
            ]
        },
        {
            name = "nexus.dispatch2"
            type = "A"
            ttl = 300
            records = [
                "12.176.86.196",
            ]
        },
        {
            name = "offices.celtic-uat"
            type = "A"
            ttl = 300
            records = [
                "35.244.158.253",
            ]
        },
        {
            name = "offices.dispatch3"
            type = "A"
            ttl = 300
            records = [
                "34.144.227.100",
            ]
        },
        {
            name = "pricing"
            type = "A"
            ttl = 300
            records = [
                "10.1.104.88",
            ]
        },
        {
            name = "response"
            type = "MX"
            ttl = 300
            records = [
                "10 mail.en25.com.",
            ]
        },
        {
            name = "response"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=spf1\" \"include:_netblocks.eloqua.com\" \"-all\"",
            ]
        },
        {
            name = "uatpricing"
            type = "A"
            ttl = 300
            records = [
                "10.2.244.78",
            ]
        },
        {
            name = "drayweb-test"
            type = "A"
            ttl = 300
            records = [
                "34.36.179.27",
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
            name = "_acme-challenge.drayweb-new"
            type = "CNAME"
            ttl = 300
            records = [
                "2766439d-c509-4abf-a865-e20b31ebab1e.8.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "drayweb-new"
            type = "A"
            ttl = 300
            records = [
                "34.110.134.131",
            ]
        },
        {
            name = "_acme-challenge.celchi.celtic-uat"
            type = "CNAME"
            ttl = 300
            records = [
                "1ad5ed24-e470-426a-bdf5-3059b049330a.2.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "celchi.celtic-uat"
            type = "A"
            ttl = 300
            records = [
                "35.244.158.253",
            ]
        },
        {
            name = "_acme-challenge.drayweb"
            type = "CNAME"
            ttl = 300
            records = [
                "7ab2e9ae-95d9-4781-8e57-e3767c8a9ee1.1.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "_acme-challenge.celchi.dispatch3"
            type = "CNAME"
            ttl = 300
            records = [
                "995b4560-a5b8-4fe9-bd37-41cc7a741563.3.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "drayweb"
            type = "A"
            ttl = 300
            records = [
                "34.54.113.56",
            ]
        },
        {
            name = "_acme-challenge.celtic-uat"
            type = "CNAME"
            ttl = 300
            records = [
                "25098d93-5d8f-4116-9a94-056312c53984.19.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "celdal.celtic-uat"
            type = "A"
            ttl = 300
            records = [
                "35.244.158.253",
            ]
        },
        {
            name = "_acme-challenge.dispatch3"
            type = "CNAME"
            ttl = 300
            records = [
                "5864bf80-7551-4ed5-9ca7-5aafcfc05e32.1.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "drayweb"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.celticintl.com",
            ]
        },
		{
            name = "drayweb-test"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.celticintl.com",
            ]
        },
		{
            name = "celchi.celtic-uat"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.celticintl.com",
            ]
        },
		{
            name = "celchi.dispatch3"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.celticintl.com",
            ]
        },
    ]
}

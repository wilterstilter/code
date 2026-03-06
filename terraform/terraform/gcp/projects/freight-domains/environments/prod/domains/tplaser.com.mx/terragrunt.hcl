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
            name = "spf"
            type = "TXT"
            ttl  = 300
            records = [
              "\"v=spf1 include:spf.protection.outlook.com include:include:_netblocks.mimecast.com ip4:65.64.216.0/24 ip4:208.191.62.0/24 ~all\"",
            ]
        },
        {
            name = ""
            type = "TXT"
            ttl  = 300
            records = [
              "_ljiex7iw5v3s7wrory7azwfvwqqljsc",
              "0ed1fe018ad3890d754aff4c70ad1c6ec3723681e2",
              "\"v=spf1 redirect=2dmkyjkm._spf._d.mim.ec\"",
              "MS=ms39955882",
              "apple-domain-verification=lVaywdIGv0LQCZMI",
              "google-site-verification=RFASBKiNF4NEpkDhJGYVzt_UQFabWQfVQS7b2zI5lDk",
              "google-site-verification=cp3ySyyUQoQs95xdSunCCco836vPtp3CPcujsh09CAA",
              "globalsign-domain-verification=77EB694617B0D82DB4FCA7919127A892",
              "_9c72xw2jefe2qdh33n3g8upyrI9njy7",
              "_hh8qncta9o39vcbc9r18o0m84f8558u",
              "globalsign-domain-verification=E0791CD4E201A44BB642485FE9EBC6F0",
              "atlassian-domain-verification=ixyrkFB6BMmquFjlFadP7eRrTcOwEPFRJ0DsRKC74QMieWQohidyScTaWEidLNBm",
            ]
        },
        {
            name = "_dmarc"
            type = "TXT"
            ttl  = 300
            records = [
              "\"v=DMARC1;p=reject;fo=1\"",
            ]
        },
        {
            name = "_pki-validation"
            type = "TXT"
            ttl  = 300
            records = [
              "8E35-A228-1228-3F23-EB97-F244-6BB1-871F",
            ]
        },
        {
            name = "pic._domainkey"
            type = "TXT"
            ttl  = 300
            records = [
              "\"k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAnRp24iCgKjag+V4EeaD1YkHZcTJeW96qjN5ipHx8UKQ4YaP5tNXK3pfizhc9++l65Ed8urrL68XG0H2KGBQD0RqgKhMQOQAzCP7ZHHohdHKoIioyCAJBuq6TolKoT6ihizvKZ+mKnanXkfgvYRzMqbhfI4df79foKfldWxBm2o8Ebar0aejcZz3\" \"PG8d3VcMwsIgW9zx38ofcnwr1OnDif7iQl6KkNuTMn/E9WOmMMb3ZOd11u3BcF1ZLQzEjJRhJEKw6H3UpMLZ8pnB9jpIgvrwdxb7mlY8jgNG7W8L/EJqOP/Av1NXeaXImEHsc3RdPgF2//aWHrCPUWYIVYLI5NwIDAQAB\"",
            ]
        },
        {
            name = "mimecast20240404._domainkey"
            type = "TXT"
            ttl  = 300
            records = [
              "\"v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApR/6BRyDEfY2WHAqjN3wQS6RkCgEwUZHYMSAO0tr9Vze0EoME0zfxrPotPrjeeTmFtCVD6y6R5ZblGs5Oc21I0YxkPFfGqA4Jq/oS8rYAIOJXX7Dse430HuXbmpE6A3QXbx/0eqvDObzjMpJx99nkh5F1qo5036FoPQMhuhVUK8EHjk4\" \"pq42LNYZzFSWuTSRrEssPhrRSVvMb7h69QPzcfYoXcP4DPEvXPazyZw47FPR/wHgO545/YpDscen5oxbGDXxgpgnb11Tn113jTPPxCv+/9Tl1xqWfoWn5CeQJeYSGZdNB5a9Zukj83i9XUd54KyamjSBtdLpFfekYN/xoQIDAQAB\"",
            ]
        },
        {
            name = "c6ec3723681e2"
            type = "CNAME"
            ttl  = 300
            records = [
                "validate-domain.mimecast.com.",
            ]
        },
        {
            name = "uat"
            type = "CNAME"
            ttl  = 300
            records = [
                "uattplaser.azureedge.net.",
            ]
        },
        {
            name = "www"
            type = "CNAME"
            ttl  = 300
            records = [
                "tplaser.azureedge.net.",
            ]
        },
        {
            name = "uatcarrierdb"
            type = "A"
            ttl  = 300
            records = [
                "40.119.7.124",
            ]
        },
        {
            name = "uatcustomsportalapi"
            type = "A"
            ttl  = 300
            records = [
                "208.191.62.210",
            ]
        },
        {
            name = "ftplaser"
            type = "A"
            ttl  = 300
            records = [
                "52.249.63.168",
                "40.74.176.197",
            ]
        },
        {
            name = "ftp2laser"
            type = "A"
            ttl  = 300
            records = [
                "52.249.63.168",
                "40.74.176.197",
            ]
        },
        {
            name = "agrqgxthymdtvd3gwhq5vkb6oovsruw4._domainkey"
            type = "CNAME"
            ttl  = 300
            records = [
                "agrqgxthymdtvd3gwhq5vkb6oovsruw4.dkim.amazonses.com.",
            ]
        },
        {
            name = "akvnxb2e6ibh7seyu26p2s4rpd63aos6._domainkey"
            type = "CNAME"
            ttl  = 300
            records = [
                "akvnxb2e6ibh7seyu26p2s4rpd63aos6.dkim.amazonses.com.",
            ]
        },
        {
            name = "znph5v7ehzdeatfdprvvu44r5hnqqlea._domainkey"
            type = "CNAME"
            ttl  = 300
            records = [
                "znph5v7ehzdeatfdprvvu44r5hnqqlea.dkim.amazonses.com.",
            ]
        },
        {
            name = "newsletters"
            type = "MX"
            ttl  = 300
            records = [
                "10 feedback-smtp.us-east-1.amazonses.com.",
            ]
        },
        {
            name = "newsletters"
            type = "TXT"
            ttl  = 300
            records = [
                "\"v=spf1 include:amazonses.com ~all\"",
            ]
        },
        {
            name = ""
            type = "MX"
            ttl  = 300
            records = [
                "10 us-smtp-inbound-1.mimecast.com.",
                "10 us-smtp-inbound-2.mimecast.com.",
            ]
        },
        {
            name = "_acme-challenge.uatcustomsportal"
            type = "CNAME"
            ttl = 300
            records = [
                "020e273d-9c32-414c-a456-b2940ab45b31.0.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "uatcustomsportal"
            type = "A"
            ttl  = 300
            records = [
                "34.36.44.109",
            ]
        },
        {
            name = "_acme-challenge.uatcustomswmsapi"
            type = "CNAME"
            ttl = 300
            records = [
                "dceec530-1b41-4a79-b0ca-c5a5bf5d5d00.10.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "uatcustomswmsapi"
            type = "A"
            ttl  = 300
            records = [
                "34.120.172.198",
            ]
        },
        {
            name = "_acme-challenge.uatlaser"
            type = "CNAME"
            ttl = 300
            records = [
                "cc566733-5b3c-4ec2-a14f-84afde7a6f3f.12.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "_acme-challenge.uatapps9"
            type = "CNAME"
            ttl  = 300
            records = [
                "6291e7d2-aec4-4a26-bade-b866ed15e0f4.17.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "uatapps9"
            type = "A"
            ttl  = 300
            records = [
                "34.160.221.193",
            ]
        },
        {
            name = "uatlaser"
            type = "A"
            ttl  = 300
            records = [
                "34.149.135.118",
            ]
        },
        {
            name = "_acme-challenge.customswmsapi"
            type = "CNAME"
            ttl = 300
            records = [
                "270ade38-63b9-4bb2-9364-88a16cde335e.9.authorize.certificatemanager.goog.",
            ]
        },
         {
            name = "customswmsapi"
            type = "A"
            ttl  = 300
            records = [
                "34.111.246.73",
            ]
        },
        {
            name = "_acme-challenge.apps9"
            type = "CNAME"
            ttl  = 300
            records = [
                "b791a4c0-3b87-47a7-8e51-7b9c280f14ce.14.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "_acme-challenge.customsportal"
            type = "CNAME"
            ttl = 300
            records = [
                "2c460ffe-fa91-42a4-823d-77452cffbe79.14.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "_acme-challenge.laser"
            type = "CNAME"
            ttl = 300
            records = [
                "439f95f2-4f7f-42e3-9a55-282aae53c132.9.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "laser"
            type = "A"
            ttl  = 300
            records = [
                "34.117.148.115",
            ]
        },
        {
            name = "customsportal"
            type = "A"
            ttl  = 300
            records = [
                "34.8.115.114",
            ]
        },
        {
            name = "apps9"
            type = "A"
            ttl  = 300
            records = [
                "35.201.107.135",
            ]
        },
        {
            name = "customsportal"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.tplaser.com.mx",
            ]
        },
		{
            name = "apps9"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.tplaser.com.mx",
            ]
        },
		{
            name = "laser"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.tplaser.com.mx",
            ]
        },
		{
            name = "uatapps9"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.tplaser.com.mx",
            ]
        },
		{
            name = "uatcustomsportal"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.tplaser.com.mx",
            ]
        },
    ]
}

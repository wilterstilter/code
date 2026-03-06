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
                "_u5zcrgk9dlz8vi5yvxrliwmugf1l5js",
                "MS=ms86600366",
                "rHdDGRagssVAYVyiLhb5gdJMzmfgqo3fgZBMj9V7l9hqBYClAMr36VN1sSc3PWhXakJYPxzh7J9mEzMds/vs2Q==",
                "\"v=spf1 redirect=629d6y7d._spf._d.mim.ec\"",
                "google-site-verification=mPyVh3nh7IYszlFkIlIOP1I0Zo_hnQcHj3i2Q-zrHlA",
                "globalsign-domain-verification=C3EF32E5BC2936F6072D48416DD7D860",
                "globalsign-domain-verification=3C7BCFC9936E123C8AB4FBE48D3EBEB0",
                "uber-domain-verification=9f4ec69e-20c1-4018-8f56-829a78c0dbee",
                "apple-domain-verification=h6X0TM1UKeTXpWQ5",
                "google-site-verification=qBRKjH6qxO_R4rARvsmTD_f5M9qyPt7-ikkX_GfMi6M",
                "atlassian-domain-verification=ixyrkFB6BMmquFjlFadP7eRrTcOwEPFRJ0DsRKC74QMieWQohidyScTaWEidLNBm",
                "ZOOM_verify_l6gFlrN5bjtri6EE69ojIy",
                "paloaltonetworks-site-verification=39905a28fb65225f67fdaa63b7d8564b303463e143011fe977494632844967a7",
                "_x4gct9633kto3zhoct2qb11l60suwso",
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
            name = "customsportal"
            type = "CNAME"
            ttl = 300
            records = [
                "43rbgkg.impervadns.net.",
            ]
        },
        {
            name = "_dmarc"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=DMARC1; p=reject; rua=mailto:0d4b78f03768934@rep.dmarcanalyzer.com; ruf=mailto:0d4b78f03768934@for.dmarcanalyzer.com; fo=1;\"",
            ]
        },
        {
            name = "_f1afe1c384b997c5000a9ff7dbcb3fc7.resources"
            type = "CNAME"
            ttl = 300
            records = [
                "_d9af532d3daa6b825dc71aa4b734041a.lblqlwmygg.acm-validations.aws.",
            ]
        },
        {
            name = "_github-challenge-uber-freight-os-ent"
            type = "TXT"
            ttl = 300
            records = [
                "69761f17e1",
            ]
        },
        {
            name = "tms3._domainkey.tms"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApxUa89OWMY7CCS/q81CyafSp+pOLeqNZ303DIK9oS/KPmX9wGRT6c4oOsO5ozLRbsyxw3U4LOZBiPkustCEZqvl4IbIJbtfzivwUJIA+x+FMfekQLl+G1thMhJlXIZHJAYRKGlOga8jSj/+6WWjLLq4pspL6WgauU5EcdNldHerAFFfak+F7yRfh\" \"8baYv96GkrPElesYHpdSNIZ3rUNiyZ0HziKyM3whd6w9adcXVq5vvfPKKLQ1NP3DWrTPqvbfpdntB/1fRmRosx7lo6+IK7dvY9d+8m7rIV3CLDGzWp3miTHeChs3xiduNJtlbx1Kud8kcc1vXWRbDYsl/8BkXwIDAQAB\"",
            ]
        },
        {
            name = "dk._domainkey.response"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=DKIM1; p=MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAM1xusIe2p5oBmvP2Rgv1BOyQdr0h/TTPSE/qZ1iPmhuQLUGjvNwu+aKNRqUiByO3rlIX+TeDXJSXsYuitNT/OcCAwEAAQ==;\"",
            ]
        },
        {
            name = "dk1024-2012._domainkey.response"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=DKIM1;p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC1TaNgLlSyQMNWVLNLvyY/neDgaL2oqQE8T5illKqCgDtFHc8eHVAU+nlcaGmrKmDMw9dbgiGk1ocgZ56NR4ycfUHwQhvQPMUZw0cveel/8EAGoi/UyPmqfcPibytH81NFtTMAxUeM4Op8A6iHkvAMj5qLf4YRNsTkKAVmJ5jEZwIDAQAB;\"",
            ]
        },
        {
            name = "_xmpp-server._tcp"
            type = "SRV"
            ttl = 300
            records = [
                "0 0 5269 sip.transplace.com.",
            ]
        },
        {
            name = "adhocreports"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.229",
            ]
        },
        {
            name = "alphaapi"
            type = "CNAME"
            ttl = 300
            records = [
                "transplace-uat.apigee.net.",
            ]
        },
        {
            name = "alphatmsservices"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.168",
            ]
        },
        {
            name = "api"
            type = "CNAME"
            ttl = 300
            records = [
                "transplace-prod.apigee.net.",
            ]
        },
        {
            name = "apigee"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.155",
            ]
        },
        {
            name = "apps9"
            type = "CNAME"
            ttl = 300
            records = [
                "ohy769m.impervadns.net.",
            ]
        },
        {
            name = "as2"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.187",
            ]
        },
        {
            name = "as2qa"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.106",
            ]
        },
        {
            name = "as2test"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.111",
            ]
        },
        {
            name = "assets"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.50",
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
            name = "azacmgvp01"
            type = "CNAME"
            ttl = 300
            records = [
                "azacmgvp01.southcentralus.cloudapp.azure.com.",
            ]
        },
        {
            name = "azureappgw"
            type = "A"
            ttl = 300
            records = [
                "40.124.81.71",
            ]
        },
        {
            name = "b2b"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.49",
            ]
        },
        {
            name = "b2b-c"
            type = "CNAME"
            ttl = 300
            records = [
                "dne4cte.transplace.com.",
            ]
        },
        {
            name = "b2b-test"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.104",
            ]
        },
        {
            name = "b2bas2-test"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.165",
            ]
        },
        {
            name = "b2bdev"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.30",
            ]
        },
        {
            name = "b2btest"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.36",
            ]
        },
        {
            name = "basf"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.60",
            ]
        },
        {
            name = "bireports"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.228",
            ]
        },
        {
            name = "bireportssso"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.179",
            ]
        },
        {
            name = "blog"
            type = "A"
            ttl = 300
            records = [
                "34.71.82.88",
            ]
        },
        {
            name = "blogs"
            type = "CNAME"
            ttl = 300
            records = [
                "blog.transplace.com.",
            ]
        },
        {
            name = "carrierftp"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.201",
            ]
        },
        {
            name = "confluent"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.155",
            ]
        },
        {
            name = "cr5pnelzfb5z"
            type = "CNAME"
            ttl = 300
            records = [
                "gv-bs4ojrjqtxibeg.dv.googlehosted.com.",
            ]
        },
        {
            name = "crl"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.226",
            ]
        },
        {
            name = "crossroads"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.165",
            ]
        },
        {
            name = "csftp"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.193",
            ]
        },
        {
            name = "csftptest"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.178",
            ]
        },
        {
            name = "cte"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.157",
            ]
        },
        {
            name = "customer"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.103",
            ]
        },
        {
            name = "customertest"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.176",
            ]
        },
        {
            name = "customeruat"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.165",
            ]
        },
        {
            name = "customs"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.167",
            ]
        },
        {
            name = "custserv"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.105",
            ]
        },
        {
            name = "demo"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.81",
            ]
        },
        {
            name = "dev"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.146",
            ]
        },
        {
            name = "devapi"
            type = "CNAME"
            ttl = 300
            records = [
                "transplace-staging.apigee.net.",
            ]
        },
        {
            name = "devblog"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.145",
            ]
        },
        {
            name = "devbrokerage"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.181",
            ]
        },
        {
            name = "devcrossroads"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.172",
            ]
        },
        {
            name = "devdocs"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.146",
            ]
        },
        {
            name = "developer"
            type = "CNAME"
            ttl = 300
            records = [
                "developer.uberfreight.com.",
            ]
        },
        {
            name = "devextranet"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.74",
            ]
        },
        {
            name = "devextranetsaml"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.179",
            ]
        },
        {
            name = "devinternational"
            type = "A"
            ttl = 300
            records = [
                "34.120.155.82",
            ]
        },
        {
            name = "devlogisticallyspeaking"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.189",
            ]
        },
        {
            name = "devmsoffice"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.148",
            ]
        },
        {
            name = "devmy"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.74",
            ]
        },
        {
            name = "devptmsdirect"
            type = "A"
            ttl = 300
            records = [
                "20.118.93.8",
            ]
        },
        {
            name = "devsaml"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.133",
            ]
        },
        {
            name = "devsec"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.155",
            ]
        },
        {
            name = "devsvc"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.146",
            ]
        },
        {
            name = "devtmsauth"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.110",
            ]
        },
        {
            name = "devwac"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.180",
            ]
        },
        {
            name = "devwms"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.109",
            ]
        },
        {
            name = "devwmsgateway"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.109",
            ]
        },
        {
            name = "devwww"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.146",
            ]
        },
        {
            name = "directaccess"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.10",
            ]
        },
        {
            name = "dne4cte"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.212",
            ]
        },
        {
            name = "dne4dev"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.130",
            ]
        },
        {
            name = "dne4test"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.164",
                "208.191.62.27",
            ]
        },
        {
            name = "dne5"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.214",
            ]
        },
        {
            name = "dne5web"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.28",
            ]
        },
        {
            name = "docs"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.163",
            ]
        },
        {
            name = "doos"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.30",
            ]
        },
        {
            name = "drftp"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.29",
            ]
        },        
        {
            name = "dura"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.101",
            ]
        },
        {
            name = "dura2"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.102",
            ]
        },
        {
            name = "dwex13vp01"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.177",
            ]
        },
        {
            name = "dwex13vp02"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.107",
            ]
        },
        {
            name = "dwmailvp01"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=spf1 ip4:65.64.216.0/24 ~all\"",
            ]
        },
        {
            name = "dwmailvp01"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.40",
            ]
        },
        {
            name = "dwmailvp02"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=spf1 ip4:65.64.216.0/24 ~all\"",
            ]
        },
        {
            name = "dwmailvp02"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.41",
            ]
        },
        {
            name = "dwmailvp03"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.42",
            ]
        },
        {
            name = "dwmailvp04"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.43",
            ]
        },
        {
            name = "dwmailvp1"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=spf1 ip4:65.64.216.0/24 ~all\"",
            ]
        },
        {
            name = "dwmailvp1"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.51",
            ]
        },
        {
            name = "dwmailvp2"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=spf1 ip4:65.64.216.0/24 ~all\"",
            ]
        },
        {
            name = "dwmailvp2"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.52",
            ]
        },
        {
            name = "email"
            type = "CNAME"
            ttl = 300
            records = [
                "email.mg.transplace.com.",
            ]
        },
        {
            name = "engineering"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.78",
            ]
        },
        {
            name = "enterpriseenrollment"
            type = "CNAME"
            ttl = 300
            records = [
                "enterpriseenrollment-s.manage.microsoft.com.",
            ]
        },
        {
            name = "enterpriseregistration"
            type = "CNAME"
            ttl = 300
            records = [
                "enterpriseregistration.windows.net.",
            ]
        },
        {
            name = "exchbe4"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.208",
            ]
        },
        {
            name = "extranet2012"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.228",
            ]
        },
        {
            name = "fam"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.166",
            ]
        },
        {
            name = "famtest"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.168",
            ]
        },
        {
            name = "ftp"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.131",
            ]
        },
        {
            name = "ftplaser"
            type = "A"
            ttl = 300
            records = [
                "52.249.63.168",
                "40.74.176.197",
            ]
        },
        {
            name = "ftpqa"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.105",
            ]
        },
        {
            name = "getaquote"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.155",
            ]
        },
        {
            name = "globalconnect"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.64",
            ]
        },
        {
            name = "globalconnect2"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.64",
            ]
        },
        {
            name = "hackathon"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.155",
            ]
        },
        {
            name = "hosttp"
            type = "A"
            ttl = 300
            records = [
                "192.252.89.92",
            ]
        },
        {
            name = "ieftpuat"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.167",
            ]
        },
        {
            name = "imail"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.150",
            ]
        },
        {
            name = "ipttest"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.96",
            ]
        },
        {
            name = "k1._domainkey.mg"
            type = "TXT"
            ttl = 300
            records = [
                "\"k=rsa;\" \"p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDM8Ky+Px1/zBvlA6VCup1Oj4WT+mCPb+ezL/mHNn2L9kvTmFNP13RNhOTmkroCqB3BRbuqO5TcSeyOWMuNeHFHOdk6oftx+TblO5/tx69mfdCI26u/tZfKh+IX9c6go7BD/znWkW3YlxirRwexLyNWtzMPkKPsaGxArg8X4MhbpwIDAQAB\"",
            ]
        },
        {
            name = "kb"
            type = "CNAME"
            ttl = 300
            records = [
                "www.transplace.com.",
            ]
        },
        {
            name = "legacy"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.198",
            ]
        },
        {
            name = "localhost"
            type = "A"
            ttl = 300
            records = [
                "127.0.0.1",
            ]
        },
        {
            name = "login"
            type = "CNAME"
            ttl = 300
            records = [
                "transplace.com.",
            ]
        },
        {
            name = "logisticallyspeaking"
            type = "A"
            ttl = 300
            records = [
                "34.71.82.88",
            ]
        },
        {
            name = "loopback"
            type = "CNAME"
            ttl = 300
            records = [
                "localhost.transplace.com.",
            ]
        },
        {
            name = "loos"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.209",
            ]
        },
        {
            name = "lowellda"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.25",
            ]
        },
        {
            name = "lspdnsp1"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.50",
            ]
        },
        {
            name = "lspdnsp2"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.60",
            ]
        },
        {
            name = "lura"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.101",
            ]
        },
        {
            name = "lwex13vp01"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.160",
            ]
        },
        {
            name = "lwex13vp02"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.161",
            ]
        },
        {
            name = "lwex13vp03"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.162",
            ]
        },
        {
            name = "lwmailvu1"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.235",
            ]
        },
        {
            name = "lwmailvu2"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.236",
            ]
        },
        {
            name = "mail"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.31",
            ]
        },
        {
            name = "mailstop2"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.80",
            ]
        },
        {
            name = "media"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.155",
            ]
        },        
        {
            name = "mg"
            type = "MX"
            ttl = 300
            records = [
                "10 mxb.mailgun.org.",
                "10 mxa.mailgun.org.",
            ]
        },
        {
            name = "mg"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=spf1 include:mailgun.org ~all\"",
            ]
        },
        {
            name = "mobile"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.30",
            ]
        },
        {
            name = "mqipt"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.221",
            ]
        },
        {
            name = "msoffice"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.164",
            ]
        },
        {
            name = "nonprod-azureappgw"
            type = "A"
            ttl = 300
            records = [
                "40.119.48.72",
            ]
        },
        {
            name = "ns1"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.133",
            ]
        },
        {
            name = "ns2"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.112",
            ]
        },
        {
            name = "o365"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.106",
                "208.191.62.104",
            ]
        },
        {
            name = "ocpp"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.44",
            ]
        },
        {
            name = "ocpu"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.237",
            ]
        },
        {
            name = "oidc"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.156",
            ]
        },
        {
            name = "outreach"
            type = "CNAME"
            ttl = 300
            records = [
                "e078edd5-4da1-4918-ac57-46294852fbd8.outrch.com.",
            ]
        },
        {
            name = "partner"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.104",
            ]
        },
        {
            name = "partnertest"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.177",
            ]
        },
        {
            name = "partneruat"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.166",
            ]
        },
        {
            name = "passwordreset"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.48",
            ]
        },
        {
            name = "passwordresetregistration"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.48",
            ]
        },
        {
            name = "pki"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.33",
            ]
        },
        {
            name = "pki2016"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.33",
            ]
        },
        {
            name = "pmo"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.142",
            ]
        },
        {
            name = "prd-mailrelay"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.55",
            ]
        },
        {
            name = "quote"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.155",
            ]
        },
        {
            name = "ratemanager"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.159",
            ]
        },
        {
            name = "rdsgateway"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.99",
            ]
        },
        {
            name = "registry"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.108",
            ]
        },
        {
            name = "remote"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.251",
            ]
        },
        {
            name = "remote1"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.248",
            ]
        },
        {
            name = "remoteapps"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.232",
            ]
        },
        {
            name = "reports"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.74",
            ]
        },
        {
            name = "reports5"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.211",
            ]
        },
        {
            name = "resources"
            type = "CNAME"
            ttl = 300
            records = [
                "rr-resources-transplace-com.getbynder.com.",
            ]
        },
        {
            name = "sip"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.24",
                "65.64.216.26",
            ]
        },
        {
            name = "smtp2"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.209",
                "65.64.216.210",
            ]
        },
        {
            name = "stagingapi"
            type = "CNAME"
            ttl = 300
            records = [
                "transplace-staging.apigee.net.",
            ]
        },
        {
            name = "stuttgartimg"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.192",
            ]
        },
        {
            name = "sucusttest"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.163",
            ]
        },
        {
            name = "suparttest"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.164",
            ]
        },
        {
            name = "svc"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.163",
            ]
        },
        {
            name = "symposium"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.155",
            ]
        },
        {
            name = "symposium2011"
            type = "A"
            ttl = 300
            records = [
                "174.122.37.130",
            ]
        },
        {
            name = "symposium2012"
            type = "A"
            ttl = 300
            records = [
                "174.122.37.130",
            ]
        },
        {
            name = "tableau"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.56",
            ]
        },
        {
            name = "techconnect"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.61",
            ]
        },
        {
            name = "testapi"
            type = "CNAME"
            ttl = 300
            records = [
                "transplace-uat.apigee.net.",
            ]
        },
        {
            name = "testcsftp"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.98",
            ]
        },
        {
            name = "testdat"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.174",
            ]
        },
        {
            name = "testextranet"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.117",
            ]
        },
        {
            name = "testsafetysystems"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.153",
            ]
        },
        {
            name = "tmsauth"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.151",
            ]
        },
        {
            name = "tmsdemo"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.26",
            ]
        },
        {
            name = "tmsinfohub"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.74",
            ]
        },
        {
            name = "tmslogin"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.116",
            ]
        },
        {
            name = "tms-staging"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "tms-uat"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "tmsuat"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.200",
            ]
        },
        {
            name = "tpappdev"
            type = "A"
            ttl = 300
            records = [
                "192.252.89.61",
            ]
        },
        {
            name = "tplaser"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.186",
            ]
        },
        {
            name = "tpmail"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.198",
            ]
        },
        {
            name = "tpsna01"
            type = "A"
            ttl = 300
            records = [
                "192.252.89.90",
            ]
        },
        {
            name = "tpsna02"
            type = "A"
            ttl = 300
            records = [
                "192.252.89.91",
            ]
        },
        {
            name = "tpsrv00"
            type = "A"
            ttl = 300
            records = [
                "192.252.89.100",
            ]
        },
        {
            name = "tpsrv01"
            type = "A"
            ttl = 300
            records = [
                "192.252.89.101",
            ]
        },
        {
            name = "tpvpn"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.10",
            ]
        },
        {
            name = "translate"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.81",
            ]
        },
        {
            name = "uat"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.138",
            ]
        },
        {
            name = "uatapi"
            type = "CNAME"
            ttl = 300
            records = [
                "transplace-uat.apigee.net.",
            ]
        },
        {
            name = "uatbasf"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.199",
            ]
        },
        {
            name = "uatbireports"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.123",
            ]
        },
        {
            name = "uatbireportssso"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.23",
            ]
        },
        {
            name = "uatblog"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.137",
            ]
        },
        {
            name = "uatcarrierdb"
            type = "CNAME"
            ttl = 300
            records = [
                "gvby6g5.ng.impervadns.net.",
            ]
        },
        {
            name = "uatcrossroads"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.173",
            ]
        },
        {
            name = "uatcustoms"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.71",
            ]
        },
        {
            name = "uatcustomsportalapi"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.210",
            ]
        },
        {
            name = "uatcustomswmsapi"
            type = "CNAME"
            ttl = 300
            records = [
                "9sn87e8.impervadns.net.",
            ]
        },
        {
            name = "uatdocs"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.137",
            ]
        },
        {
            name = "uatextranet"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.72",
            ]
        },
        {
            name = "uatextranet2012"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.117",
            ]
        },
        {
            name = "uatextranet2013"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.77",
            ]
        },
        {
            name = "uatimaging"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.124",
            ]
        },
        {
            name = "uatlogisticallyspeaking"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.137",
            ]
        },
        {
            name = "uatmsoffice"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.139",
            ]
        },
        {
            name = "uatmy"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.72",
            ]
        },
        {
            name = "uatoidc"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.149",
            ]
        },
        {
            name = "uatptmsdirect"
            type = "A"
            ttl = 300
            records = [
                "20.118.126.226",
            ]
        },
        {
            name = "uatratemanager"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.184",
            ]
        },
        {
            name = "uatrdsgateway"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.241",
            ]
        },
        {
            name = "uatremoteapps"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.118",
            ]
        },
        {
            name = "uatreports"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.123",
            ]
        },
        {
            name = "uatsvc"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.138",
            ]
        },
        {
            name = "uattableau"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.188",
            ]
        },
        {
            name = "uattmsauth"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.109",
            ]
        },
        {
            name = "uattmslogin"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.128",
            ]
        },
        {
            name = "uatwac"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.117",
            ]
        },
        {
            name = "uatweb"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.24",
            ]
        },
        {
            name = "uatwww"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.137",
            ]
        },
        {
            name = "ucupdates-r2"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.239",
            ]
        },
        {
            name = "ultipro"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.73",
            ]
        },
        {
            name = "vendorconnect"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.37",
            ]
        },
        {
            name = "vendorconnect2"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.65",
            ]
        },
        {
            name = "vpn"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.251",
            ]
        },
        {
            name = "vsftp"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.36",
            ]
        },
        {
            name = "vsftpu"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.58",
            ]
        },
        {
            name = "w1"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.193",
            ]
        },
        {
            name = "w2"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.194",
            ]
        },
        {
            name = "w3"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.195",
            ]
        },
        {
            name = "w4"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.196",
            ]
        },
        {
            name = "weblink"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.250",
            ]
        },
        {
            name = "webmaintenance"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.49",
            ]
        },
        {
            name = "webtest"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.149",
            ]
        },
        {
            name = "wms"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.141",
            ]
        },
        {
            name = "wmscustomer"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.225",
            ]
        },
        {
            name = "wts01"
            type = "A"
            ttl = 300
            records = [
                "192.252.89.51",
            ]
        },
        {
            name = "wts02"
            type = "A"
            ttl = 300
            records = [
                "192.252.89.52",
            ]
        },
        {
            name = "wts03"
            type = "A"
            ttl = 300
            records = [
                "192.252.89.53",
            ]
        },
        {
            name = "wts04"
            type = "A"
            ttl = 300
            records = [
                "192.252.89.54",
            ]
        },
        {
            name = "wtst1"
            type = "A"
            ttl = 300
            records = [
                "192.252.89.56",
            ]
        },
        {
            name = "ww1"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.20",
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
            name = "xmpp"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.26",
                "65.64.216.24",
            ]
        },
        {
            name = "zendeskverification"
            type = "TXT"
            ttl = 300
            records = [
                "2a6408795e382133",
                "e7b83adbcbfd0216",
                "1bf59202c0abaef2",
                "11024bcd75321efa",
            ]
        },
        {
            name = "ukg25470458._domainkey"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=DKIM1; t=s; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1Sagz6i7A9M9D80KTab\" \"c2oYsvq+j7ptdKtfLaTRSRZ8k5WFOkFlnG3nR5ImK/nMPCr9tRdaVC4beMlFglDS4qFNqbx3DrlTGkKrBdRMDWnAa6PjAoTtJo132GD9G2w/i7WocuPbfcfL4ZA1n2FB\" \"XpkmJl8U4Pi71gBEGXzsIsHYNuemzQJgui2UKX6IFGMoML4H3mgMV3sW7VVjfy1cBcrhP4YU3f6KWs/7LWRJ8NsDjaD9JM/1M44hx6uxl8QUyNZI0Cg/sjOC53LUgJ/4\" \"5KThgmLdeRizMLpZELOv4vxYChLFBdQAmCFExeH91hM1Lg561kSq+K8D7rquPEBWxNQIDAQAB\"",
            ]
        },
        {
            name = "tms2._domainkey"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=DKIM1;\" \"k=rsa;\" \"p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC6XHpk+G517Wz9qFn5hdIhVS3J+r9rp9O+Pzsj8omPYV8GgaZ1v+GZaUC+pgt47WNSTzfu6YC6iohIaw7TYycWIp/TlTn5ZPrGig80al5e4wmZBT/NpFHE9lIEFA/pxxeT2pRHy/yAnMAs6Q8af2TroffwYm5edO+sGZj1sAFQTwIDAQAB\"",
            ]
        },
        {
            name = "tk1._domainkey"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=DKIM1;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAttZV4Zy4lD3r/ocrGNBUHFMP+D+NcvFSTOrKjN71Y6AtbPOU7UNxxUdpHZhWxW7ktQaNkeS3zVQRXDN7PF4nL4yVFhG2X1z6ptTauqBeM/zjSZvEbbpjjWvJFalpfhY3sAdnpk6CH\" \"P8aq3n3/7vcIjw67QrHmY48w3LqxEVZF4Ac+kKObuTWK8e3N87GrADbqjm0jF5r0g1O61vy7noy4umhL9OvpdHKIp7Vzat68MdpAAXpqTNEmlOc4+0Ug3IXFZqoyue4cE9PB4cTakl2FmULxMiuurhQnoGLcJhQOQ84pX53coAwib5By4vGeJfAv9z68W0275Qg2\" \" ImzUAsapQIDAQAB\"",
            ]
        },
        {
            name = "mimecast20240328._domainkey"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAjiaBB05xUqmHnbdKRVtRDp0ROBIuvE0KVLzUBeGXofQiXXigTcUTUIwyGxttGPqR+1pwfA1Shb3C++hKaD+OCxQyTJtTBVFPSvwzzzEJEP9FU7B4iSSyhkE8JYdd5UCWNfOz0CrZeSMmAAzHP5Y0Py+\" \"m6c5CHHu4NjrCUeySNwXowgL/eKD4mfP3u/G2RnGtVHA8Kp5wa4xYk0oRKD8R50CfkFM1intv8cWXfPay25TGtuY7CN5boxQg08C1AziDzKHVkhXEVahrIGyIq334OKyyfx7PZN2ij85FSkpdiEnr7s8tYYPhRMgULKrcNAljuwRwsWh0ok6HTHsNS3zsgwIDAQAB\"",
            ]
        },
        {
            name = "mail._domainkey"
            type = "TXT"
            ttl = 300
            records = [
                "\"k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDRzCfkq+2lwJP9iQeiDjGxX4XkKAqZdEYuj+IpJ50x7zuaqbMIaGS+gB8gQ6FEPglHcoPKdLubJnxUGKbEL94j6DDUgD2tBfGbmFbG7GcAFo0Yh9QSsZuJtHCEjpcHhAIM9aUbjqFg1Iswu1fPi41TzkBAnOqC5AtFs457R2knFQIDAQAB\"",
            ]
        },
        {
            name = "ea-tp._domainkey"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzMT6NLTOIj4leTlv6jy3G6AQWRq7Fgp6Cx9IZTuWe3ZzZPYFKEx5P1cMerSA5FEcgKbPxQrQGQLJrC7WlemmOHsz/91H6allwVRCoXzFacfFHsk3CjtMFSGqi5qcBxc/jiV0iM6cj\" \"+kLatITKld8nA40u/gyMg6z4kIscCXsAGKKWmEIqBFQKZjQliIqBfq+LeJ5nox3OtNkj84pxBe+/u2ri1ZE+ZeQOJGu3mgI/vlw8bAj8aGOEJnzy5SGi+jForjRjI0Dk29B6JiLX4c0d+xFt8mrdW53TCaEzD/oe1biXI+Ts1RPJeaZadiFarAcVKq8ou774nYOqgitPzlRNQIDAQAB\"",
            ]
        },
        {
            name = "domainkey.transplace.com._domainkey"
            type = "TXT"
            ttl = 300
            records = [
                "\"k=rsa; t=y; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0pWGgRNgyXK62cZIw71eMEOo3rkEXUULbMiWjlRLl90A4jHqIuR4A3mS/2s5GwM6ERzHuw4T1oCilEIcN+vYv4zjIV9Y78B7CvMaojrDA41g1eXId7B3tyAd8zbpp7zw2l+qpDPSjOLpLHB3WQZFgKhp4NppBXAADcfZE4NhPeiy7z2\" \"NWXxsc7IX9cAHVv+yAApH7+uk3Tk07xO5yZsjnbj6DqVj0Cm9itaKn8X8oyX7tNpB3M+xk5c/RycGard7dQZahXT9F9PFSnJOb0TbktPjt2IcrAd23LvaHPokLUVZNuIUb8orCTCwhREEs+V9cyAvotaOBYHhEs6RokoQXwIDAQAB\"",
            ]
        },
        {
            name = "cm._domainkey"
            type = "TXT"
            ttl = 300
            records = [
                "\"k=rsa;\" \"p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDGPL6I14acroQ/ov7tql728K/XG4c194Ez6m5sNFjpTpxY1YvjBTSDTmsqyNlI4eoPsT7qHrpqtwmtJ+JtGIUwogyITmUF7hOqdm6jL4og3fRGCWOQ4gJAgBx2NqYBHyUvBuGXB89Aj1lrPGGuQlD4sckTwWVHGLUUcEnv3bR2swIDAQAB\"",
            ]
        },
        {
            name = "200608._domainkey"
            type = "TXT"
            ttl = 300
            records = [
                "\"k=rsa;\" \"p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDGoQCNwAQdJBy23MrShs1EuHqK/dtDC33QrTqgWd9CJmtM3CK2ZiTYugkhcxnkEtGbzg+IJqcDRNkZHyoRezTf6QbinBB2dbyANEuwKI5DVRBFowQOj9zvM3IvxAEboMlb0szUjAoML94HOkKuGuCkdZ1gbVEi3GcVwrIQphal1QIDAQAB;\"",
            ]
        },
        {
            name = "kinsta-verification-b79a3c"
            type = "TXT"
            ttl = 300
            records = [
                "33b3bba5-995f-4d91-9c86-7ef8a58a37dc",
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
            name = "_cf-custom-hostname"
            type = "TXT"
            ttl = 300
            records = [
                "19ed8a24-4540-4bec-9408-3f17cd7a2798",
            ]
        },
	    {
            name = "_acme-challenge"
            type = "CNAME"
            ttl = 300
            records = [
                "transplace.com.kinstavalidation.app.",
            ]
        },
        {
            name = "zendesk2._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "zendesk2._domainkey.zendesk.com.",
            ]
        },
        {
            name = "zendesk1._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "zendesk1._domainkey.zendesk.com.",
            ]
        },
        {
            name = "simpplr02._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "simpplr02.c53vsk.custdkim.salesforce.com.",
            ]
        },
        {
            name = "simpplr01._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "simpplr01.z4d6lf.custdkim.salesforce.com.",
            ]
        },
        {
            name = "selector2._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "selector2-transplace-com._domainkey.transplace.onmicrosoft.com.",
            ]
        },
        {
            name = "selector1._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "selector1-transplace-com._domainkey.transplace.onmicrosoft.com.",
            ]
        },
        {
            name = "oracletransplace-iad-202206._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "oracletransplace-iad-202206.transplace.com.dkim.iad1.oracleemaildelivery.com.",
            ]
        },
        {
            name = "cv-usprod-2._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "cv-usprod-2.transplace.com.dkim.cvent-planner.com.",
            ]
        },
        {
            name = "cv-usprod-1._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "cv-usprod-1.transplace.com.dkim.cvent-planner.com.",
            ]
        },
        {
            name = "_domainkey"
            type = "TXT"
            ttl = 300
            records = [
                "\"t=y;\" \"o=~;\"",
            ]
        },
        {
            name = "glb-uattms"
            type = "A"
            ttl = 300
            records = [
                "34.49.198.40"
            ]
        },
        {
            name = "_acme-challenge.uatbi"
            type = "CNAME"
            ttl = 300
            records = [
                "de41ebf8-abd2-4905-9dd7-b39a93f9431b.10.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "uatbi"
            type = "A"
            ttl = 300
            records = [
                "34.107.134.29",
            ]
        },
        {
            name = "_acme-challenge.uattmsservices"
            type = "CNAME"
            ttl = 300
            records = [
                "c4ff7898-28cb-473b-be01-ac6db3f93533.15.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "uattmsservices"
            type = "A"
            ttl = 300
            records = [
                "34.110.128.166",
            ]
        },
        {
            name = "_acme-challenge.sonarqube"
            type = "CNAME"
            ttl = 300
            records = [
                "ee3d3046-bcb5-4a82-8a19-837d9c701129.19.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "sonarqube"
            type = "A"
            ttl = 300
            records = [
                "34.149.152.225",
            ]
        },
        {
            name = "_acme-challenge.glb-uattms"
            type = "CNAME"
            ttl = 300
            records = [
                "fa9c7710-507c-49d7-ab63-529326600c6a.13.authorize.certificatemanager.goog."
            ]
        },
        {
            name = "_acme-challenge.uatptms"
            type = "CNAME"
            ttl = 300
            records = [
                "825dbbaa-096a-4add-8614-5954e63a1db8.9.authorize.certificatemanager.goog."
            ]
        },
        {
            name = "uatptms"
            type = "A"
            ttl = 300
            records = [
                "34.107.243.29"
            ]
        },
        {
            name = "_acme-challenge.uattms"
            type = "CNAME"
            ttl = 300
            records = [
                "78d04e64-f804-4527-80b6-1e0fcad73e6f.18.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "uattms"
            type = "A"
            ttl = 300
            records = [
                "34.120.254.45",
            ]
        },
        {
            name = "_acme-challenge.uattrsl"
            type = "CNAME"
            ttl = 300
            records = [
                "9f73eb9e-4342-47d7-8a15-efa73e536652.5.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "_acme-challenge.uatttst"
            type = "CNAME"
            ttl = 300
            records = [
                "d8b1cd1e-66b7-4b1b-a46b-153e58be9d57.12.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "uattrsl"
            type = "A"
            ttl = 300
            records = [
                "34.8.94.192",
            ]
        },
        {
            name = "uatttst"
            type = "A"
            ttl = 300
            records = [
                "34.8.16.205",
            ]
        },
        {
            name = "_acme-challenge.uatcarrierdb"
            type = "CNAME"
            ttl = 300
            records = [
                "69f22f29-7dc5-4a28-8843-8b0c4126aa81.6.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "_acme-challenge.devfed"
            type = "CNAME"
            ttl = 300
            records = [
                "9d619333-ddff-43a5-adbc-b2e5602f1e4b.10.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "devfed"
            type = "A"
            ttl = 300
            records = [
                "34.13.113.164",
            ]
        },
        {
            name = "_acme-challenge.uatlaser"
            type = "CNAME"
            ttl = 300
            records = [
                "95b06e43-0fb0-41e4-b259-c26ddc299743.14.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "_acme-challenge.uatfed"
            type = "CNAME"
            ttl = 300
            records = [
                "059836f8-e3c9-4008-bb7e-08317802a40a.16.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "uatfed"
            type = "A"
            ttl = 300
            records = [
                "34.13.112.171",
            ]
        },
        {
            name = "_acme-challenge.tms"
            type = "CNAME"
            ttl = 300
            records = [
                "b2708ad4-13d0-458a-8af7-89aae3101df6.6.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "_acme-challenge.tmsservices"
            type = "CNAME"
            ttl = 300
            records = [
                "19de3509-365f-4100-81df-6e98622144c5.18.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "tms"
            type = "A"
            ttl = 300
            records = [
                "34.54.25.255",
            ]
        },
        {
            name = "tmsservices"
            type = "A"
            ttl = 300
            records = [
                "34.8.243.49",
            ]
        },
        {
            name = "_acme-challenge.ptms"
            type = "CNAME"
            ttl = 300
            records = [
                "21ea46b4-3b3a-4aee-a73e-c94f6023f192.13.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "uatlaser"
            type = "A"
            ttl = 300
            records = [
                "34.149.135.118",
            ]
        },
        {
            name = "_acme-challenge.trsl"
            type = "CNAME"
            ttl = 300
            records = [
                "0451df02-53c6-4d52-b23f-6442146e92a2.19.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "_acme-challenge.ttst"
            type = "CNAME"
            ttl = 300
            records = [
                "3deac93f-3904-4a34-b008-f0bcd5de779f.17.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "ptms"
            type = "A"
            ttl = 300
            records = [
                "34.160.90.140"
            ]
        },
        {
            name = "_acme-challenge.bi"
            type = "CNAME"
            ttl = 300
            records = [
                "1f271072-228d-41e9-a439-ebc836e9aa9d.4.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "ttst"
            type = "A"
            ttl = 300
            records = [
                "34.8.222.254",
            ]
        },
        {
            name = "trsl"
            type = "A"
            ttl = 300
            records = [
                "34.160.80.41",
            ]
        },
        {
            name = "_acme-challenge.fed"
            type = "CNAME"
            ttl = 300
            records = [
                "da30f9cd-6b9c-459a-981c-925b4a6f37fc.3.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "fed"
            type = "A"
            ttl = 300
            records = [
                "34.117.113.93",
            ]
        },
        {
            name = "_acme-challenge.devinternational"
            type = "CNAME"
            ttl = 300
            records = [
                "14324697-f3ae-4804-9f50-f51bc8b303ff.6.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "_acme-challenge.international"
            type = "CNAME"
            ttl = 300
            records = [
                "1dc36e37-c06e-4d3b-9f88-6acfde7e94df.3.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "international"
            type = "A"
            ttl = 300
            records = [
                "34.36.71.137",
            ]
        },
        {
            name = "_acme-challenge.laser"
            type = "CNAME"
            ttl = 300
            records = [
                "cab505c3-4089-435b-b2f9-7b83b87b5a5c.4.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "_acme-challenge.carrierdb"
            type = "CNAME"
            ttl = 300
            records = [
                "21b05f50-c9f1-4ad5-8388-26aca3c115aa.9.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "carrierdb"
            type = "A"
            ttl = 300
            records = [
                "34.160.63.89",
            ]
        },
        {
            name = "bi"
            type = "A"
            ttl = 300
            records = [
                "34.8.255.0",
            ]
        },
        {
            name = "laser"
            type = "A"
            ttl = 300
            records = [
                "34.117.148.115",
            ]
        },
        {
            name = "uatlaser"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.transplace.com",
            ]
        },
		{
            name = "uatptms"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.transplace.com",
            ]
        },
		{
            name = "sonarqube"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.transplace.com",
            ]
        },
		{
            name = "tms"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.transplace.com",
            ]
        },
		{
            name = "fed"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.transplace.com",
            ]
        },
		{
            name = "trsl"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.transplace.com",
            ]
        },
		{
            name = "ttst"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.transplace.com",
            ]
        },
		{
            name = "uattrsl"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.transplace.com",
            ]
        },
		{
            name = "uatttst"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.transplace.com",
            ]
        },
		{
            name = "uattmsservices"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.transplace.com",
            ]
        },
		{
            name = "uatbi"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.transplace.com",
            ]
        },
		{
            name = "uatfed"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.transplace.com",
            ]
        },
		{
            name = "tmsservices"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.transplace.com",
            ]
        },
		{
            name = "international"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.transplace.com",
            ]
        },
		{
            name = "uattms"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.transplace.com",
            ]
        },
		{
            name = "bi"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.transplace.com",
            ]
        },
    ]
}

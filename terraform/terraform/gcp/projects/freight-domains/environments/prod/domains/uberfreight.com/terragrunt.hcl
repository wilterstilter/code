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
                "64.239.109.1",
            ]
        },
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
                "_hc3q3nza7mng6m8uo0rv78u4kr3jv6e",
                "google-site-verification=pGnUjC5LuoTt4I19dyKY_p9uTrvA5LxgAqXTEo1SUq4",
                "mmj1wnf8xyglvy49tqgldmj72yjg8spr",
                "MS=ms48230394",
                "\"v=spf1 redirect=4lazf47j._spf._d.mim.ec\"",
                "specops-verification-code=b0ef71d1-4d37-4eb5-bcfa-1b90cf7ee8f3",
                "uber-domain-verification=9f4ec69e-20c1-4018-8f56-829a78c0dbee",
                "atlassian-domain-verification=ixyrkFB6BMmquFjlFadP7eRrTcOwEPFRJ0DsRKC74QMieWQohidyScTaWEidLNBm",
                "SFMC-om2bqr-QtHWLkzlmQydsajl5D6JjpJ5dP5j_3jh6",
                "google-site-verification=Ym4pREJuTTVA0oqoG9kk05xIbc1-4nFMYhnfrNPbxyk",
                "vvkvq9lxlglfgl48dm3q6cbks6zjv9y4",
                "apple-domain-verification=bB5xnk57bRaIasaS",
                "docusign=3f6db382-0b0b-460e-b834-899b9010f61b",
                "intersight=5f514a54e0b7ae2d4041738484c8034a3ae52f3bd710523344bcc9006ec7e695",
                "globalsign-domain-verification=9C82FB47E1C14D6AEF170B417410D13A",
                "globalsign-domain-verification=2E64EA2AF86F0D02F646C7159351992E",
                "globalsign-domain-verification=BAD8EEC8EF461DF3FA0017B88255B6DB",
                "atlassian-sending-domain-verification=29d11ede-0851-428a-96d7-1e12e550ae8d",
                "ZOOM_verify_jDAM3uGXqc6WEFUrmk2vMx",
                "paloaltonetworks-site-verification=05480eb279ee7fba6b792114b1289df596b7ec1826f51c749a89c83878bb6b84",
                "wiz-domain-verification=0475574f26d03a4960f690e127860624f4fa8f62521f3bfd3be70712cd08871f",
                "figma-domain-verification=cf4dc4488e5133f77f080f473103ee83d7dd961cea2ee62d2fbed3d85ae4ee1e-1741381522",
                "_3tmmjfw8amjrtlszgz4cose729y5q7e",
                "_4xoa0tbfvpnfjunrmodfacu2c5bw9jg",
                "asv=5ac7aff67540aa480c9bc4b2b93454e8",
            ]
        },
        {
            name = "13dkim1._domainkey.mc"
            type = "CNAME"
            ttl = 300
            records = [
                "13dkim1._domainkey.s13.exacttarget.com.",
            ]
        },
        {
            name = "procurement-staging"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "labconnect"
            type = "CNAME"
            ttl = 300
            records = [
                "uberfreight.lab.gpcloudservice.com.",
            ]
        },
        {
            name = "tms"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
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
            name = "tms-alpha"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "tms-test"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "tms-dev"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "ai-platform"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "ai-platform-staging"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "freight-ai-platform-sandbox"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "freight-ai-platform-staging"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "freight-ai-platform"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "freight-web-edge-staging"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "learn"
            type = "CNAME"
            ttl = 300
            records = [
                "uberfreight.talentlms.com.",
            ]
        },
        {
            name = "scoki.learn"
            type = "CNAME"
            ttl = 300
            records = [
                "uberfreight.talentlms.com.",
            ]
        },
        {
            name = "@"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-dc.uber.com.",
            ]
        },
        {
            name = "_autodiscover._tcp.autodiscover"
            type = "SRV"
            ttl = 300
            records = [
                "0 0 443 autodiscover.uberfreight.com.",
            ]
        },
        {
            name = "_c465b98ab3f785aa8bacad7afff13f86.brand"
            type = "CNAME"
            ttl = 300
            records = [
                "_981c73891a4007ac75eaa38a976aff06.njdczhxdjc.acm-validations.aws.",
            ]
        },
        {
            name = "_cisco-sxso-verification"
            type = "TXT"
            ttl = 300
            records = [
                "152fae63-f51e-4f93-9944-8cb06cb6ebb5",
            ]
        },
        {
            name = "kinsta-verification-7f2ec0"
            type = "TXT"
            ttl = 300
            records = [
                "f2f56538-3d3e-4338-b729-171c8279ba6c",
            ]
        },
        {
            name = "_cf-custom-hostname"
            type = "TXT"
            ttl = 300
            records = [
                "53245202-84b8-4172-a794-3dcedcd0c83a",
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
            name = "_acme-challenge"
            type = "CNAME"
            ttl = 300
            records = [
                "uberfreight.com.kinstavalidation.app.",
            ]
        },
        {
            name = "url9668"
            type = "CNAME"
            ttl = 300
            records = [
                "sendgrid.net.",
            ]
        },
        {
            name = "44064333"
            type = "CNAME"
            ttl = 300
            records = [
                "sendgrid.net.",
            ]
        },
        {
            name = "btspf"
            type = "CNAME"
            ttl = 300
            records = [
                "u7903245.wl246.sendgrid.net.",
            ]
        },
        {
            name = "em485"
            type = "CNAME"
            ttl = 300
            records = [
                "u44064333.wl084.sendgrid.net.",
            ]
        },
        {
            name = "s1._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "s1.domainkey.u44064333.wl084.sendgrid.net.",
            ]
        },
        {
            name = "gh-mail"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=spf1\" \"include:mg-spf.greenhouse.io\" \"~all\"",
            ]
        },
        {
            name = "ext"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=spf1 redirect=6n2jf2rf._spf._d.mim.ec\"",
                "uber-domain-verification=9f4ec69e-20c1-4018-8f56-829a78c0dbee",
                "google-site-verification=r8NjPYMiYeMwKPLo6qEL1uVkpZFKGLNs-SE51KEh44c",
                "apple-domain-verification=s9kHimSrboGWY54C",
                "intersight=0767fd9d31eab181ab5405d28d1bb1654c0654d0ef8951b00562da4ee9c86e69",
                "atlassian-domain-verification=ixyrkFB6BMmquFjlFadP7eRrTcOwEPFRJ0DsRKC74QMieWQohidyScTaWEidLNBm",
                "ZOOM_verify_8XFgPm5taE5ibaj0eoEC5D",
                "paloaltonetworks-site-verification=f4ddfed72aceb2e64b9e40951d685c8304a42fa91990015bbc503625dfd5e795",
            ]
        },
        {
            name = "smtp._domainkey.gh-mail"
            type = "TXT"
            ttl = 300
            records = [
                "\"k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAup5Ii8ukXxjQTMG+ulT5Yl4Ism9WWMa+c77UIDxhq2yLWseKs+JNTfSYCStPLFKuXHmURpnRcGHVuQneYvR0x+e5bGvAmMy86KabLdz6TWeZI6qwHUpJHtOhYAnEgybczIt+7qlfffgKXKVWyttGEBju4SOTEhQ5auC+FU0hJQ4pNK6k\" \"MrpKAkvivdDvEY8skM49Fjwk6Im+1ZYJ/iIX16/zoJFokKoGFaGxeAQGNJxvzOeSaEeeZ8UAIOVGhp6rOAPmXS/YvN6h2DDN1XFxFBywxzugo5Na+X2fPvYenmYZ0LK7ZEWJohaE1wV2fwLx9zl4WTj6I9R2sTkUcEAQFQIDAQAB\"",
            ]
        },
		{
            name = "mx._domainkey"
            type = "TXT"
            ttl = 300
            records = [
                "\"k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5kRX1u8BvuMZQp9cAsGVScNXn6YIv7SLZoVbI8rSNNGt6GpTSMUaFysn1jO/EJhjFQzXJzgk+2cddFMgkEr65Fr0e8Sb7yjw6qZem24GM9ufqqWGkTHwEpaITEPQ8u+C+Xnhh6sFiBlNKXlNFgG3JNYZvmIpCuEIjmvglpq4n3Pj1i9lRil\" \"CMKHgrv7fX9BY1cYf85aFVTsnOt5fLdK51qaLJ3lIYV07ECiAhjZfh0r+B6PQI2HcID4VhJVL6l9CMpXf4W+D3ITYlhlBMl2ISDXru1Zy2eQ7gYLWwf/KmM2x9ve33GzDwvBSSPWkb0I91DGmUjBc6jIEBkjEA0htpwIDAQAB\"",
            ]
        },
        {
            name = "email.gh-mail"
            type = "CNAME"
            ttl = 300
            records = [
                "mailgun.org.",
            ]
        },
        {
            name = "gh-mail"
            type = "MX"
            ttl = 300
            records = [
                "10 mxa.mailgun.org.",
                "10 mxb.mailgun.org.",
            ]
        },
        {
            name = "_cisco-sxso-verification.ext"
            type = "TXT"
            ttl = 300
            records = [
                "3bc7cae1-7ddd-4c29-ba3e-fd5cc3c41c97",
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
            name = "_dmarc.agent"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=DMARC1; p=quarantine; rua=mailto:0d4b78f03768934@rep.dmarcanalyzer.com; ruf=mailto:0d4b78f03768934@for.dmarcanalyzer.com; fo=1;\"",
            ]
        },
        {
            name = "_dmarc.mc"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=DMARC1; p=reject; pct=100;\"",
            ]
        },
        {
            name = "_github-challenge-uber-freight-os-ent"
            type = "TXT"
            ttl = 300
            records = [
                "8f252dee57",
            ]
        },
        {
            name = "_pki-validation"
            type = "TXT"
            ttl = 300
            records = [
                "505C-9D8B-0747-7715-CAF3-0A54-BDFC-3B96",
            ]
        },
        {
            name = "_slack-challenge"
            type = "TXT"
            ttl = 300
            records = [
                "slack-domain-verification=ryj55ED8I0v4qC9OQHZUafF4PYdr1DQcA61nnP9c",
            ]
        },
        {
            name = "agent"
            type = "MX"
            ttl = 300
            records = [
                "10 us-smtp-inbound-1.mimecast.com.",
                "10 us-smtp-inbound-2.mimecast.com.",
            ]
        },
        {
            name = "agent"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=spf1 include:mail.zendesk.com include:_spf.salesforce.com include:_spf.psm.knowbe4.com include:21784537.spf01.hubspotemail.net include:_spf.ultipro.com include:_netblocks.google.com include:us._netblocks.mimecast.com\" \" include:spf.protection.outlook.com ip4:204.239.0.0/24 ip4:198.207.147.0/24 ip4:216.230.14.0/24 ip4:54.240.8.0/24 ip4:160.34.15.16/29 ip4:65.64.216.0/24 ip4:52.185.227.176/32 ip4:20.45.2.251/32 ip4:208.191.62.0/24 ip4:54.240.71.135 ip4:54.240.71.136 ~all\"",
                "uber-domain-verification=9f4ec69e-20c1-4018-8f56-829a78c0dbee",
                "google-site-verification=lAJ_I1wj4ijzr3F9T3fUItdTPf2EuZLInTCuyWxyXbI",
                "apple-domain-verification=zVdDpTDwuWrgDSMf",
                "atlassian-domain-verification=ixyrkFB6BMmquFjlFadP7eRrTcOwEPFRJ0DsRKC74QMieWQohidyScTaWEidLNBm",
                "ZOOM_verify_LfWcCu9LW18riZjjdYO8uv",
            ]
        },
        {
            name = "analytics"
            type = "CNAME"
            ttl = 300
            records = [
                "internal-tableauapplicationloadbalancer-1830773706.us-east-1.elb.amazonaws.com.",
            ]
        },
        {
            name = "atlassian-784044._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "atlassian-784044.dkim.atlassian.net.",
            ]
        },
        {
            name = "atlassian-7a487a._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "atlassian-7a487a.dkim.atlassian.net.",
            ]
        },
        {
            name = "atlassian-bounces"
            type = "CNAME"
            ttl = 300
            records = [
                "bounces.mail-us.atlassian.net.",
            ]
        },
        {
            name = "aus-oob-lh-ext"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.7",
            ]
        },
        {
            name = "auth"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "auth-dev"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "auth-staging"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "edgetest"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "autodiscover.agent"
            type = "CNAME"
            ttl = 300
            records = [
                "autodiscover.outlook.com.",
            ]
        },
        {
            name = "autodiscover.ext"
            type = "CNAME"
            ttl = 300
            records = [
                "autodiscover.outlook.com.",
            ]
        },
        {
            name = "yo53k6kkjbv6rbhfutxer3sin5b3ipo4._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "yo53k6kkjbv6rbhfutxer3sin5b3ipo4.dkim.amazonses.com.",
            ]
        },
		{
            name = "qmzdcxm6k4vnpeet2gqnagw6jp4uvebm._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "qmzdcxm6k4vnpeet2gqnagw6jp4uvebm.dkim.amazonses.com.",
            ]
        },
		{
            name = "iicadwoshleuoo4s4d53tr66nvwmeow3._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "iicadwoshleuoo4s4d53tr66nvwmeow3.dkim.amazonses.com.",
            ]
        },
        {
            name = "b2b"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.69",
            ]
        },
        {
            name = "fintech-dev-1"
            type = "A"
            ttl = 300
            records = [
                "141.148.138.50",
            ]
        },
        {
            name = "b2b-portal"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.65",
            ]
        },
        {
            name = "b2b-test"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.169",
            ]
        },
        {
            name = "b2b-test-portal"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.171",
            ]
        },
        {
            name = "b2b-uat"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.51",
            ]
        },
        {
            name = "devinternational"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.35",
            ]
        },
        {
            name = "b2b-uat-portal"
            type = "A"
            ttl = 300
            records = [
                "208.191.62.52",
            ]
        },
        {
            name = "bounce.mc"
            type = "MX"
            ttl = 300
            records = [
                "10 bounce.s13.exacttarget.com.",
            ]
        },
        {
            name = "bounce.mc"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=spf1 include:cust-spf.exacttarget.com -all\"",
            ]
        },
        {
            name = "_e213d638283748584bc9922f0c5d8e35.api.connect"
            type = "CNAME"
            ttl = 300
            records = [
                "_15bb1852d0fc62915344c8bedd673d06.xlfgrmvvlj.acm-validations.aws.",
            ]
        },
		{
            name = "_8c85fb0887f1849c1a134c9fa7c565af.connect"
            type = "CNAME"
            ttl = 300
            records = [
                "_e78bb20935649a4127b0025b624b8c21.xlfgrmvvlj.acm-validations.aws.",
            ]
        },
		{
            name = "api.connect"
            type = "CNAME"
            ttl = 300
            records = [
                "uber-api.app.simpplr.com.",
            ]
        },
        {
            name = "brand"
            type = "CNAME"
            ttl = 300
            records = [
                "brand.uberfreight.com.b.mybrandfolder.com.",
            ]
        },
        {
            name = "bt._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "bt.domainkey.u7903245.wl246.sendgrid.net.",
            ]
        },
        {
            name = "bt2._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "bt2.domainkey.u7903245.wl246.sendgrid.net.",
            ]
        },
        {
            name = "click.mc"
            type = "CNAME"
            ttl = 300
            records = [
                "tl64lms3fyccsyfzlz6c5fh210tm.click-sap.sfmc-marketing.com.",
            ]
        },
        {
            name = "cloud.mc"
            type = "CNAME"
            ttl = 300
            records = [
                "tldvymjqgy61r4pk7ggc4-bfh0t0.cp-sap.sfmc-content.com.",
            ]
        },
        {
            name = "cloudconnect"
            type = "CNAME"
            ttl = 300
            records = [
                "uberfreight.gpcloudservice.com.",
            ]
        },
        {
            name = "cloudflare-verify"
            type = "TXT"
            ttl = 300
            records = [
                "496599941-821141140",
            ]
        },
        {
            name = "connect"
            type = "CNAME"
            ttl = 300
            records = [
                "uber.app.simpplr.com.",
            ]
        },
        {
            name = "cv-usprod-1._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "cv-usprod-1.uberfreight.com.dkim.cvent-planner.com.",
            ]
        },
        {
            name = "cv-usprod-2._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "cv-usprod-2.uberfreight.com.dkim.cvent-planner.com.",
            ]
        },
        {
            name = "dal-oob-lh-ext"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.63",
            ]
        },
        {
            name = "developer"
            type = "CNAME"
            ttl = 300
            records = [
                "transplace-portal.apigee.net.",
            ]
        },
        {
            name = "devgw"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "dkimkey._domainkey"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAofB1uhjjdKNU4Rh40d8wNms9vMemF4z2CqP1Lwj3BAXsUCgz7ailRpr1nt62qxPOkuPxruDA+eK8PiNxtHiNWtf6JLC+Xo38cNgbtjy3dumj+JJCDIXUIkJjRjJ3pJJ/nNYWYE/AwYq3X6vaorpr3wrKcPLMCceB8CS6zZOh0J5ffxI0OS0Jp\" \"824JW2xPpfjyMi6x/kjWVE3UOkt7QRbpulWEpGS9vtCQs7Jry0hmTXd+pxngDKfoh7aDt2QkqjH5N/nd93HFNJZk7O5sBMtlqO0anqZvAEf4V6TztYasPvjh1+XRUHas15savxglDh7bhmk1Y/6jXueOX1vz7urzwIDAQAB\"",
            ]
        },
        {
            name = "e893873f1410f"
            type = "CNAME"
            ttl = 300
            records = [
                "validate-domain.mimecast.com.",
            ]
        },
        {
            name = "em2656"
            type = "CNAME"
            ttl = 300
            records = [
                "u5033546.wl047.sendgrid.net.",
            ]
        },
        {
            name = "em4981"
            type = "CNAME"
            ttl = 300
            records = [
                "u13641.wl142.sendgrid.net.",
            ]
        },
        {
            name = "em654"
            type = "CNAME"
            ttl = 300
            records = [
                "u43324888.wl139.sendgrid.net.",
            ]
        },
        {
            name = "em8146"
            type = "MX"
            ttl = 300
            records = [
                "10 mx.sendgrid.net.",
            ]
        },
        {
            name = "em8146"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=spf1 ip4:168.245.19.207 -all\"",
            ]
        },
        {
            name = "em8595"
            type = "CNAME"
            ttl = 300
            records = [
                "u7903245.wl246.sendgrid.net.",
            ]
        },
        {
            name = "em922.support"
            type = "CNAME"
            ttl = 300
            records = [
                "u13641.wl142.sendgrid.net.",
            ]
        },
        {
            name = "employeeexperience"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.176",
            ]
        },
        {
            name = "enterpriseenrollment"
            type = "CNAME"
            ttl = 300
            records = [
                "enterpriseenrollment.manage.microsoft.com.",
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
            name = "ext"
            type = "MX"
            ttl = 300
            records = [
                "10 us-smtp-inbound-1.mimecast.com.",
                "10 us-smtp-inbound-2.mimecast.com.",
            ]
        },
        {
            name = "facilities"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "facilities-uat"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "facilities-test"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "gappify"
            type = "MX"
            ttl = 300
            records = [
                "10 feedback-smtp.us-west-2.amazonses.com.",
            ]
        },
        {
            name = "gappify"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=spf1 ip4:54.240.112.5 ip4:54.240.112.6 ~all\"",
            ]
        },
        {
            name = "google._domainkey"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAk438ddYdC65Eo7+gB7EMzJMcwydK/AVE0cfH831Hk+Oh2KJwlIdcl4p/STFHy7dh6yodpuSWAOUzDHcWtqrLFtMGbaXIBATurrFevpaozBKjZDJyeod+ykGCmAmeeLyq10iWCsW/U8Tj0RmXAa4GAF7CfiJRdjSrOuG+nMVZcHh+\" \"CiL93C/V78Twi2icqf0xhXawFAJky145EXa4JUhgJAQLXkldiK+rZFoLBfRITfGeXZzkNs31o1O+x4yyXYH7AmYPcbLy/y/5W7eOTdP6uFEMJ6Wf5tzmQ2hvNwoXnXYgX01XEU0ohF7zoSJ5zX66jZBTdp5zYbniR0iOi2EWpwIDAQAB\"",
            ]
        },
        {
            name = "gpt"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "gpt-staging"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "hs1-21784537._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "uberfreight-com.hs13a.dkim.hubspotemail.net.",
            ]
        },
        {
            name = "hs2-21784537._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "uberfreight-com.hs13b.dkim.hubspotemail.net.",
            ]
        },
        {
            name = "image.mc"
            type = "CNAME"
            ttl = 300
            records = [
                "tll02xzjbn525sz-brrj4n1s718q.image-sap.sfmc-content.com.",
            ]
        },
        {
            name = "info"
            type = "CNAME"
            ttl = 300
            records = [
                "21784537.group37.sites.hubspot.net.",
            ]
        },
        {
            name = "insights"
            type = "CNAME"
            ttl = 300
            records = [
                "21784537.group37.sites.hubspot.net.",
            ]
        },
        {
            name = "insights-ai"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "insights-ai-staging"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "insights-ai-uat"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "learning"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.176",
            ]
        },
        {
            name = "leave.mc"
            type = "MX"
            ttl = 300
            records = [
                "10 reply.s13.exacttarget.com.",
            ]
        },
        {
            name = "login"
            type = "CNAME"
            ttl = 300
            records = [
                "c5cad8a7abfff480.vercel-dns-013.com.",
            ]
        },
        {
            name = "mailo._domainkey.mg"
            type = "TXT"
            ttl = 300
            records = [
                "\"k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC711DsGtRn4aepz2soG8m0/gtK513aIb3OaTBurU18+Jn1IuOk/rFLBlgO5ru8uTiCqaMxo3g5unM4KbxgCKrEuxHxmzWD5nYB88xxbJMYwsC+h1UX08NFJ8MMJCXWzRYnIswUvtGphMTsYNHnVQuQ58lEOLxtPjAz66XLMzUhewIDAQAB\"",
            ]
        },
        {
            name = "mc"
            type = "A"
            ttl = 300
            records = [
                "96.43.154.16",
            ]
        },
        {
            name = "mc"
            type = "MX"
            ttl = 300
            records = [
                "10 reply.s13.exacttarget.com.",
            ]
        },
        {
            name = "mc"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=spf1 include:cust-spf.exacttarget.com -all\"",
            ]
        },
        {
            name = "mg"
            type = "MX"
            ttl = 300
            records = [
                "10 mxa.mailgun.org.",
                "10 mxb.mailgun.org.",
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
            name = "mimecast20220801._domainkey"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCPhtxg9hDsVLErEEEzS8h7nUyK4lUbgrmj6CfuGOvS82G6/+6LBsdDIveJCtVHkoPuPFZky7ui0RR6KYC+M+aUkciUegd9ooK0xfuUnMCE+6hF0IFQ1F+qIa6tUMF2QKDFavmC8G4BtG0DrInyTu7EsKCZ1Qh4zXC6kNASPNSg/wIDAQAB\"",
            ]
        },
        {
            name = "mimecast20230117._domainkey.agent"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAua31gMa6SzZLBakz7Ud70FV1Z3aS+dm4tESoilIMUjIKS1Wt2uXMGE9JBC+0KYuoy6UKFJoGd/30RalzfXNz5q0QPe5GWyXsal+VWQDs1XLC8SmldrHDZXDxABVJPwNZ42T6P35e4nPL7peEvixH1Oqsu5R/rCk+\" \"thLeKXEXMbNiK7RdlzecBLY3jrEQN1m3h/2LYJUfk6FVwhnqRfn+Uox6eqgB1aWQ92dU5u4Ns/6w7sw1rG5+yreM41u3CY3Wz2gwO1NMVs6rP2S22nGFYSfrNdBbPKi33gVflDhYND41NF1BO9zfCJbdR4y/UaRZIeqK0S+EMb33kTz7uTfxPQIDAQAB\"",
            ]
        },
        {
            name = "mimecast20230713._domainkey.ext"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzszUYuU093CN+NERd8jCYvaq5VNbmM0EsvY5gOR53IWVPCQvATmGV53l3axvfEbIt/nXpa1WdBGyFpFXvi3NbZGZL7qK7NR+6grXkFhUgXYD73mHw7kB+CxFzf55URXoAKSj7B+dzmOGJ+Gx46rPF2Gp\" \"/ZinfXYn+dFql+ZDkwhw2A3TiTXwumLTa5eXokpWokh3A0IgOSfyBLb0Hvdwmw+i2nfsBDi3Arkggfuhq3i+EyB2dJbv7KP9Iwj3wUcP8RigmN7ckcUV7bDuOoXEAtGaj+IRcAI2Faxc2MG0LJM5fqv/ftZo1hy7xoMIosjOHRoVoVUPRvJQa0csrX4RWwIDAQAB\"",
            ]
        },
        {
            name = "myaccount"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.176",
            ]
        },
        {
            name = "newsletters"
            type = "MX"
            ttl = 300
            records = [
                "10 feedback-smtp.us-east-1.amazonses.com.",
            ]
        },
        {
            name = "newsletters"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=spf1 include:_netblocks.mimecast.com include:amazonses.com ~all\"",
            ]
        },
        {
            name = "nh5z3zpkw6pi5lamduemgtevhl2go5n3._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "nh5z3zpkw6pi5lamduemgtevhl2go5n3.dkim.amazonses.com.",
            ]
        },
        {
            name = "octopus"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "octopus-staging"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "oob-lh-ext"
            type = "CNAME"
            ttl = 300
            records = [
                "dal-oob-lh-ext.uberfreight.com.",
            ]
        },
        {
            name = "ops"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloudflare.uber.com.",
            ]
        },
        {
            name = "ops-ci"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloudflare.uber.com.",
            ]
        },
        {
            name = "ops-staging"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloudflare.uber.com.",
            ]
        },
        {
            name = "oracleuberfreight._domainkey"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=DKIM1;k=rsa;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAudOGzAr0VWshJXjmq1rxUOYHR4o2xTScn+GkFiN/aVi+EEFd9MGeV+vO/+mMIjKRJhv6GDKrZIfDsoJp08QMaLuVeeYgMTh95Fp/8YnoPFajbjirIaVpN+LxD+AKAedtk\" \"2OR3HuSW/zc0VxFVQ0VxZp761BqQVJO2ntSliN8LTwR55Sc/HOgasshVUvd0HRActI6renx+VEYnGtw91F8f544jNYOYd0mTfanXgzvP3Vd2Gj1MOnZIoZtlxUtFoIzPXquJ+d+qyMvs5KDU62Ky6NWZjKrik8VRTse+Wc5Hs6hF5YyPSMziWVhg9gEkAeAo0WAlfxJkYznsri5ThBjMQIDAQAB\"",
            ]
        },
        {
            name = "pages.mc"
            type = "CNAME"
            ttl = 300
            records = [
                "tlsmcjvv-c3p6js8qvcjsjng-8f8.cp-sap.sfmc-content.com.",
            ]
        },
        {
            name = "peopleassist"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.176",
            ]
        },
        {
            name = "peopleportal"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.176",
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
            name = "policyportal"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.176",
            ]
        },
        {
            name = "procurement"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "qenh66tu5kxatfgxm6wjd4n35l2dr2b3._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "qenh66tu5kxatfgxm6wjd4n35l2dr2b3.dkim.amazonses.com.",
            ]
        },
        {
            name = "recorduberfreight._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "uberfreight.9jqxrd.custdkim.salesforce.com.",
            ]
        },
        {
            name = "reply.mc"
            type = "MX"
            ttl = 300
            records = [
                "10 reply.s13.exacttarget.com.",
            ]
        },
        {
            name = "reply.mc"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=spf1 include:cust-spf.exacttarget.com -all\"",
            ]
        },
        {
            name = "s1._domainkey.support"
            type = "CNAME"
            ttl = 300
            records = [
                "s1.domainkey.u13641.wl142.sendgrid.net.",
            ]
        },
        {
            name = "s2._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "s2.domainkey.u13641.wl142.sendgrid.net.",
            ]
        },
        {
            name = "s2._domainkey.support"
            type = "CNAME"
            ttl = 300
            records = [
                "s2.domainkey.u13641.wl142.sendgrid.net.",
            ]
        },
        {
            name = "sandboxportal"
            type = "CNAME"
            ttl = 300
            records = [
                "transplace-portal.apigee.net.",
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
            name = "devapi"
            type = "CNAME"
            ttl = 300
            records = [
                "transplace-staging.apigee.net.",
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
            name = "uatapi"
            type = "CNAME"
            ttl = 300
            records = [
                "transplace-uat.apigee.net.",
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
            name = "api"
            type = "CNAME"
            ttl = 300
            records = [
                "transplace-prod.apigee.net.",
            ]
        },
        {
            name = "scph0623._domainkey"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=DKIM1; k=rsa; h=sha256; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC4DYAXc2dsvclwcHJ/g4ryuzkCNVoMpL+80LN+xq0bIBtZPxmT+p5G1SfwQMV8VyaKL0v+PWi6yMmaVbMJhpvfOYoVzIOrRKhyokUhoV5PSYnZE/QsTzY7YA/GY/q2I6rwNvEUZzN+07p7RraaD+t0LplDS8WAjNcrYkbS5vBvdQIDAQAB\"",
            ]
        },
        {
            name = "mimecast20250411._domainkey"
            type = "TXT"
            ttl = 300
            records = [
			    "\"v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA5kGbndm5O7JcOZq53X9xclLOhM1kXCacJYmEoEYR8iBFFdTx/AQ9CQxhz+zXCaug0a14UWyNOltUYTRBBmWBS94aL9tSMcQP2NWh7QuYOvtyMS0KPs4j60fIoAiaOFufX2JqZ+LUW6YH2PCBqVswd3NA84Yb9gnpiqADsdkvyHwwH7lV\" \"UvZD1pdT//E/tJKfriZ7v87TQek9gO33cV2Y3fO7agUwxLNDPoN32xEhegeYdilNToLHoUpZeEFfm0tTkXeWbbGI5S1WlQ4c8qkfS8n8WczRv4enEoBjn8lPXqI3/Jt+o0p8Uc5onvEv5rGG3j1BYKCvZozohdR8uRyF+wIDAQAB\"",
            ]
        },
        {
            name = "scph0623._domainkey.spmail"
            type = "TXT"
            ttl = 300
            records = [
                "\"p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDYv3XxAhVPYZTe/pz4Pn74zkGa6/rbUIyJJzZjgBxa7GQi/DibOi3Xr8hhTb+Nxj4pkjkeUrJumGIP0Kxzn3g4i86nwCxO7nAOLSx0Ym10E5uGR5p00VSZEgbPYCyBIQ3hKLG95xj3UfZmh1HNqgkIxp3KQh9ASLXhrCfB94J8NQIDAQAB\"",
            ]
        },
        {
            name = "shareworks"
            type = "CNAME"
            ttl = 300
            records = [
                "transplace.solium.com.",
            ]
        },
        {
            name = "shipper"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "shipper-insights"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "shipper-insights-staging"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "spa._domainkey"
            type = "TXT"
            ttl = 300
            records = [
                "\"k=rsa; t=s; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDgm3WoBDjD68yyxqw7ORAiML+IxbRcdeypKbbM+7rTG5C8jtylTL1BSvY1LAgoT4Y23Jv0PJhtPKaAPlGNx/gVYNvzN8KwJEQ6WOR9vcunivD8pZcP4/UB8OHv2JzmlttsadsHla2kYHakB/fTj1KD9qUlwJ5R1yqEcCNUpEhhhwIDAQAB\"",
            ]
        },
        {
            name = "spmail"
            type = "CNAME"
            ttl = 300
            records = [
                "uber.mail.e.sparkpost.com.",
            ]
        },
        {
            name = "support"
            type = "MX"
            ttl = 300
            records = [
                "10 mx.sendgrid.net.",
            ]
        },
        {
            name = "techconnect"
            type = "CNAME"
            ttl = 300
            records = [
                "techconnect.transplace.com.",
            ]
        },
        {
            name = "test"
            type = "MX"
            ttl = 300
            records = [
                "1 ASPMX.L.GOOGLE.COM.",
                "5 ALT1.ASPMX.L.GOOGLE.COM.",
                "5 ALT2.ASPMX.L.GOOGLE.COM.",
                "10 ALT3.ASPMX.L.GOOGLE.COM.",
                "10 ALT4.ASPMX.L.GOOGLE.COM.",
            ]
        },
        {
            name = "test"
            type = "TXT"
            ttl = 300
            records = [
                "3102f485589f338efa3eee5e6308bc9b87",
            ]
        },
        {
            name = "uberfreight._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "uberfreight.9jqxrd.custdkim.salesforce.com.",
            ]
        },
        {
            name = "ufsalesforce._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "ufsalesforce.t7b8f3.custdkim.salesforce.com.",
            ]
        },
        {
            name = "usaebqp4k2z5ndfkyx3diyrtugowvskg._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "usaebqp4k2z5ndfkyx3diyrtugowvskg.dkim.amazonses.com.",
            ]
        },
        {
            name = "utoken"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "view.mc"
            type = "CNAME"
            ttl = 300
            records = [
                "tlkxdq6klvpkpfcrcd60nn9yhj64.view-sap.sfmc-marketing.com.",
            ]
        },
        {
            name = "wfm"
            type = "A"
            ttl = 300
            records = [
                "65.64.216.176",
            ]
        },
        {
            name = "wnxf7nvdmicsbtqahmbnl2s5kcdaygcy._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "wnxf7nvdmicsbtqahmbnl2s5kcdaygcy.dkim.amazonses.com.",
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
            name = "ye6vsqn4odpd7wflwz57xmxqqeyhlirf._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "ye6vsqn4odpd7wflwz57xmxqqeyhlirf.dkim.amazonses.com.",
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
            name = "zendesk2._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "zendesk2._domainkey.zendesk.com.",
            ]
        },
        {
            name = "zendeskverification"
            type = "TXT"
            ttl = 300
            records = [
                "1bf59202c0abaef2",
                "11024bcd75321efaz",
                "e7b83adbcbfd0216",
                "19520c797ec3ed69",
                "9f336827ef820fd9",
                "4d5c497019aa625b",
            ]
        },
        {
            name = "zzxfx2lygtu2dr6nq4mu2pi5od5bq6tj._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "zzxfx2lygtu2dr6nq4mu2pi5od5bq6tj.dkim.amazonses.com.",
            ]
        },
        {
            name = "freight-ops-lite"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "freight-ops-lite-staging"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "_acme-challenge.cicd-nonprod"
            type = "CNAME"
            ttl = 300
            records = [
                "5f806e8e-0a80-402d-84f7-d0bb5677923a.2.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "cicd-nonprod"
            type = "A"
            ttl = 300
            records = [
                "34.120.174.48",
            ]
        },
        {
            name = "_acme-challenge.ufgtm"
            type = "CNAME"
            ttl = 300
            records = [
                "afca4918-e3f2-42ac-a751-0f44ff799ef0.3.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "ufgtm"
            type = "A"
            ttl = 300
            records = [
                "34.149.25.16",
            ]
        },
        {
            name = "_acme-challenge.cicd"
            type = "CNAME"
            ttl = 300
            records = [
                "c055fb60-5728-487e-abb1-ccbf988a3f16.11.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "cicd"
            type = "A"
            ttl = 300
            records = [
                "34.8.37.9",
            ]
        },
        {
            name = "parcel-staging"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "_cf-custom-hostname.trust"
            type = "TXT"
            ttl = 300
            records = [
                "584f5545-6382-43d2-bff1-cccb122df291",
            ]
        },
		{
            name = "trust"
            type = "CNAME"
            ttl = 300
            records = [
                "68714bf24412a27c22396ae3.cname.vantatrust.com.",
            ]
        },
        {
            name = "status"
            type = "CNAME"
            ttl = 300
            records = [
                "frontends-cloud.uber.com.",
            ]
        },
        {
            name = "n67ljhiksm74ih4ggjck6hfdyopje3kl._domainkey.trust"
            type = "CNAME"
            ttl = 300
            records = [
                "n67ljhiksm74ih4ggjck6hfdyopje3kl.dkim.amazonses.com.",
            ]
        },
		{
            name = "pnb6wvzsbyk47xlnozndvgykhetffvpb._domainkey.trust"
            type = "CNAME"
            ttl = 300
            records = [
                "pnb6wvzsbyk47xlnozndvgykhetffvpb.dkim.amazonses.com.",
            ]
        },
		{
            name = "l7da2bvnjofrgb43iby6oyfybxbr3jpe._domainkey.trust"
            type = "CNAME"
            ttl = 300
            records = [
                "l7da2bvnjofrgb43iby6oyfybxbr3jpe.dkim.amazonses.com.",
            ]
        },
        { 
            name = "bid48ba.21784537m.comms"
            type = "A"
            ttl = 300
            records = [
                "158.247.26.196",
            ]
        },
		{
            name = "21784537m.comms"
            type = "MX"
            ttl = 300
            records = [
                "0 mx.hubapi.com.",
            ]
        },
		{
            name = "21784537m.comms"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=spf1 include:21784537.spf05.hubspotemail.net -all\"",
            ]
        },
		{
            name = "hs1._domainkey.21784537m.comms"
            type = "CNAME"
            ttl = 300
            records = [
                "21784537m-comms-uberfreight-com.hs01a.dkim.hubspotemail.net.",
            ]
        },
		{
            name = "hs2._domainkey.21784537m.comms"
            type = "CNAME"
            ttl = 300
            records = [
                "21784537m-comms-uberfreight-com.hs01b.dkim.hubspotemail.net.",
            ]
        },
        {
            name = "bydackq.21784537t.alerts"
            type = "A"
            ttl = 300
            records = [
                "216.139.94.152",
            ]
        },
		{
            name = "21784537t.alerts"
            type = "MX"
            ttl = 300
            records = [
                "0 mx.hubapi.com.",
            ]
        },
		{
            name = "21784537t.alerts"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=spf1 include:21784537.spf05.hubspotemail.net -all\"",
            ]
        },
		{
            name = "hs1._domainkey.21784537t.alerts"
            type = "CNAME"
            ttl = 300
            records = [
                "21784537t-alerts-uberfreight-com.hs01a.dkim.hubspotemail.net.",
            ]
        },
		{
            name = "hs2._domainkey.21784537t.alerts"
            type = "CNAME"
            ttl = 300
            records = [
                "21784537t-alerts-uberfreight-com.hs01b.dkim.hubspotemail.net.",
            ]
        },
        {
            name = "cicd"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.uberfreight.com",
            ]
        },
	    {
            name = "cicd-nonprod"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.uberfreight.com",
            ]
        },
		{
            name = "ufgtm"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.uberfreight.com",
            ]
        },
    ]
}

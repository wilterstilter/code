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
                "65.64.216.176",
            ]
        },
        {
            name = ""
            type = "MX"
            ttl = 300
            records = [
                "1 aspmx.l.google.com.",
                "10 aspmx2.googlemail.com.",
                "10 aspmx3.googlemail.com.",
                "5 alt1.aspmx.l.google.com.",
                "5 alt2.aspmx.l.google.com.",
            ]
        },
        {
            name = ""
            type = "TXT"
            ttl = 300
            records = [
                "_t2u1d9d5203q4nr9ksea5j6hmir30pz",
                "google-site-verification=0uohStBKJwFOAy5KYNBx6JDZT6Uk7XOXACxHwrRkHxI",
                "\"v=spf1 include:_spf.google.com include:servers.mcsv.net ip4:159.183.149.25 ~all\"",
                "globalsign-domain-verification=EE0BC0BC606AC02CBF7E98E1AB23124A",
                "globalsign-domain-verification=937160556F830A51425A558159CA47F2",
                "_snjkgqjo1ltsx1h4o648qk6ebpu3bbn",
            ]
        },
        {
            name = "3547860"
            type = "CNAME"
            ttl = 300
            records = [
                "sendgrid.net.",
            ]
        },
        {
            name = "675f2uoy4l4w.qa-my"
            type = "CNAME"
            ttl = 300
            records = [
                "gv-ezduxmdoi7iwvo.dv.googlehosted.com.",
            ]
        },
        {
            name = "_dmarc"
            type = "TXT"
            ttl = 300
            records = [
                "\"v=DMARC1; p=quarantine; fo=1;\"",
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
                "66B4-CFFE-1E18-2337-7039-4E21-2D4C-5F82",
            ]
        },
        {
            name = "default"
            type = "CNAME"
            ttl = 300
            records = [
                "u3547860.wl111.sendgrid.net.",
            ]
        },
        {
            name = "demo-my"
            type = "CNAME"
            ttl = 300
            records = [
                "demo-my-lanehub.azurewebsites.net.",
            ]
        },
        {
            name = "dkim.mcsv.net"
            type = "CNAME"
            ttl = 300
            records = [
                "k1._domainkey.lanehub.com.",
            ]
        },
        {
            name = "em2312"
            type = "CNAME"
            ttl = 300
            records = [
                "u43324888.wl139.sendgrid.net.",
            ]
        },
        {
            name = "em246"
            type = "CNAME"
            ttl = 300
            records = [
                "u42315068.wl069.sendgrid.net.",
            ]
        },
        {
            name = "email"
            type = "CNAME"
            ttl = 300
            records = [
                "email.secureserver.net.",
            ]
        },
        {
            name = "ftp"
            type = "CNAME"
            ttl = 300
            records = [
                "@.",
            ]
        },
        {
            name = "imsaw5yrc76b.dev-my"
            type = "CNAME"
            ttl = 300
            records = [
                "gv-w4b5xaauxhaxiq.dv.googlehosted.com.",
            ]
        },
        {
            name = "k1._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "dkim.mcsv.net.",
            ]
        },
        {
            name = "links"
            type = "CNAME"
            ttl = 300
            records = [
                "sendgrid.net.",
            ]
        },
        {
            name = "my-lanehub.azurewebsites.net"
            type = "A"
            ttl = 300
            records = [
                "40.112.142.148",
            ]
        },
        {
            name = "s1._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "s1.domainkey.u43324888.wl139.sendgrid.net.",
            ]
        },
        {
            name = "s2._domainkey"
            type = "CNAME"
            ttl = 300
            records = [
                "s2.domainkey.u43324888.wl139.sendgrid.net.",
            ]
        },
        {
            name = "www"
            type = "CNAME"
            ttl = 300
            records = [
                "lanehub.com.",
            ]
        },
        {
            name = "_acme-challenge.dev-my"
            type = "CNAME"
            ttl = 300
            records = [
                "57b15c96-abe2-4e40-8260-a2414866f101.16.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "dev-my"
            type = "A"
            ttl = 300
            records = [
                "34.160.36.26",
            ]
        },
        {
            name = "_acme-challenge.qa-my"
            type = "CNAME"
            ttl = 300
            records = [
                "38a3fb01-fa38-4bd6-bf2b-f916ca839f56.18.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "qa-my"
            type = "A"
            ttl = 300
            records = [
                "34.49.209.173",
            ]
        },
        {
            name = "_acme-challenge.my"
            type = "CNAME"
            ttl = 300
            records = [
                "4fcf6231-0a9a-4e61-a3e4-7829e502b133.4.authorize.certificatemanager.goog.",
            ]
        },
        {
            name = "my"
            type = "A"
            ttl = 300
            records = [
                "34.149.75.19",
            ]
        },
        {
            name = "my"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.lanehub.com",
            ]
        },
		{
            name = "dev-my"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.lanehub.com",
            ]
        },
		{
            name = "qa-my"
            type = "TXT"
            ttl = 300
            records = [
                "ae1f874ca9d44aa6a5f6ad8d03c8e5b7.lanehub.com",
            ]
        },
    ]
}

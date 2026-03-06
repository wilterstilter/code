include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-edge/modules/cloud-armor"
}

include "common" {
    path = find_in_parent_folders("common.hcl")
    expose = true
}

inputs = {
  name = include.common.locals.name
  rules = [
    {
      priority = 501
      action = "allow"
      expression = "token.recaptcha_exemption.valid"
      description = "Allow from recaptcha-validated clients"
      preview = false
    },
    {
      priority = 502
      action = "allow"
      expression = "origin.asn == 15169 && request.headers['user-agent'].matches('(?:-Google|Googlebot)')"
      description = "Allow Google Crawler"
      preview = false
    },
    {
      priority = 503
      action = "allow"
      expression = "origin.asn == 8075 && request.headers['user-agent'].contains('bingbot')"
      description = "Allow Bing"
      preview = false
    },
    {
      priority    = 520
      action      = "allow"
      expression  = "evaluateThreatIntelligence('iplist-search-engines-crawlers')"
      description = "SWNEDGE-2351 Allow all crawlers (via IP Intelligence)"
      preview     = false
    },
    {
      priority    = 603
      action      = "throttle"
      expression  = "request.headers['accept'].lower().contains('text/html') && evaluateThreatIntelligence('iplist-public-clouds')"
      rate_limit_options = {
        rate_limit_threshold = {
          count = 60,
          interval_sec = 60
        },
        conform_action = "allow",
        exceed_redirect_options = {
          type = "GOOGLE_RECAPTCHA"
        },
        exceed_action = "redirect",
        enforce_on_key = "IP"
      }
      description = "SWNEDGE-2351 Rate Limit HTML requests from public cloud networks"
      preview     = false
    },
    {
      priority    = 650 
      action      = "deny(403)"
      expression  = "token.recaptcha_session.score <= 0.3"
      description = "Block requests with very low reCAPTCHA scores (likely bots)"
      preview     = false
    },
    {
      priority    = 800
      action      = "deny(403)"
      expression  = "request.headers['user-agent'].matches('(?i)(?:sqlmap|nikto|nmap|curlzilla|badbotscanner|python-requests-malicious)')" // Use non-capturing group (?:...)
      description = "Block requests from known malicious or undesirable User-Agents"
      preview     = false
    },
    {
      priority    = 950
      action      = "deny(403)"
      expression  = "!has(request.headers['user-agent']) || request.headers['user-agent'] == ''"
      description = "Block requests with no User-Agent header or empty User-Agent"
      preview     = false
    },
    {
      priority    = 11000
      action      = "throttle"
      expression  = "request.headers['referer'].contains('check-host.net')"
      rate_limit_options = {
        rate_limit_threshold = {
          count = 2,
          interval_sec = 10
        },
        conform_action = "allow",
        exceed_action = "deny(502)",
        enforce_on_key_configs = [
          {
            key_type = "ALL"
          }
        ]
      }
      description = "check-host referer fud"
      preview     = false
    },
    {
      priority    = 11006
      action      = "rate_based_ban"
      expression  = "request.headers['host'].startsWith('order.store')"
      rate_limit_options = {
        rate_limit_threshold = {
          count = 5,
          interval_sec = 10
        },
        conform_action = "allow",
        exceed_action = "deny(429)",
        enforce_on_key_configs = [
          {
            key_type = "IP"
          }
        ],
        ban_duration_sec = 300,
        ban_threshold = {
          count = 25,
          interval_sec = 60
        }
      },
      description = "Throttle apex domain traffic order.store SWNEDGE-2349"
      preview     = false
    },
    {
      priority    = 30001
      action      = "rate_based_ban"
      expression  = "request.headers['x-ddrt'] == 'meris_attack' && request.method.upper() == 'GET' && !request.headers['host'].lower().matches('^email|^click|^static-maps')"
      rate_limit_options = {
        rate_limit_threshold = {
          count = 500,
          interval_sec = 10
        },
        conform_action = "allow",
        exceed_action = "deny(404)",
        enforce_on_key_configs = [
          {
            key_type = "ALL"
          }
        ],
        ban_duration_sec = 300,
        ban_threshold = {
          count = 3000,
          interval_sec = 60
        }
      },
      description = "meris attack get"
      preview     = false
    },
    {
      priority    = 30002
      action      = "throttle"
      expression  = "has(request.headers['X-DDRT']) && request.headers['X-DDRT'].lower().startsWith('meris_attack')"
      rate_limit_options = {
        rate_limit_threshold = {
          count = 9999,
          interval_sec = 10
        },
        conform_action = "allow",
        exceed_action = "deny(404)",
        enforce_on_key_configs = [
          {
            key_type = "ALL"
          }
        ]
      },
      description = "overall meris-attack"
      preview     = false
    },
    {
      priority    = 30010
      action      = "rate_based_ban"
      expression  = "has(request.headers['X-DDRT']) && request.headers['X-DDRT'].lower().startsWith('meris_ip')"
      rate_limit_options = {
        rate_limit_threshold = {
          count = 500,
          interval_sec = 10
        },
        conform_action = "allow",
        exceed_action = "deny(403)",
        enforce_on_key_configs = [
          {
            key_type = "ALL"
          }
        ],
        ban_duration_sec = 300,
        ban_threshold = {
          count = 3000,
          interval_sec = 60
        }
      },
      description = "meris ip"
      preview     = false
    },
    {
      priority    = 30030
      action      = "throttle"
      expression  = "origin.region_code.matches('CN|TH|VN|PH|ID|MY|RU') && request.method.upper() == 'GET'"
      rate_limit_options = {
        rate_limit_threshold = {
          count = 500,
          interval_sec = 10
        },
        conform_action = "allow",
        exceed_action = "deny(403)",
        enforce_on_key_configs = [
          {
            key_type = "IP"
          }
        ]
      },
      description = "Throttle reqs from countries with high attack rate SWNEDGE-2401"
      preview     = false
    },
    {
      priority    = 30100
      action      = "throttle"
      expression  = "evaluatePreconfiguredWaf('scannerdetection-v33-stable', {'sensitivity': 1})"
      rate_limit_options = {
        rate_limit_threshold = {
          count = 1000,
          interval_sec = 10
        },
        conform_action = "allow",
        exceed_action = "deny(403)",
        enforce_on_key = "HTTP_HEADER",
        enforce_on_key_name = "Host"
      },
      description = "SWNEDGE-2532 waf for scanner eval (preview ONLY)"
      preview     = false
    },
    {
      priority    = 100001
      action      = "deny(403)"
      expression  = "evaluateThreatIntelligence('iplist-known-malicious-ips')"
      description = "Block requests from known malicious IPs"
      preview     = false
    },
    {
      priority    = "7000"
      action      = "deny(403)"
      preview     = false
      expression  = "origin.region_code.matches('AF|AL|BD|BY|BF|BI|CF|CI|CU|CD|EG|HT|HN|IR|IQ|IL|LB|LR|LY|ML|MM|KP|PS|PK|RU|RW|SO|SS|SD|SY|UA|VE|VN|YE|ZW')"
      description = "Block users from specific countries except China"
    },
    {
      priority    = "7002"
      action      = "deny(403)"
      preview     = false
      expression  = "(request.headers['host'].lower() == 'tms.transplace.com' || request.headers['host'].lower() == 'uattms.transplace.com') && request.path.startsWith('/api-docs')"
      description = "Block /api-docs for tms.transplace.com and uattms.transplace.com"
    },
    {
      priority    = "7004"
      action      = "deny(403)"
      preview     = false
      expression  = "(request.headers['host'].lower() == 'laser.tplaser.com.mx' || request.headers['host'].lower() == 'uatlaser.transplace.com') && request.path.startsWith('/WebApiTransportData')" // Changed request.uri.path to request.path
      description = "Block /WebApiTransportData for laser.tplaser.com.mx and uatlaser.transplace.com"
    },
    {
      priority = "10000"
      action   = "deny(403)"
      preview = false
      expression = "evaluatePreconfiguredWaf('php-v33-stable', {'sensitivity': 1})"
      description = "PHP - OWASP Rule"
    },
    {
      priority = "11001"
      action   = "deny(403)"
      preview = false
      expression = "evaluatePreconfiguredWaf('sqli-v33-stable', {'sensitivity': 1})"
      description = "SQLi - OWASP Rule"
    },
    {
      priority = "12000"
      action   = "deny(403)"
      preview = false
      expression = "evaluatePreconfiguredWaf('xss-v33-stable', {'sensitivity': 1})"
      description = "XSS - OWASP Rule"
    },
    {
      priority = "13000"
      action   = "deny(403)"
      preview = false
      expression = "evaluatePreconfiguredWaf('lfi-v33-stable', {'sensitivity': 1})"
      description = "LFI - OWASP Rule"
    },
    {
      priority = "14000"
      action   = "deny(403)"
      preview = false
      expression = "evaluatePreconfiguredWaf('rfi-v33-stable', {'sensitivity': 1})"
      description = "RFI - OWASP Rule"
    },
    {
      priority = "15000"
      action   = "deny(403)"
      preview = false
      expression = "evaluatePreconfiguredWaf('rce-v33-stable', {'sensitivity': 1})"
      description = "RCE - OWASP Rule"
    },
    {
      priority = "16000"
      action   = "deny(403)"
      preview = false
      expression = "evaluatePreconfiguredWaf('methodenforcement-v33-stable', {'sensitivity': 1})"
      description = "Method Enforcement - OWASP Rule"
    },
    {
      priority = "17000"
      action   = "deny(403)"
      preview = false
      expression = "evaluatePreconfiguredWaf('scannerdetection-v33-stable', {'sensitivity': 1})"
      description = "Scanner Detection - OWASP Rule"
    },
    {
      priority = "18000"
      action   = "deny(403)"
      preview = false
      expression = "evaluatePreconfiguredWaf('protocolattack-v33-stable', {'sensitivity': 1})"
      description = "Protocol Attack - OWASP Rule"
    },
    {
      priority = "19000"
      action   = "deny(403)"
      preview = false
      expression = "evaluatePreconfiguredWaf('sessionfixation-v33-stable', {'sensitivity': 1})"
      description = "Session Fixation - OWASP Rule"
    },
    {
      priority = "20000"
      action   = "deny(403)"
      preview = false
      expression = "evaluatePreconfiguredWaf('nodejs-v33-stable', {'sensitivity': 1})"
      description = "Node.js - OWASP Rule"
    },
    {
      priority = "21000"
      action   = "deny(403)"
      preview = false
      expression = "evaluatePreconfiguredWaf('java-v33-stable', {'sensitivity': 3})"
      description = "Java - OWASP Rule"
    },
    {
      priority = "22000"
      action   = "deny(403)"
      preview = false
      expression = "evaluatePreconfiguredWaf('cve-canary', {'sensitivity': 3})"
      description = "Critical vulnerabilities rule"
    },
    {
      priority    = 601
      action      = "deny(403)"
      expression  = "evaluateThreatIntelligence('iplist-known-malicious-ips')"
      description = "Block HTML requests from known malicious IPs"
      preview     = false
    },
    {
      priority    = 602
      action      = "deny(403)"
      expression  = "evaluateThreatIntelligence('iplist-tor-exit-nodes')"
      description = "Block requests from TOR exit nodes"
      preview     = false
    },
    {
      priority    = 7001
      action      = "deny(403)"
      preview     = false
      expression  = "(origin.region_code == 'CN') && !(request.headers['host'].lower().matches('^tms[.]transplace[.]com$|^fed[.]transplace[.]com$'))"
      description = "Block users from China (excluding Hong Kong) except for tms.transplace.com and fed.transplace.com. This rule does not affect Hong Kong (region_code HK)."
    },
    {
      priority    = "7005"
      action      = "allow"
      preview     = false
      expression  = <<EOF
    (request.headers['host'].lower().matches('^(?:sonarqube[.]transplace[.]com|cicd[.]uberfreight[.]com|cicd-nonprod[.]uberfreight[.]com)$')) && (inIpRange(origin.ip, '192.30.252.0/22') || inIpRange(origin.ip, '185.199.108.0/22') || inIpRange(origin.ip, '140.82.112.0/20'))
    EOF
      description = "Part 1: For specified domains, ALLOW access if source IP is in the first explicitly allowed IP whitelist."
    },
    {
      priority    = "7006"
      action      = "allow"
      preview     = false
      expression  = <<EOF
    (request.headers['host'].lower().matches('^(?:sonarqube[.]transplace[.]com|cicd[.]uberfreight[.]com|cicd-nonprod[.]uberfreight[.]com)$')) && (inIpRange(origin.ip, '143.55.64.0/20') || inIpRange(origin.ip, '2a0a:a440::/29') || inIpRange(origin.ip, '2606:50c0::/32'))
    EOF
      description = "Part 2: For specified domains, ALLOW access if source IP is in the second explicitly allowed IP whitelist."
    },
    {
      priority    = "7007"
      action      = "deny(403)"
      preview     = false
      expression  = <<EOF
    request.headers['host'].lower().matches('^(?:sonarqube[.]transplace[.]com|cicd[.]uberfreight[.]com|cicd-nonprod[.]uberfreight[.]com)$')
    EOF
      description = "For specified domains, DENY access if the source IP was NOT in any of the preceding whitelists."
    },
    {
      priority    = "2000"
      action      = "deny(403)"
      preview     = false
      description = "Block specific sensitive paths for uatapps9.tplaser.com.mx and apps9.tplaser.com.mx."
      expression  = <<EOF
    (request.headers['host'].lower().matches('^(?:uatapps9[.]tplaser[.]com[.]mx|apps9[.]tplaser[.]com[.]mx)$')) && (request.path == '/lasersoft2/upload3.aspx' || request.path == '/Backup_slamsedsmx' || request.path == '/Boletines')
    EOF
    },
  ]
}

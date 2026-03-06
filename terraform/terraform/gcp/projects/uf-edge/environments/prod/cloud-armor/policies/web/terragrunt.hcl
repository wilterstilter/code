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
      expression  = <<-EOL
        request.headers['accept'].lower().contains('text/html') &&
        evaluateThreatIntelligence('iplist-public-clouds') &&
        !origin.ip.matches('^(?:35\\.247\\.56\\.174|34\\.168\\.148\\.150|34\\.169\\.76\\.82|34\\.83\\.181\\.142|35\\.230\\.31\\.124|35\\.247\\.120\\.185|35\\.233\\.245\\.185|34\\.145\\.30\\.110|34\\.168\\.66\\.80|34\\.168\\.184\\.166|34\\.187\\.168\\.154|35\\.197\\.57\\.190)$')
      EOL
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
      preview     = true
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
      priority    = 500
      action      = "allow"
      preview     = false
      description = "Allow Zscaler ASNs and known ranges (unconditional)"
      expression  = "origin.asn == 22616 || origin.asn == 53813 || origin.asn == 62044 || inIpRange(origin.ip, '136.226.0.0/16') || inIpRange(origin.ip, '165.225.0.0/17')"
    },
    {
      priority    = "900"
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
      expression  = "(request.headers['host'].lower() == 'laser.tplaser.com.mx' || request.headers['host'].lower() == 'uatlaser.transplace.com') && request.path.startsWith('/WebApiTransportData')"
      description = "Block /WebApiTransportData for laser.tplaser.com.mx and uatlaser.transplace.com"
    },
    {
      priority = "10000"
      action   = "deny(403)"
      preview = false
      expression = "evaluatePreconfiguredWaf('php-v33-stable', {'sensitivity': 3})"
      description = "PHP - OWASP Rule"
    },
    {
      priority = "11001"
      action   = "deny(403)"
      preview = false
      expression = "evaluatePreconfiguredWaf('sqli-v33-stable', {'sensitivity': 3, 'opt_out_rule_ids': ['owasp-crs-v030301-id942420-sqli']}) && !request.headers['host'].lower().matches('^(?:(?:qa-my|dev-my|my)[.]lanehub[.]com|[^.]+[.]uat[.]orloetest[.]com|[^.]+[.]orloe[.]com)$')"
      description = "SQLi - OWASP Rule (excludes lanehub domains)"
    },
    {
      priority = "12000"
      action   = "deny(403)"
      preview = true
      expression = "evaluatePreconfiguredWaf('xss-v33-stable', {'sensitivity': 2})"
      description = "XSS - OWASP Rule"
    },
    {
      priority = "13000"
      action   = "deny(403)"
      preview = false
      expression = "evaluatePreconfiguredWaf('lfi-v33-stable', {'sensitivity': 2})"
      description = "LFI - OWASP Rule"
    },
    {
      priority = "14000"
      action   = "deny(403)"
      preview = false
      expression = "evaluatePreconfiguredWaf('rfi-v33-stable', {'sensitivity': 2})"
      description = "RFI - OWASP Rule"
    },
    {
      priority = "16000"
      action   = "deny(403)"
      preview = false
      expression = "evaluatePreconfiguredWaf('methodenforcement-v33-stable', {'sensitivity': 2}) && !(request.headers['content-type'].lower().contains('application/json'))"
      description = "Method Enforcement - OWASP Rule"
    },
    {
      priority = "17000"
      action   = "deny(403)"
      preview = false
      expression = "evaluatePreconfiguredWaf('scannerdetection-v33-stable', {'sensitivity': 2})"
      description = "Scanner Detection - OWASP Rule"
    },
    {
      priority = "18000"
      action   = "deny(403)"
      preview = false
      expression = "evaluatePreconfiguredWaf('protocolattack-v33-stable', {'sensitivity': 3})"
      description = "Protocol Attack - OWASP Rule"
    },
    {
      priority = "19000"
      action   = "deny(403)"
      preview = false
      expression = "evaluatePreconfiguredWaf('sessionfixation-v33-stable', {'sensitivity': 3})"
      description = "Session Fixation - OWASP Rule"
    },
    {
      priority = "20000"
      action   = "deny(403)"
      preview = false
      expression = "evaluatePreconfiguredWaf('nodejs-v33-stable', {'sensitivity': 2})"
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
      priority    = 901
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
    (request.headers['host'].lower().matches('^(?:uatapps9[.]tplaser[.]com[.]mx|apps9[.]tplaser[.]com[.]mx)$')) && (request.path == '/lasersoft2/upload3.aspx' || request.path.startsWith('/Backup_slamsedsmx/') || request.path.startsWith('/Boletines/'))
    EOF
    },
    {
      priority    = 1000
      action      = "allow"
      preview     = false
      description = "Allow trusted GraphQL endpoint for tplaser customs domains to to fix OWASP false positives"
      expression  = "(request.headers['host'].lower().matches('^(?:uatcustomswmsapi|customswmsapi)[.]tplaser[.]com[.]mx$')) && (request.method == 'POST' && request.path == '/v1-2-7/graphql/')"
    },
    {
      priority = "15000"
      action   = "deny(403)"
      preview = false
      expression = "evaluatePreconfiguredWaf('rce-v33-stable', {'sensitivity': 1})"
      description = "RCE - OWASP Rule"
    },
    {
      priority    = 1001
      action      = "allow"
      preview     = false
      description = "Allow standard API methods (PATCH, DELETE) for the TMS v2 API to fix WAF false positives."
      expression  = "(request.headers['host'] == 'uattms.transplace.com' || request.headers['host'] == 'tms.transplace.com') && (request.path.startsWith('/tms/api/v2/') && request.method == 'PATCH')"
    },
    {
      priority    = 1002
      action      = "allow"
      preview     = false
      description = "Allow DELETE method for the TMS v2 API to fix WAF false positives."
      expression  = "(request.headers['host'] == 'uattms.transplace.com' || request.headers['host'] == 'tms.transplace.com') && (request.path.startsWith('/tms/api/v2/') && request.method == 'DELETE')"
    },
    {
      priority    = 1003
      action      = "allow"
      preview     = false
      description = "Allow standard API methods (GET, POST) for the TMS v2 and v3 API to fix WAF false positives."
      expression  = "request.headers['host'].lower().matches('^(?:uattms|tms)[.]transplace[.]com$') && request.path.matches('^/tms/api/v(?:2|3)/') && request.method.matches('^(?:GET|POST)$')"
    },
    {
      priority    = 1004
      action      = "allow"
      preview     = false
      description = "Allow specific paths for uattms and tms domains to fix OWASP false positives (Part 1)."
      expression  = "(request.headers['host'] == 'uattms.transplace.com' || request.headers['host'] == 'tms.transplace.com') && (request.path.startsWith('/dms/') || request.path.startsWith('/ratingmaintenance/') || request.path.startsWith('/smp/'))"
    },
    {
      priority    = 1005
      action      = "allow"
      preview     = false
      description = "Allow specific paths for uattms and tms domains to fix OWASP false positives (Part 2)."
      expression  = "(request.headers['host'] == 'uattms.transplace.com' || request.headers['host'] == 'tms.transplace.com') && (request.path.startsWith('/tms/') || request.path.startsWith('/cp/') || request.path.startsWith('/alert-service/'))"
    },
    {
      priority    = 1006
      action      = "allow"
      preview     = false
      description = "Allow standard API methods (PUT, OPTIONS) for the TMS v2 and v3 API to fix WAF false positives."
      expression  = "(request.path.startsWith('/tms/api/v2/') || request.path.startsWith('/tms/api/v3/')) && (request.method == 'PUT' || request.method == 'OPTIONS')"
    },
    {
      priority    = 1007
      action      = "allow"
      preview     = false
      description = "Allow mobile-access API paths for uattms and tms domains fix OWASP false positives."
      expression  = "(request.headers['host'] == 'uattms.transplace.com' || request.headers['host'] == 'tms.transplace.com') && (request.path.startsWith('/mobile-access/') || (request.path.startsWith('/sidekick/') || request.path.startsWith('/draco/')))"
    },
    {
      priority    = "2001"
      action      = "deny(403)"
      preview     = false
      description = "Block sensitive paths for tplaser domains (Part 1)."
      expression  = <<EOF
    (request.headers['host'].lower().matches('^(?:uatapps9[.]tplaser[.]com[.]mx|apps9[.]tplaser[.]com[.]mx)$')) && (request.path.startsWith('/Cdlaser/') || request.path.startsWith('/cover/') || request.path.startsWith('/Login/') || request.path.startsWith('/CustomsE/'))
    EOF
    },
    {
      priority    = "2002"
      action      = "deny(403)"
      preview     = false
      description = "Block sensitive paths for tplaser domains (Part 2)."
      expression  = <<EOF
    (request.headers['host'].lower().matches('^(?:uatapps9[.]tplaser[.]com[.]mx|apps9[.]tplaser[.]com[.]mx)$')) && (request.path.startsWith('/Distribution/') || request.path.startsWith('/Distribution1/') || request.path.startsWith('/fotossmx/') || request.path.startsWith('/laserbillboard_laser4/'))
    EOF
    },
    {
      priority    = "2003"
      action      = "deny(403)"
      preview     = false
      description = "Block sensitive paths for tplaser domains (Part 3)."
      expression  = <<EOF
    (request.headers['host'].lower().matches('^(?:uatapps9[.]tplaser[.]com[.]mx|apps9[.]tplaser[.]com[.]mx)$')) && (request.path.startsWith('/LaserShipping/') || request.path.startsWith('/led_desktop/') || request.path.startsWith('/Logistica/') || request.path.startsWith('/Recibo/'))
    EOF
    },
    {
      priority    = "2004"
      action      = "deny(403)"
      preview     = false
      description = "Block sensitive paths for tplaser domains (Part 4)."
      expression  = <<EOF
    (request.headers['host'].lower().matches('^(?:uatapps9[.]tplaser[.]com[.]mx|apps9[.]tplaser[.]com[.]mx)$')) && (request.path.startsWith('/slamsed/') || request.path.startsWith('/slamsedsr/') || request.path.startsWith('/Tarifa/') || request.path.startsWith('/WebApiTransport/'))
    EOF
    },
    {
      priority    = "2005"
      action      = "deny(403)"
      preview     = false
      description = "Block sensitive paths for tplaser domains (Part 5)."
      expression  = <<EOF
    (request.headers['host'].lower().matches('^(?:uatapps9[.]tplaser[.]com[.]mx|apps9[.]tplaser[.]com[.]mx)$')) && (request.path.startsWith('/TransportC/') || request.path.startsWith('/kiosk/') || request.path.startsWith('/kpis/') || request.path.startsWith('/LaserWare1/'))
    EOF
    },
    {
      priority    = "2006"
      action      = "deny(403)"
      preview     = false
      description = "Block sensitive paths for tplaser domains (Part 6)."
      expression  = <<EOF
    (request.headers['host'].lower().matches('^(?:uatapps9[.]tplaser[.]com[.]mx|apps9[.]tplaser[.]com[.]mx)$')) && (request.path.startsWith('/lw4/') || request.path == '/LaserShipping/revision.aspx')
    EOF
    },
    {
      priority    = 1008
      action      = "allow"
      preview     = false
      description = "Allow drome-v2, JNLP, and DMS remoting endpoint on uattms/tms."
      expression  = "(request.headers['host'].lower().matches('^(?:uattms|tms)[.]transplace[.]com$')) && (request.path.startsWith('/drome-v2/') || request.path == '/tms/sendToQueue.jnlp' || request.path == '/dms/remoting/DocumentService')"
    },
    {
      priority    = 949
      action      = "allow"
      preview     = false
      description = "Allow Lanehub CMS, Uploads, Kentico API (all methods)"
      expression  = "request.headers['host'].lower().matches('^(?:qa-my|dev-my|my)[.]lanehub[.]com$') && (request.path.startsWith('/CMS') || request.path.startsWith('/Uploads') || request.path.startsWith('/api-session-enabled/'))"
    },
    {
      priority    = 1010
      action      = "allow"
      preview     = false
      description = "Allow RichFaces upload; protocolattack 921150 FP"
      expression  = "(request.headers['host'].lower().matches('^(?:uattms|tms)[.]transplace[.]com$')) && request.method == 'POST' && request.path == '/cp/search.jsf' && request.headers['content-type'].lower().contains('multipart/form-data')"
    },
    {
      priority    = 948
      action      = "throttle"
      preview     = false
      description = "Rate limit empty-UA HEAD globally for uattms/tms; allow under threshold"
      expression  = "request.headers['host'].lower().matches('^(?:uattms|tms)[.]transplace[.]com$') && (!has(request.headers['user-agent']) || request.headers['user-agent'] == '') && request.method == 'HEAD'"
      rate_limit_options = {
        rate_limit_threshold = { count = 120, interval_sec = 60 }
        conform_action       = "allow"
        exceed_action        = "deny(429)"
        enforce_on_key       = "IP"
      }
    },
    {
      priority    = 947
      action      = "throttle"
      preview     = false
      description = "Rate limit empty-UA GET on safe paths for uattms/tms"
      expression  = "request.headers['host'].lower().matches('^(?:uattms|tms)[.]transplace[.]com$') && (!has(request.headers['user-agent']) || request.headers['user-agent'] == '') && request.method == 'GET' && request.path.matches('^(?:/|/web/.*|/ct/.*|/tms/.*|/io/v1/.*|/api-platform-support-service/actuator/health|/tms/api/v2/swagger-ui[.]html)$')"
      rate_limit_options = {
        rate_limit_threshold = { count = 1000, interval_sec = 60 }
        conform_action       = "allow"
        exceed_action        = "deny(429)"
        enforce_on_key       = "IP"
      }
    },
    {
      priority    = 1011
      action      = "allow"
      preview     = false
      description = "fix OWASP false positives for cookie FPs on CT, security, favicon"
      expression  = "request.headers['host'].lower().matches('^(?:uattms|tms)[.]transplace[.]com$') && (request.path.startsWith('/ct/') || request.path.startsWith('/security/') || request.path == '/favicon.ico')"
    },
    {
      priority    = 1012
      action      = "allow"
      preview     = false
      description = "fix OWASP false positives for cookie FPs on ptms, ratingmaintenance"
      expression  = "request.headers['host'].lower().matches('^(?:uattms|tms)[.]transplace[.]com$') && (request.path.startsWith('/ptms/') || request.path.startsWith('/ratingexternal/') || request.path.startsWith('/web/'))"
    },
    {
      priority    = 940
      action      = "allow"
      preview     = false
      description = "Allow ADFS sign-on for fed domains to fix OWASP false positives."
      expression  = "request.headers['host'].lower().matches('^(?:uatfed|fed)[.]transplace[.]com$') && request.path.startsWith('/adfs/')"
    },
    {
      priority    = 1015
      action      = "allow"
      preview     = false
      description = "Allow BI SAML SSO for uatbi and bi domains to fix OWASP false positives."
      expression  = "request.headers['host'].lower().matches('^(?:uatbi|bi)[.]transplace[.]com$') && request.path.matches('^/(?:wg/saml/|oauth2/v1/|dataserver(?:/|$)|img/.*|en/embedded.*|t/.*)')"
    },
    {
      priority    = 945
      action      = "allow"
      preview     = false
      description = "Allow requests with primary session cookies (TMSSessionID, CONTROL_TOWER) to fix OWASP false positives."
      expression  = "(request.headers['host'] == 'uattms.transplace.com' || request.headers['host'] == 'tms.transplace.com') && has(request.headers['cookie']) && (request.headers['cookie'].contains('TMSSessionID') || request.headers['cookie'].contains('CONTROL_TOWER'))"
    },
    {
      priority    = 946
      action      = "allow"
      preview     = false
      description = "Allow requests with DNE session cookies to fix OWASP false positives."
      expression  = "request.headers['host'].lower().matches('^(?:uattms|tms)[.]transplace[.]com$') && has(request.headers['cookie']) && request.headers['cookie'].contains('DNE.')"
    },
    {
      priority    = 1017
      action      = "allow"
      preview     = false
      description = "Allow specific ASP.NET paths for my.lanehub domains to fix OWASP false positives."
      expression  = "request.headers['host'].lower().matches('^(?:qa-my|dev-my|my)[.]lanehub[.]com$') && (request.path.startsWith('/Admin/') || request.path.startsWith('/api/customer/') || request.path.startsWith('/System/Base-Lanes'))"
    },
    {
      priority    = 1018
      action      = "allow"
      preview     = false
      description = "Allow FacturaImportacion and Mobile on customsportal domains to fix OWASP false positives."
      expression  = "request.headers['host'].lower().matches('^(?:uat)?customsportal[.]tplaser[.]com[.]mx$') && (request.path.startsWith('/Portal/') || request.path.startsWith('/Mobile/') || request.path.startsWith('/resources/') || request.path.startsWith('/api/'))"
    },
    {
      priority    = 1009
      action      = "allow"
      preview     = false
      description = "Allow F5 application paths for uattms and tms domains to fix OWASP false positives (Part 3)"
      expression  = "request.headers['host'].lower().matches('^(?:uattms|tms)[.]transplace[.]com$') && (request.path.startsWith('/tracking/') || request.path.startsWith('/io/') || request.path.startsWith('/alert-service/') || request.path.startsWith('/api-platform-support-service/'))"
    },
    {
      priority    = 1019
      action      = "allow"
      preview     = false
      description = "Allow F5 application paths for uattms and tms domains to fix OWASP false positives (Part 4)"
      expression  = "request.headers['host'].lower().matches('^(?:uattms|tms)[.]transplace[.]com$') && (request.path.startsWith('/configuration/') || request.path.startsWith('/drome/') || request.path.startsWith('/draco-es-client-svc/') || request.path.startsWith('/ratingexternal/'))"
    },
    {
      priority    = 1020
      action      = "allow"
      preview     = false
      description = "Allow F5 application paths for uattms and tms domains to fix OWASP false positives (Part 5)"
      expression  = "request.headers['host'].lower().matches('^(?:uattms|tms)[.]transplace[.]com$') && (request.path.startsWith('/ust/') || request.path.startsWith('/control-tower/') || request.path.startsWith('/settings/') || request.path.startsWith('/rateapproval/'))"
    },
    {
      priority    = 1021
      action      = "allow"
      preview     = false
      description = "Allow F5 application paths for uattms and tms domains to fix OWASP false positives (Part 6)"
      expression  = "request.headers['host'].lower().matches('^(?:uattms|tms)[.]transplace[.]com$') && (request.path.startsWith('/cms/') || request.path.startsWith('/transmatch/') || request.path.startsWith('/xml-api/') || request.path.startsWith('/sku/'))"
    },
    {
      priority    = 1022
      action      = "allow"
      preview     = false
      description = "Allow F5 application paths for uattms and tms domains to fix OWASP false positives (Part 7)"
      expression  = "request.headers['host'].lower().matches('^(?:uattms|tms)[.]transplace[.]com$') && (request.path.startsWith('/location-web/') || request.path.startsWith('/ops/') || request.path.startsWith('/op-dev-supporttools/') || request.path.startsWith('/onboarding-support-service/'))"
    },
    {
      priority    = 1023
      action      = "allow"
      preview     = false
      description = "Allow F5 application paths for uattms and tms domains to fix OWASP false positives (Part 8)"
      expression  = "request.headers['host'].lower().matches('^(?:uattms|tms)[.]transplace[.]com$') && (request.path.startsWith('/tmssidekick/') || request.path.startsWith('/poctrial/') || request.path.startsWith('/mid-tier/') || request.path.startsWith('/eda-service/'))"
    },
    {
      priority    = 1024
      action      = "allow"
      preview     = false
      description = "Allow F5 application paths for uattms and tms domains to fix OWASP false positives (Part 9)"
      expression  = "request.headers['host'].lower().matches('^(?:uattms|tms)[.]transplace[.]com$') && request.path.startsWith('/otd/')"
    },
    {
      priority    = 1025
      action      = "allow"
      preview     = false
      description = "Allow F5 application paths for uattmsservices and tmsservices domains to fix OWASP false positives (Part 1)"
      expression  = "request.headers['host'].lower().matches('^(?:uattms|tms)services[.]transplace[.]com$') && (request.path.startsWith('/tms/') || request.path.startsWith('/security/') || request.path.startsWith('/yms/') || request.path.startsWith('/tracking/'))"
    },
    {
      priority    = 1026
      action      = "allow"
      preview     = false
      description = "Allow F5 application paths for uattmsservices and tmsservices domains to fix OWASP false positives (Part 2)"
      expression  = "request.headers['host'].lower().matches('^(?:uattms|tms)services[.]transplace[.]com$') && (request.path.startsWith('/tracking-proxy/') || request.path.startsWith('/op-dev-supporttools/'))"
    },
    {
      priority    = 1027
      action      = "allow"
      preview     = false
      description = "Allow additional F5 application paths for uattms and tms domains to fix OWASP false positives (Part 10)"
      expression  = "request.headers['host'].lower().matches('^(?:uattms|tms)[.]transplace[.]com$') && (request.path.startsWith('/tpm/') || request.path.startsWith('/pomm/'))"
    },
    {
      priority    = 998
      action      = "deny(403)"
      preview     = false
      description = "Block LFI and Protocol attacks on /security/basf path for uattms and tms domains"
      expression  = "request.headers['host'].lower().matches('^(?:uattms|tms)[.]transplace[.]com$') && request.path.startsWith('/security/basf') && (evaluatePreconfiguredWaf('lfi-v33-stable', {'sensitivity': 1}) || evaluatePreconfiguredWaf('protocolattack-v33-stable', {'sensitivity': 1}))"
    },
    {
      priority    = 942
      action      = "allow"
      preview     = false
      description = "Allow /ptms APIs for uatptms/ptms domains to fix OWASP false positives"
      expression  = "request.headers['host'].lower().matches('^(?:uatptms|ptms)[.]transplace[.]com$') && request.path.startsWith('/ptms/')"
    },
    {
      priority    = 505
      action      = "allow"
      preview     = false
      description = "Allow Palo Alot ASNs and known ranges (unconditional) to fix OWASP false positives"
      expression  = "origin.asn == 3356 || inIpRange(origin.ip, '104.129.192.0/20')"
    },
    {
      priority    = 1028
      action      = "allow"
      preview     = false
      description = "Allow Celtic UAT/Dispatch upload paths (/image/, /analytics/, /rez1/, /soa/, /draytest/, /dray/) to fix OWASP false positives"
      expression  = <<EOF
        (request.headers['host'].lower().matches('^(?:[^.]+[.]celtic-uat[.]celticintl[.]com|[^.]+[.]dispatch3[.]celticintl[.]com)$')) &&
        request.path.matches('^(?:/image/|/analytics/|/rez1/|/soa/|/draytest/|/dray/|/cgi-bin/|/sse/).*')
      EOF
    },
    {
      priority    = 1029
      action      = "allow"
      preview     = false
      description = "Allow /customer/ on *.uat.orloetest.com and *.orloe.com to fix OWASP false positives"
      expression  = <<EOF
        (request.headers['host'].lower().matches('^(?:[^.]+[.]uat[.]orloetest[.]com|[^.]+[.]orloe[.]com)$')) &&
        request.path.matches('^/customer/.*')
      EOF
    },
    {
      priority    = 1030
      action      = "allow"
      preview     = false
      description = "Allow /tracking/, /Tracking/, and /Portals/ for devinternational.transplace.com and international.transplace.com to fix OWASP false positives"
      expression  = <<EOF
        (request.headers['host'].lower().matches('^(?:devinternational|international)[.]transplace[.]com$')) &&
        (
          request.path.startsWith('/tracking/') ||
          request.path.startsWith('/Tracking/') ||
          request.path.startsWith('/Glow/') ||
          request.path.startsWith('/Portals/')
        )
      EOF
    },
    {
      priority    = 1031
      action      = "allow"
      preview     = false
      description = "Allow /vizql, /vizportal, /content-exploration, and /api for uatbi.transplace.com and bi.transplace.com to fix OWASP false positives"
      expression  = <<EOF
        (request.headers['host'].lower().matches('^(?:uatbi|bi)[.]transplace[.]com$')) &&
        (request.path.startsWith('/vizql/') || request.path.startsWith('/vizportal/') || request.path.startsWith('/content-exploration/') || request.path.startsWith('/api/'))
      EOF
    },
    {
      priority    = "1032"
      action      = "allow"
      preview     = false
      description = "Allow /portal*, /LaserWG/, /laserwg/ for uatapps9.tplaser.com.mx and apps9.tplaser.com.mx to fix OWASP false positives"
      expression  = <<EOF
    (request.headers['host'].lower().matches('^(?:uatapps9[.]tplaser[.]com[.]mx|apps9[.]tplaser[.]com[.]mx)$')) && (request.path.startsWith('/portal') || request.path.startsWith('/WebSiteCartaPorteSMX/') || request.path.startsWith('/LaserWG/') || request.path.startsWith('/laserwg/'))
    EOF
    },
    {
      priority    = 1033
      action      = "allow"
      preview     = false
      description = "Allow ASHX endpoint for carrierdb.transplace.com to fix OWASP false positives"
      expression  = <<EOF
        (request.headers['host'].lower() == 'carrierdb.transplace.com') && (request.path.startsWith('/ashx/') || request.path.startsWith('/views/'))
      EOF
    },
    {
      priority    = 1034
      action      = "allow"
      preview     = false
      description = "Allow /api/1.0/tracking, /fotossmx/, /webcontainer/, /WebContainerApi/ for laser.tplaser.com.mx and uatlaser.tplaser.com.mx to fix OWASP false positives"
      expression  = <<EOF
        (request.headers['host'].lower().matches('^(?:uatlaser|laser)[.]tplaser[.]com[.]mx$')) && request.path.matches('^(?:/api/1.0/tracking|/fotossmx/|/webcontainer/|/TransSoft/ashx/|/WebContainerApi/).*')
      EOF
    },
    {
      priority    = 550
      action      = "deny(403)"
      expression  = "origin.ip == '84.239.37.16'"
      description = "Block abusive IP 84.239.37.16"
      preview     = false
    },
    {
      priority    = 1035
      action      = "allow"
      preview     = false
      description = "Allow portals/uploads/transportation paths for *.uat.orloetest.com and *.orloe.com to fix OWASP false positives"
      expression  = <<EOF
        (request.headers['host'].lower().matches('^(?:[^.]+[.]uat[.]orloetest[.]com|[^.]+[.]orloe[.]com)$')) &&
        request.path.matches('(?i)^(?:/portals|/uploaded-|/upload|/transportation|/socket[.]io|/api/v1/|/orders|/document_management/|/v1/openOrders/|/automation/|/contact/).*')
      EOF
    },
    {
      priority = "400"
      action   = "deny(403)"
      preview = true
      expression = "evaluatePreconfiguredWaf('php-v33-stable', {'sensitivity': 3})"
      description = "PHP - OWASP Rule"
    },
    {
      priority = "401"
      action   = "deny(403)"
      preview = true
      expression = "evaluatePreconfiguredWaf('sqli-v33-stable', {'sensitivity': 2})"
      description = "SQLi - OWASP Rule (excludes lanehub domains)"
    },
    {
      priority = "402"
      action   = "deny(403)"
      preview = true
      expression = "evaluatePreconfiguredWaf('xss-v33-stable', {'sensitivity': 2})"
      description = "XSS - OWASP Rule"
    },
    {
      priority = "403"
      action   = "deny(403)"
      preview = true
      expression = "evaluatePreconfiguredWaf('lfi-v33-stable', {'sensitivity': 2})"
      description = "LFI - OWASP Rule"
    },
    {
      priority = "404"
      action   = "deny(403)"
      preview = true
      expression = "evaluatePreconfiguredWaf('rfi-v33-stable', {'sensitivity': 2})"
      description = "RFI - OWASP Rule"
    },
    {
      priority = "405"
      action   = "deny(403)"
      preview = true
      expression = "evaluatePreconfiguredWaf('methodenforcement-v33-stable', {'sensitivity': 2}) && !(request.headers['content-type'].lower().contains('application/json'))"
      description = "Method Enforcement - OWASP Rule"
    },
    {
      priority = "406"
      action   = "deny(403)"
      preview = true
      expression = "evaluatePreconfiguredWaf('scannerdetection-v33-stable', {'sensitivity': 2})"
      description = "Scanner Detection - OWASP Rule"
    },
    {
      priority = "407"
      action   = "deny(403)"
      preview = true
      expression = "evaluatePreconfiguredWaf('protocolattack-v33-stable', {'sensitivity': 3})"
      description = "Protocol Attack - OWASP Rule"
    },
    {
      priority = "408"
      action   = "deny(403)"
      preview = true
      expression = "evaluatePreconfiguredWaf('sessionfixation-v33-stable', {'sensitivity': 3})"
      description = "Session Fixation - OWASP Rule"
    },
    {
      priority = "409"
      action   = "deny(403)"
      preview = true
      expression = "evaluatePreconfiguredWaf('nodejs-v33-stable', {'sensitivity': 2})"
      description = "Node.js - OWASP Rule"
    },
    {
      priority = "410"
      action   = "deny(403)"
      preview = true
      expression = "evaluatePreconfiguredWaf('java-v33-stable', {'sensitivity': 3})"
      description = "Java - OWASP Rule"
    },
    {
      priority = "411"
      action   = "deny(403)"
      preview = true
      expression = "evaluatePreconfiguredWaf('cve-canary', {'sensitivity': 3})"
      description = "Critical vulnerabilities rule"
    },
  ]
}

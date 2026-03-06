include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

include "common" {
    path = find_in_parent_folders("common.hcl")
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/freight-network-host/modules/shared-vpc"
}

inputs = {
    project_id  = include.gcp.locals.project_id
    network_name = "nonprod"
    base_labels = merge(include.common.locals.base_labels, {"env": include.gcp.locals.env})
    interconnects_project_id = "freight-interconnects"
    private_service_connect_google_ip = "10.219.0.0"

    global_advertised_ranges = [
        {
            range = "10.219.0.0/16"
            description = "IPs used for Global Load Balancers and Google APIs over Private Service Connect"
        },
        {
            range = "172.27.24.0/22"
            description = "Cloud SQL Private Service Access (PSA) IP range - advertised to on-prem via BGP"
        },
        {
            range = "10.221.4.0/22"
            description = "GCP PSA for Cloud SQL Non Prod - advertised to on-prem via BGP"
        },
        {
            range = "199.36.153.4/30"
            description = "Restricted Google APIs IPs. Route traffic to the restricted.googleapis.com VIP https://cloud.google.com/vpc-service-controls/docs/set-up-private-connectivity"
        },
        {
            range = "34.126.0.0/18"
            description = "Restricted Google APIs IPs. Route traffic to APIs that allow direct connectivity https://cloud.google.com/vpc-service-controls/docs/set-up-private-connectivity#direct-connectivity"
        },
        {
            range = "35.199.192.0/19"
            description = "Cloud DNS uses the 35.199.192.0/19 source range for all customers. This range is only accessible from a Google Cloud VPC network or from an on-premises network connected to a VPC network."
        },
        {
            range = "35.191.0.0/16"
            description = "Range used by Google's health check probes https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges"
        },
        {
            range = "130.211.0.0/22"
            description = "Range used by Google's health check probes https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges"
        },
        {
            range = "35.235.240.0/20"
            description = "Range used by Google's health check probes https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges"
        },
        {
            range = "209.85.152.0/22"
            description = "Range used by Google's health check probes https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges"
        },
        {
            range = "209.85.204.0/22"
            description = "Range used by Google's health check probes https://cloud.google.com/load-balancing/docs/health-check-concepts#ip-ranges"
        },
    ]
    secondary_ranges = {
        "us-south1-gke-nonprod" = [
            {
                range_name    = "services"
                ip_cidr_range = "10.217.64.0/18"
            },
            {
                range_name    = "pods"
                ip_cidr_range = "10.217.128.0/17"
            }
        ]
        "us-south1-gke-nonprod-ptms-south1" = [
            {
                range_name    = "services"
                ip_cidr_range = "10.223.20.0/22"
            },
            {
                range_name    = "pods"
                ip_cidr_range = "10.223.24.0/21"
            }
        ]
        "us-east4-gke-nonprod-ptms-east4" = [
            {
                range_name    = "services"
                ip_cidr_range = "10.220.20.0/22"
            },
            {
                range_name    = "pods"
                ip_cidr_range = "10.220.24.0/21"
            }
        ]
    }
    # Priority convention
    # 0 - 9,999       Global & InterProject & InterRegional (Cross Projects, Cross Regions) - Source Ip/Subnet based
    # 10,000          Project lockdown rules
    # 10,001 - 29,999 IntraProject & InterRegional (Single Project, Cross Regions) - Source Tag Based
    # 30,000          Regional Lockdown Rules
    # 30,001 - 65,529 IntraProject & IntraRegional (Single Project, Single Region) - Source Tag Based
    # 65,530          Reserved for default rules
    # For details see https://uberfreight.atlassian.net/wiki/x/LYCoB
    #
    # Available protocols ["ah", "all", "esp", "icmp", "ipip", "sctp", "tcp", "udp"]
    ingress_rules = [
        {
            name                    = "allow-vm-ssh-internal"
            description             = "Allow ingress for SSH access from internal IPs"
            source_ranges           = [ "10.0.0.0/8" ]
            allow = [{
                protocol = "tcp"
                ports    = ["22"]
            }]
        },
        {
            priority                = 65530
            name                    = "deny-all-ingress-and-log"
            description             = "Explicit deny all rule since Gooogle's defgault rule does not support logging"
            source_ranges           = [ "0.0.0.0/0" ]
            deny                    = [ {protocol = "all" }]
        },
        {
            name                    = "allow-gke-endpoint-access"
            description             = "Allow access to GKE master endpoint"
            source_ranges           = ["10.1.0.0/16", "10.2.0.0/16", "10.230.0.0/16", "10.231.0.0/16"]
            destination_ranges      = ["10.217.0.16/28","10.223.17.0/28","10.220.17.0/28"]
            allow = [{
                protocol = "tcp"
                ports    = ["443", "10250"]
            }]
        },
        {
            name                    = "allow-gke-nonprod-all-ingress"
            description             = "Allow all internal GKE communication (master, nodes, pods, services)"
            source_ranges           = [
                "10.217.0.16/28",     # GKE NonProd Cluster Master CIDR
                "10.217.16.0/20",     # GKE NonProd Cluster Node CIDR
                "10.217.64.0/18",     # GKE NonProd Cluster Service CIDR
                "10.217.128.0/17",    # GKE NonProd Cluster Pod CIDR
                "10.223.10.0/23",     # Internal LB
                "10.1.0.0/16",
                "10.2.0.0/16",
                "10.223.254.0/24"     # Regional Managed Proxy
            ]
            destination_ranges      = [
                "10.217.0.16/28",     # GKE NonProd Cluster Master CIDR
                "10.217.16.0/20",     # GKE NonProd Cluster Node CIDR
                "10.217.64.0/18",     # GKE NonProd Cluster Service CIDR
                "10.217.128.0/17",    # GKE NonProd Cluster Pod CIDR
                "10.223.10.0/23",     # Internal LB
                "10.223.254.0/24"     # Regional Managed Proxy
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["0-65535"]
            }]
        },
# GKE NonProd PTMS South1
        {
            name                    = "allow-gke-nonprod-ptms-south1-all-ingress"
            description             = "Allow all internal GKE communication (master, nodes, pods, services)"
            source_ranges           = [
                "10.223.17.0/28",     # GKE NonProd PTMS South1 Cluster Master CIDR
                "10.223.18.0/24",     # GKE NonProd PTMS South1 Cluster Node CIDR
                "10.223.20.0/22",     # GKE NonProd PTMS South1 Cluster Service CIDR
                "10.223.24.0/21",     # GKE NonProd PTMS South1 Cluster Pod CIDR

                "10.223.10.0/23",     # Internal LB
                "10.1.0.0/16",
                "10.2.0.0/16",
                "10.223.254.0/24"     # Regional Managed Proxy
            ]
            destination_ranges      = [
                "10.223.17.0/28",     # GKE NonProd PTMS South1 Cluster Master CIDR
                "10.223.18.0/24",     # GKE NonProd PTMS South1 Cluster Node CIDR
                "10.223.20.0/22",     # GKE NonProd PTMS South1 Cluster Service CIDR
                "10.223.24.0/21",     # GKE NonProd PTMS South1 Cluster Pod CIDR    
                "10.223.10.0/23",     # Internal LB
                "10.223.254.0/24"     # Regional Managed Proxy
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["0-65535"]
            }]
        },
# GKE NonProd PTMS East4
        {
            name                    = "allow-gke-nonprod-ptms-east4-all-ingress"
            description             = "Allow all internal GKE communication (master, nodes, pods, services)"
            source_ranges           = [
                "10.220.17.0/28",     # GKE NonProd PTMS East4 Cluster Master CIDR
                "10.220.18.0/24",     # GKE NonProd PTMS East4 Cluster Node CIDR
                "10.220.20.0/22",     # GKE NonProd PTMS East4 Cluster Service CIDR
                "10.220.24.0/21",     # GKE NonProd PTMS East4 Cluster Pod CIDR

                "10.220.32.0/23",     # Internal LB --> Doubt 
                "10.1.0.0/16",
                "10.2.0.0/16",
                "10.220.254.0/24"     # Regional Managed Proxy
            ]
            destination_ranges      = [
                "10.220.17.0/28",     # GKE NonProd PTMS East4 Cluster Master CIDR
                "10.220.18.0/24",     # GKE NonProd PTMS East4 Cluster Node CIDR
                "10.220.20.0/22",     # GKE NonProd PTMS East4 Cluster Service CIDR
                "10.220.24.0/21",     # GKE NonProd PTMS East4 Cluster Pod CIDR 
                "10.220.32.0/23",     # Internal LB
                "10.220.254.0/24"     # Regional Managed Proxy
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["0-65535"]
            }]
        },
        {
            name                    = "allow-iap-and-health-checks"
            description             = "Allow all access from IAP and health check ranges"
            source_ranges           = [
                "130.211.0.0/22",
                "35.191.0.0/16",
                "35.235.240.0/20"
            ]
            allow = [{
                protocol = "tcp"
            }]
        },
        {
            name                    = "allow-tmobile-ptms-compute-tcp-ingress"
            description             = "Allow inbound communication for management of tmobile ptms compute uat resources"
            source_ranges           = [
                "10.1.0.0/16",        # On-prem Dallas data center subnets
                "10.2.0.0/16",        # On-prem Austin data center subnets
                "10.3.0.0/16",        # On-prem Frisco office subnets
                "10.231.0.0/17"       # VPN worldwide user subnets                
            ]
            destination_ranges      = [
                "10.220.16.0/24",     # Compute resources for tmobile ptms uat east4
                "10.223.16.0/24"      # Compute resources for tmobile ptms uat south1
            ]
            allow = [{
                protocol = "tcp"
                ports    = [
                    "3389",           # RDP
                    "22",             # SSH
                    "5985",           # WinRM HTTP
                    "5986"            # WinRM HTTPS
                ]
            }]
        },
        {
            name                    = "allow-tmobile-ptms-compute-udp-ingress"
            description             = "Allow inbound communication for management of tmobile ptms compute uat resources"
            source_ranges           = [
                "10.1.0.0/16",        # On-prem Dallas data center subnets
                "10.2.0.0/16",        # On-prem Austin data center subnets
                "10.3.0.0/16",        # On-prem Frisco office subnets
                "10.231.0.0/17"       # VPN worldwide user subnets                
            ]
            destination_ranges      = [
                "10.220.16.0/24",     # Compute resources for tmobile ptms uat east4
                "10.223.16.0/24"      # Compute resources for tmobile ptms uat south1
            ]
            allow = [{
                protocol = "udp"
                ports    = [
                    "3389",           # RDP
                ]
            }]
        },
        {
            name                    = "allow-global-proxy-to-nonprod-resources"
            description             = "Allow global managed proxy subnets to reach resources for cross-regional load balancing"
            source_ranges           = [
                "10.220.19.64/26",    # us-east4 global proxy
                "10.223.19.64/26"     # us-south1 global proxy
            ]
            destination_ranges      = [
                "10.220.16.0/20",     # us-east4 resources
                "10.223.16.0/20"      # us-south1 resources
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["0-65535"]
            }]
        },
        # Cloud SQL Developer Access from Corporate Network
        {
            name                    = "allow-cloudsql-from-corporate"
            description             = "Allow Cloud SQL access from corporate network (on-prem and VPN)"
            source_ranges           = [
                "10.1.0.0/16",        # On-prem Dallas data center subnets
                "10.2.0.0/16",        # On-prem Austin data center subnets
                "10.3.0.0/16",        # On-prem Frisco office subnets
                "10.231.0.0/17"       # VPN worldwide user subnets
            ]
            destination_ranges      = [
                "172.27.24.0/22",     # Cloud SQL PSA range (existing)
                "10.221.4.0/22",      # GCP PSA for Cloud SQL Non Prod (new)
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["1433"]   # SQL Server port
            }]
        }
    ]

    egress_rules = [
        {
            name                    = "allow-dmz-access"
            description             = "Allow access to internal apps exposed through Dallas and Austin DMZ"
            destination_ranges      = [
                "10.67.100.0/24",
                "10.67.200.0/24",
            ]
            allow = [{
                protocol = "tcp"
                ports    = [
                    "443",
                    "80"
                ]
            }]
        },
        {
            name                    = "allow-fed"
            description             = "Allow access to internal ADFS instance for login"
            destination_ranges      = [
                "10.1.120.40", # fed.transplace.com
            ]
            allow = [{
                protocol = "tcp"
                ports    = [
                    "443"
                ]
            }]
        },
        {
            priority                = 65527
            name                    = "allow-google-api-psc"
            description             = "The destination is Google Private Service Connect (PSC) IP that we use for Google APIs"
            destination_ranges      = [ "10.224.0.0" ]
            allow                   = [ {protocol = "all" }]
        },
        {
            priority                = 65528
            name                    = "deny-internal-network-access"
            description             = "We deny access to the internal network before we allow internet access"
            destination_ranges      = [ "10.0.0.0/8" ]
            deny                    = [ {protocol = "all" }]
        },
        {
            priority                = 65529
            name                    = "allow-internet-access"
            description             = "We assume there is a rule with lower priority which blocks internal access so this rule does not filter destionation range."
            destination_ranges      = [ "0.0.0.0/0" ]
            allow = [
                {
                    protocol = "icmp"
                },
                {
                    protocol = "tcp"
                    ports    = [
                        "22",
                        "80",
                        "443",
                        "9092"
                    ]
                },
            ]
        },
        {
            priority                = 65530
            name                    = "deny-all-egress-and-log"
            description             = "Explicit deny all rule since Gooogle's defgault rule does not support logging"
            destination_ranges      = [ "0.0.0.0/0" ]
            deny                    = [ {protocol = "all" }]
        },
        {
            priority                = 998
            name                    = "allow-gke-nonprod-openshift-all-egress"
            description             = "Allow Connectivity from GKE-NonProd to Openshift"
            source_ranges           = [
                "10.217.0.16/28",     # GKE NonProd Cluster Master CIDR
                "10.217.16.0/20",     # GKE NonProd Cluster Node CIDR
                "10.217.64.0/18",     # GKE NonProd Cluster Service CIDR
                "10.217.128.0/17",    # GKE NonProd Cluster Pod CIDR
            ]
            destination_ranges      = [
                 "10.1.0.0/16",       # on-premise data center Servers
                 "10.2.0.0/16",       # on-premise data center Servers
                 "172.19.32.11",      # KMS UAT Server
                 "172.19.32.12",      # KMS UAT Server
                 "10.67.100.212",     # tmsuat-int.transplace.com
                 "10.249.0.0/16",
                 "199.36.153.4/30",
                 "34.126.0.0/18",
                 "199.36.153.96/32",
                 "10.219.0.0/16"
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["0-65535"]
            }]
        },
        {
            priority                = 998
            name                    = "allow-gke-nonprod-all-egress"
            description             = "Allow all internal GKE communication (master, nodes, pods, services)"
            source_ranges           = [
                "10.217.0.16/28",     # GKE NonProd Cluster Master CIDR
                "10.217.16.0/20",     # GKE NonProd Cluster Node CIDR
                "10.217.64.0/18",     # GKE NonProd Cluster Service CIDR
                "10.217.128.0/17",    # GKE NonProd Cluster Pod CIDR
                "10.223.10.0/23",     # Internal LB
                "10.223.254.0/24"     # Regional Managed Proxy
            ]
            destination_ranges      = [
                "10.217.0.16/28",     # GKE NonProd Cluster Master CIDR
                "10.217.16.0/20",     # GKE NonProd Cluster Node CIDR
                "10.217.64.0/18",     # GKE NonProd Cluster Service CIDR
                "10.217.128.0/17",    # GKE NonProd Cluster Pod CIDR
                "10.223.10.0/23",     # Internal LB
                "10.223.254.0/24"     # Regional Managed Proxy
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["0-65535"]
            }]
        },
# Egress PTMS South1
        {
            priority                = 999
            name                    = "allow-gke-nonprod-ptms-south1-all-egress"
            description             = "Allow all internal GKE communication (master, nodes, pods, services)"
            source_ranges           = [
                "10.223.17.0/28",     # GKE NonProd PTMS South1 Cluster Master CIDR
                "10.223.18.0/24",     # GKE NonProd PTMS South1 Cluster Node CIDR
                "10.223.20.0/22",     # GKE NonProd PTMS South1 Cluster Service CIDR
                "10.223.24.0/21",     # GKE NonProd PTMS South1 Cluster Pod CIDR    
                "10.223.10.0/23",     # Internal LB
                "10.223.254.0/24"     # Regional Managed Proxy
            ]
            destination_ranges      = [
                "10.223.17.0/28",     # GKE NonProd PTMS South1 Cluster Master CIDR
                "10.223.18.0/24",     # GKE NonProd PTMS South1 Cluster Node CIDR
                "10.223.20.0/22",     # GKE NonProd PTMS South1 Cluster Service CIDR
                "10.223.24.0/21",     # GKE NonProd PTMS South1 Cluster Pod CIDR    
                "10.223.10.0/23",     # Internal LB
                "10.223.254.0/24",    # Regional Managed Proxy
                "10.1.0.0/16",        # on-premise data center Servers
                "10.2.0.0/16",        # on-premise data center Servers
                "172.19.32.11",       # KMS UAT Server
                "172.19.32.12",       # KMS UAT Server
                "10.67.100.212",      # tmsuat-int.transplace.com
                "10.249.0.0/16",
                "199.36.153.4/30",
                "34.126.0.0/18",
                "199.36.153.96/32",
                "10.219.0.0/16",
                "10.220.19.64/26",    # us-east4 global proxy
                "10.223.19.64/26",     # us-south1 global proxy
                "10.255.252.0/22"   # Designated subnet for Uber VIPs
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["0-65535"]
            }]
        },
# Egress PTMS East4
        {
            priority                = 999
            name                    = "allow-gke-nonprod-ptms-east4-all-egress"
            description             = "Allow all internal GKE communication (master, nodes, pods, services)"
            source_ranges           = [
                "10.220.17.0/28",     # GKE NonProd PTMS East4 Cluster Master CIDR
                "10.220.18.0/24",     # GKE NonProd PTMS East4 Cluster Node CIDR
                "10.220.20.0/22",     # GKE NonProd PTMS East4 Cluster Service CIDR
                "10.220.24.0/21",     # GKE NonProd PTMS East4 Cluster Pod CIDR 
                "10.220.32.0/23",     # Internal LB
                "10.220.254.0/24"     # Regional Managed Proxy
            ]
            destination_ranges      = [
                "10.220.17.0/28",     # GKE NonProd PTMS East4 Cluster Master CIDR
                "10.220.18.0/24",     # GKE NonProd PTMS East4 Cluster Node CIDR
                "10.220.20.0/22",     # GKE NonProd PTMS East4 Cluster Service CIDR
                "10.220.24.0/21",     # GKE NonProd PTMS East4 Cluster Pod CIDR 
                "10.220.32.0/23",     # Internal LB
                "10.220.254.0/24",    # Regional Managed Proxy
                "10.1.0.0/16",        # on-premise data center Servers
                "10.2.0.0/16",        # on-premise data center Servers
                "172.19.32.11",       # KMS UAT Server
                "172.19.32.12",       # KMS UAT Server
                "10.67.100.212",      # tmsuat-int.transplace.com
                "10.249.0.0/16",
                "199.36.153.4/30",
                "34.126.0.0/18",
                "199.36.153.96/32",
                "10.219.0.0/16",
                "10.220.19.64/26",   # us-east4 global proxy
                "10.223.19.64/26",     # us-south1 global proxy
                "10.255.252.0/22"   # Designated subnet for Uber VIPs
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["0-65535"]
            }]
        },
        {
            priority                = 999
            name                    = "allow-composer-nonprod-email-egress"
            description             = "Allow composer email outbound to mailblast server on-prem"
            source_ranges           = [
                "10.223.2.0/23", # composer-network subnet
            ]
            destination_ranges      = [
                "10.67.200.184"       # mailblast server transplace to send email from GKE github runner pods
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["25"]
            }]
        },
        {
            priority                = 1000
            name                    = "allow-tmobile-ptms-compute-tcp-domainjoin-egress"
            description             = "Allow internal t-mobile ptms compute uat tcp communication outbound for domain join to on-prem"
            source_ranges           = [
                "10.220.16.0/24",     # Compute resources for tmobile ptms uat east4
                "10.223.16.0/24"      # Compute resources for tmobile ptms uat south1
            ]
            destination_ranges      = [
                "10.1.0.0/16",        # On-prem Dallas data center subnets
                "10.2.0.0/16",        # On-prem Austin data center subnets
                "172.16.0.0/12",      # On-prem additional private subnets
                "10.67.3.0/24",       # On-prem DMZ Production Servers Austin
                "10.67.50.0/24",      # On-prem DMZ Production Servers Dallas
                "10.67.100.0/24",     # On-prem F5 VIPs Dallas
                "10.67.200.0/24"      # On-prem F5 VIPs Austin
            ]
            allow = [{
                protocol = "tcp"
                ports    = [ 
                    "53",
                    "80",
                    "88",
                    "135",
                    "123",
                    "389",
                    "443",
                    "445",
                    "464",
                    "636",
                    "3268",
                    "3269",
                    "9389",
                    "49152-65535"
                ]
            }]
        },
        {
            priority                = 1000
            name                    = "allow-tmobile-ptms-compute-udp-domainjoin-egress"
            description             = "Allow internal t-mobile ptms compute uat udp communication outbound for domain join to on-prem"
            source_ranges           = [
                "10.220.16.0/24",     # Compute resources for tmobile ptms uat east4
                "10.223.16.0/24"      # Compute resources for tmobile ptms uat south1
            ]
            destination_ranges      = [
                "10.1.0.0/16",        # On-prem Dallas data center subnets
                "10.2.0.0/16",        # On-prem Austin data center subnets
                "172.16.0.0/12",      # On-prem additional private subnets
                "10.67.3.0/24",       # On-prem DMZ Production Servers Austin
                "10.67.50.0/24",      # On-prem DMZ Production Servers Dallas
                "10.67.100.0/24",     # On-prem F5 VIPs Dallas
                "10.67.200.0/24"      # On-prem F5 VIPs Austin
            ]
            allow = [{
                protocol = "udp"
                ports    = [ 
                    "53",
                    "88",
                    "389",
                    "464"
                ]
            }]
        }
    ]
    regions = {
        "us-east4" = {
            asn = 65161
            psc_subnet_ip = "10.220.0.0/24"
            subnets = [
                {
                    name = "regional-managed-proxy"
                    ip = "10.220.254.0/24"
                    description = "The proxy-only subnet provides a set of IP addresses that Google uses to run Envoy proxies on your behalf. You must create one proxy-only subnet in each region of a VPC network where you use load balancers. https://cloud.google.com/load-balancing/docs/tcp#proxy-only_subnet"
                    purpose = "REGIONAL_MANAGED_PROXY"
                    role = "ACTIVE"
                },
                {
                    name = "private-dns"
                    ip = "10.220.255.248/29"
                    description = "This subnet is used to ensure that the DNS inbound policy IP does not change when subnets get deleted. We have one per region."
                    purpose = "PRIVATE"
                },
                {
                    name = "internal-lb"
                    ip = "10.220.32.0/23"
                    description = "Subnet for Internal Load Balancers Frontend IP"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "gke-nonprod-ptms-east4"
                    ip = "10.220.18.0/24"
                    description = "Subnet for GKE Nodes in VPC Native Setup"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "tmobile-ptms-compute-nonprod"
                    ip = "10.220.16.0/24"
                    description = "Subnet for Compute Resources, reserved for T-Mobile PTMS"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "tmobile-ptms-db-uat"
                    ip = "10.220.19.0/27"
                    description = "Subnet for DB Resources, reserved for T-Mobile PTMS"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "global-managed-proxy"
                    ip = "10.220.19.64/26"
                    description = "Global managed proxy subnet for cross-regional load balancers"
                    purpose = "GLOBAL_MANAGED_PROXY"
                    role = "ACTIVE"
                },
            ],
            routers = {
                "r1" = {
                    attachments = {
                        "aus" = {
                            interconnect_id = "aus-zone1-1483-10g-lumen-445481965"
                            candidate_subnets = ["169.254.150.176/29"]
                            vlan = 3017
                            peer = {
                                name     = "aus-r1c6-34-agg1"
                                peer_asn = 65105
                            }
                        }
                    }
                }
                "r2" = {
                    attachments = {
                        "aus" = {
                            interconnect_id = "aus-zone2-1483-10g-zayo-ogyx386722zyo"
                            candidate_subnets = ["169.254.150.184/29"]
                            vlan = 3018
                            peer = {
                                name     = "aus-r1c7-34-agg2"
                                peer_asn = 65105
                            }
                        }
                    }
                }
            }
        },
        "us-west8" = {
            asn = 65162
            psc_subnet_ip = "10.222.0.0/24"
            subnets = [
                {
                    name = "regional-managed-proxy"
                    ip = "10.222.254.0/24"
                    description = "The proxy-only subnet provides a set of IP addresses that Google uses to run Envoy proxies on your behalf. You must create one proxy-only subnet in each region of a VPC network where you use load balancers. https://cloud.google.com/load-balancing/docs/tcp#proxy-only_subnet"
                    purpose = "REGIONAL_MANAGED_PROXY"
                    role = "ACTIVE"
                },
                {
                    name = "private-dns"
                    ip = "10.222.255.248/29"
                    description = "This subnet is used to ensure that the DNS inbound policy IP does not change when subnets get deleted. We have one per region."
                    purpose = "PRIVATE"
                },
            ],
            routers = {
                "r1" = {
                    attachments = {
                        "aus" = {
                            interconnect_id = "aus-zone1-1483-10g-lumen-445481965"
                            candidate_subnets = ["169.254.150.144/29"]
                            vlan = 3015
                            peer = {
                                name     = "aus-r1c6-34-agg1"
                                peer_asn = 65105
                            }
                        }
                    }
                }
                "r2" = {
                    attachments = {
                        "aus" = {
                            interconnect_id = "aus-zone2-1483-10g-zayo-ogyx386722zyo"
                            candidate_subnets = ["169.254.150.152/29"]
                            vlan = 3016
                            peer = {
                                name     = "aus-r1c7-34-agg2"
                                peer_asn = 65105
                            }
                        }
                    }
                }
            }
        }
        "us-south1" = {
            asn = 65163
            psc_subnet_ip = "10.223.0.0/24"
            subnets = [
                {
                    name = "composer-network-n"
                    ip = "10.223.2.0/23"
                    description = "Cloud composer instances for nonprod will run on this subnet"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "regional-managed-proxy"
                    ip = "10.223.254.0/24"
                    description = "The proxy-only subnet provides a set of IP addresses that Google uses to run Envoy proxies on your behalf. You must create one proxy-only subnet in each region of a VPC network where you use load balancers. https://cloud.google.com/load-balancing/docs/tcp#proxy-only_subnet"
                    purpose = "REGIONAL_MANAGED_PROXY"
                    role = "ACTIVE"
                },
                {
                    name = "dataflow-logging"
                    ip = "10.223.4.0/26"
                    description = "Subnet for Dataflow instance for Datadog logging"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "private-dns"
                    ip = "10.223.255.248/29"
                    description = "This subnet is used to ensure that the DNS inbound policy IP does not change when subnets get deleted. We have one per region."
                    purpose = "PRIVATE"
                },
                {
                    name = "internal-lb"
                    ip = "10.223.10.0/23"
                    description = "Subnet for Internal Load Balancers Frontend IP"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "gke-nonprod"
                    ip = "10.217.16.0/20"
                    description = "Subnet for GKE Nodes in VPC Native Setup"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "gke-nonprod-ptms-south1"
                    ip = "10.223.18.0/24"
                    description = "Subnet for GKE Nodes in VPC Native Setup"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "tmobile-ptms-compute-nonprod"
                    ip = "10.223.16.0/24"
                    description = "Subnet for Compute Resources, reserved for T-Mobile PTMS"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "tmobile-ptms-db-uat"
                    ip = "10.223.19.0/27"
                    description = "Subnet for DB Resources, reserved for T-Mobile PTMS"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "global-managed-proxy"
                    ip = "10.223.19.64/26"
                    description = "Global managed proxy subnet for cross-regional load balancers"
                    purpose = "GLOBAL_MANAGED_PROXY"
                    role = "ACTIVE"
                },
            ],
            routers = {
                "r1" = {
                    attachments = {
                        "aus" = {
                            interconnect_id = "aus-zone1-1483-10g-lumen-445481965"
                            candidate_subnets = ["169.254.150.112/29"]
                            vlan = 3013
                            peer = {
                                name     = "aus-r1c6-34-agg1"
                                peer_asn = 65105
                            }
                        }
                    }
                }
                "r2" = {
                    attachments = {
                        "aus" = {
                            interconnect_id = "aus-zone2-1483-10g-zayo-ogyx386722zyo"
                            candidate_subnets = ["169.254.150.120/29"]
                            vlan = 3014
                            peer = {
                                name     = "aus-r1c7-34-agg2"
                                peer_asn = 65105
                            }
                        }
                    }
                }
            }
        }
    }

}

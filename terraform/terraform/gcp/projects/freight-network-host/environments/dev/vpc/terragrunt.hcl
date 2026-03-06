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
    network_name = "dev"
    base_labels = merge(include.common.locals.base_labels, {"env": include.gcp.locals.env})
    interconnects_project_id = "freight-interconnects"
    private_service_connect_google_ip = "10.224.0.0"

    global_advertised_ranges = [
        {
            range = "10.224.0.0/16"
            description = "IPs used for Global Load Balancers and Google APIs over Private Service Connect"
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
        "us-south1-gke-dev" = [
            {
                range_name    = "services"
                ip_cidr_range = "10.227.32.0/19"
            },
            {
                range_name    = "pods"
                ip_cidr_range = "10.227.64.0/18"
            }
        ],
        "us-south1-composer-network-d" = [
            {
                range_name    = "pods"
                ip_cidr_range = "10.227.4.0/23"
            },
            {
                range_name    = "services"
                ip_cidr_range = "10.227.6.0/23"
            }
        ]
        "us-east4-gke-dev-ptms" = [
            {
                range_name    = "services"
                ip_cidr_range = "10.225.4.0/22"
            },
            {
                range_name    = "pods"
                ip_cidr_range = "10.225.8.0/21"
            }
        ],        
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
            source_ranges           = ["10.1.0.0/16", "10.2.0.0/16", "10.230.0.0/16", "10.231.0.0/16", "10.247.1.0/24"]
            destination_ranges      = ["10.227.11.0/24", "10.227.8.0/28", "10.225.1.0/28"]
            allow = [{
                protocol = "tcp"
                ports    = ["443", "10250"]
            }]
        },
        {
            name                    = "allow-gke-dev-all-ingress"
            description             = "Allow all internal GKE communication (master, nodes, pods, services)"
            source_ranges           = [
                "10.227.11.0/28",     # GKE DEV Cluster Master CIDR
                "10.227.16.0/21",     # GKE DEV Cluster Node CIDR
                "10.227.32.0/19",     # GKE DEV Cluster Service CIDR
                "10.227.64.0/18",     # GKE DEV Cluster Pod CIDR
                "10.227.10.0/24",     # Internal LB
                "10.247.1.0/24",
                "10.227.254.0/24"     # Regional Managed Proxy
            ]
            destination_ranges      = [
                "10.227.11.0/28",     # GKE DEV Cluster Master CIDR
                "10.227.16.0/21",     # GKE DEV Cluster Node CIDR
                "10.227.32.0/19",     # GKE DEV Cluster Service CIDR
                "10.227.64.0/18",      # GKE DEV Cluster Pod CIDR
                "10.227.10.0/24",     # Internal LB
                "10.227.254.0/24"     # Regional Managed Proxy
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["0-65535"]
            }]
        },
        {
            name                    = "allow-gke-dev-ptms-all-ingress"
            description             = "Allow all internal GKE communication (master, nodes, pods, services)"
            source_ranges           = [
                "10.225.1.0/28",     # GKE DEV PTMS Cluster Master CIDR
                "10.225.2.0/24",     # GKE DEV PTMS Cluster Node CIDR
                "10.225.4.0/22",     # GKE DEV PTMS Cluster Service CIDR
                "10.225.8.0/21",     # GKE DEV PTMSCluster Pod CIDR
                "10.225.16.0/24",    # Internal LB
                "10.225.254.0/24"    # Regional Managed Proxy
            ]
            destination_ranges      = [
                "10.225.1.0/28",     # GKE DEV PTMS Cluster Master CIDR
                "10.225.2.0/24",     # GKE DEV PTMS Cluster Node CIDR
                "10.225.4.0/22",     # GKE DEV PTMS Cluster Service CIDR
                "10.225.8.0/21",     # GKE DEV PTMSCluster Pod CIDR
                "10.225.16.0/24",    # Internal LB
                "10.225.254.0/24"    # Regional Managed Proxy
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["0-65535"]
            }]
        },
        {
            name                    = "allow-gke-etl-dev-all-ingress"
            description             = "Allow all internal GKE ETL DEV communication (master, nodes, pods, services)"
            source_ranges           = [
                "10.227.8.0/28",      # GKE ETL DEV Cluster Master CIDR
                "10.227.0.0/23",      # GKE ETL DEV Cluster Node CIDR (composer-network subnet)
                "10.227.4.0/23",      # GKE ETL DEV Cluster Pod CIDR
                "10.227.6.0/23",      # GKE ETL DEV Cluster Service CIDR
                "10.247.1.0/24",      # Allow Github runners subnet in GKE cluster
            ]
            destination_ranges      = [
                "10.227.8.0/28",      # GKE ETL DEV Cluster Master CIDR
                "10.227.0.0/23",      # GKE ETL DEV Cluster Node CIDR (composer-network subnet)
                "10.227.4.0/23",      # GKE ETL DEV Cluster Pod CIDR
                "10.227.6.0/23"       # GKE ETL DEV Cluster Service CIDR
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
            description             = "Allow inbound communication for management of tmobile ptms compute dev and qa resources"
            source_ranges           = [
                "10.1.0.0/16",        # On-prem Dallas data center subnets
                "10.2.0.0/16",        # On-prem Austin data center subnets
                "10.3.0.0/16",        # On-prem Frisco office subnets
                "10.231.0.0/17"       # VPN worldwide user subnets                
            ]
            destination_ranges      = [
                "10.225.3.0/24",      # Compute resources for tmobile ptms dev us-east4
                "10.225.128.0/24",    # Compute resources for tmobile ptms qa us-east4
                "10.227.128.0/24",    # Compute resources for tmobile ptms qa us-south1
                "10.227.144.0/24"     # Compute resources for tmobile ptms dev us-south1
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
            description             = "Allow inbound communication for management of tmobile ptms compute dev and qa resources"
            source_ranges           = [
                "10.1.0.0/16",        # On-prem Dallas data center subnets
                "10.2.0.0/16",        # On-prem Austin data center subnets
                "10.3.0.0/16",        # On-prem Frisco office subnets
                "10.231.0.0/17"       # VPN worldwide user subnets                
            ]
            destination_ranges      = [
                "10.225.3.0/24",      # Compute resources for tmobile ptms dev us-east4
                "10.225.128.0/24",    # Compute resources for tmobile ptms qa us-east4
                "10.227.128.0/24",    # Compute resources for tmobile ptms qa us-south1
                "10.227.144.0/24"     # Compute resources for tmobile ptms dev us-south1
            ]
            allow = [{
                protocol = "udp"
                ports    = [
                    "3389",           # RDP
                ]
            }]
        },
        {
            name                    = "allow-tmobile-ptms-gke-to-db-ingress"
            description             = "Allow GKE clusters (pods, services, nodes) to connect to Cloud SQL databases"
            source_ranges           = [
                # us-east4 GKE PTMS dev cluster
                "10.225.2.0/24",      # GKE PTMS dev nodes us-east4
                "10.225.4.0/22",      # GKE PTMS dev services us-east4
                "10.225.8.0/21",      # GKE PTMS dev pods us-east4
                # us-south1 GKE dev cluster (same region as DB)
                "10.227.16.0/21",     # GKE dev nodes us-south1
                "10.227.32.0/19",     # GKE dev services us-south1
                "10.227.64.0/18",     # GKE dev pods us-south1
            ]
            destination_ranges      = [
                "10.227.131.0/27",    # DB resources for tmobile ptms dev (Cloud SQL PSC endpoint)
            ]
            allow = [{
                protocol = "tcp"
                ports    = [
                    "1433",           # SQL Server
                ]
            }]
        },
        {
            name                    = "allow-global-proxy-to-gke-pods"
            description             = "Allow global managed proxy subnets to reach GKE pods for cross-regional load balancing"
            source_ranges           = [
                "10.225.131.64/26",   # us-east4 global proxy
                "10.227.131.64/26"    # us-south1 global proxy
            ]
            destination_ranges      = [
                "10.225.8.0/21",      # us-east4 GKE pods
                "10.227.64.0/18"      # us-south1 GKE pods
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["0-65535"]
            }]
        },
        {
            name                    = "allow-global-proxy-to-fsms-backends"
            description             = "Allow regional managed proxy subnet to reach FSMS backend servers on TCP port 2000"
            source_ranges           = [
                "10.227.254.0/24"     # us-south1 regional managed proxy subnet
            ]
            destination_ranges      = [
                "10.227.144.0/24"     # FSMS backend servers (tmobile-ptms-compute-dev)
            ]
            allow = [{
                protocol = "tcp"
                ports    = [
                    "2000"            # FSMS socket port
                ]
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
            name                    = "allow-mx-db"
            description             = "The destination is MySql and SqlServer DBs used by Mexico team"
            source_ranges           = [
                "10.227.0.0/23",  #composer-network subnet
                ]
            destination_ranges      = [
                "172.19.21.7",  #mexicodb mysql db uat
                "10.1.110.48" #mexicodb sqlserver db PROD
            ]
            allow                   = [
                {
                 protocol = "tcp",
                 ports = [
                    "3306", #mysql port
                    "1433"  #sqlserver port
                     ]
                     }
                ]
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
            name                    = "allow-gke-dev-openshift-all-egress"
            description             = "Allow Connectivity from GKE-Dev to Openshift"
            source_ranges           = [
                "10.227.11.0/28",     # GKE DEV Cluster Master CIDR
                "10.227.16.0/21",     # GKE DEV Cluster Node CIDR
                "10.227.32.0/19",     # GKE DEV Cluster Service CIDR
                "10.227.64.0/18"      # GKE DEV Cluster Pod CIDR
            ]
            destination_ranges      = [
                 "10.1.0.0/16",
                 "10.2.0.0/16",      # on-premise DEV Servers
                 "172.19.32.6",      # KMS Dev
                 "10.67.100.212",
                 "10.249.0.0/16",
                 "10.255.252.0/22"   # Designated subnet for Uber VIPs
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["0-65535"]
            }]
        },        
        {
            priority                = 998
            name                    = "allow-gke-dev-all-egress"
            description             = "Allow all internal GKE communication (master, nodes, pods, services)"
            source_ranges           = [
                "10.227.11.0/28",     # GKE DEV Cluster Master CIDR
                "10.227.16.0/21",     # GKE DEV Cluster Node CIDR
                "10.227.32.0/19",     # GKE DEV Cluster Service CIDR
                "10.227.64.0/18",     # GKE DEV Cluster Pod CIDR
                "10.227.10.0/24",     # Internal LB
                "10.227.254.0/24"     # Regional Managed Proxy
            ]
            destination_ranges      = [
                "10.227.11.0/28",     # GKE DEV Cluster Master CIDR
                "10.227.16.0/21",     # GKE DEV Cluster Node CIDR
                "10.227.32.0/19",     # GKE DEV Cluster Service CIDR
                "10.227.64.0/18",     # GKE DEV Cluster Pod CIDR
                "10.227.10.0/24",     # Internal LB
                "10.227.254.0/24"     # Regional Managed Proxy
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["0-65535"]
            }]
        },
        {
            priority                = 998
            name                    = "allow-gke-dev-ptms-all-egress"
            description             = "Allow all internal GKE communication (master, nodes, pods, services)"
            source_ranges           = [
                "10.225.1.0/28",     # GKE DEV PTMS Cluster Master CIDR
                "10.225.2.0/24",     # GKE DEV PTMS Cluster Node CIDR
                "10.225.4.0/22",     # GKE DEV PTMS Cluster Service CIDR
                "10.225.8.0/21",     # GKE DEV PTMS Cluster Pod CIDR                
                "10.225.16.0/24",    # Internal LB
                "10.225.254.0/24"    # Regional Managed Proxy
            ]
            destination_ranges      = [
                "10.225.1.0/28",     # GKE DEV PTMS Cluster Master CIDR
                "10.225.2.0/24",     # GKE DEV PTMS Cluster Node CIDR
                "10.225.4.0/22",     # GKE DEV PTMS Cluster Service CIDR
                "10.225.8.0/21",     # GKE DEV PTMS Cluster Pod CIDR
                "10.225.16.0/24",    # Internal LB
                "10.225.254.0/24",   # Regional Managed Proxy
                "10.1.0.0/16",       # on-premise DEV Servers
                "10.2.0.0/16",       # on-premise DEV Servers
                "172.19.32.6",       # KMS Dev
                "10.67.100.212",
                "10.249.0.0/16"
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["0-65535"]
            }]
        },
        {
            priority                = 999
            name                    = "allow-gke-etl-dev-all-egress"
            description             = "Allow all internal GKE ETL DEV communication (master, nodes, pods, services)"
            source_ranges           = [
                "10.227.8.0/28",      # GKE ETL DEV Cluster Master CIDR
                "10.227.0.0/23",      # GKE ETL DEV Cluster Node CIDR (composer-network subnet)
                "10.227.4.0/23",      # GKE ETL DEV Cluster Pod CIDR
                "10.227.6.0/23"       # GKE ETL DEV Cluster Service CIDR
            ]
            destination_ranges      = [
                "10.227.8.0/28",      # GKE ETL DEV Cluster Master CIDR
                "10.227.0.0/23",      # GKE ETL DEV Cluster Node CIDR (composer-network subnet)
                "10.227.4.0/23",      # GKE ETL DEV Cluster Pod CIDR
                "10.227.6.0/23"       # GKE ETL DEV Cluster Service CIDR
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["0-65535"]
            }]
        },
        {
            priority                = 999
            name                    = "allow-gke-etl-dev-oracle-connection"
            description             = "GKE ETL DEV cluster and Composer need access to Oracle DB IPs"
            source_ranges           = [
                "10.227.8.0/28",      # GKE ETL DEV Cluster Master CIDR
                "10.227.0.0/23",      # GKE ETL DEV Cluster Node CIDR (composer-network subnet)
                "10.227.4.0/23",      # GKE ETL DEV Cluster Pod CIDR
                "10.227.6.0/23"       # GKE ETL DEV Cluster Service CIDR
            ]
            destination_ranges      = [
                "10.1.154.76", #dx8mp1-start (Oracle DB cluster)
                "10.1.154.77",
                "10.1.154.78",
                "10.1.154.79",
                "10.1.154.80",
                "10.1.154.81",
                "10.1.154.82",
                "10.1.154.83",
                "10.1.154.84",
                "10.1.154.85",
                "10.1.154.86", #dx8mp1-end
                "10.2.88.96", #ax8mr1-start (Oracle DB cluster)
                "10.2.88.97",
                "10.2.88.98",
                "10.2.88.99",
                "10.2.88.100",
                "10.2.88.101",
                "10.2.88.102",
                "10.2.88.103",
                "10.2.88.104",
                "10.2.88.105",
                "10.2.88.106", #ax8mr1-end
                "10.2.154.76", #lx8mu1-start (Oracle DB cluster)
                "10.2.154.77",
                "10.2.154.78",
                "10.2.154.79",
                "10.2.154.80",
                "10.2.154.81",
                "10.2.154.82",
                "10.2.154.83",
                "10.2.154.84",
                "10.2.154.85",
                "10.2.154.86"  #lx8mu1-end
            ]
            allow = [{
                protocol = "tcp"
                ports    = [
                    "1521"
                ]
            }]
        },
        {
            priority                = 1000
            name                    = "allow-gke-dev-mail-egress"
            description             = "Allow all internal GKE communication (nodes, pods) outbound to mailblast server on-prem"
            source_ranges           = [
                "10.227.16.0/21",     # GKE DEV Cluster Node CIDR
                "10.227.64.0/18",     # GKE DEV Cluster Pod CIDR
                "10.225.2.0/24",      # GKE DEV PTMS Cluster Node CIDR
                "10.225.8.0/21",      # GKE DEV PTMS Cluster Pod CIDR                
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
            name                    = "allow-composer-dev-email-egress"
            description             = "Allow composer email outbound to mailblast server on-prem"
            source_ranges           = [
                "10.227.0.0/23",
                "10.227.4.0/23", 
                "10.227.6.0/23"
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
            priority                = 1001
            name                    = "allow-tmobile-ptms-compute-tcp-domainjoin-egress"
            description             = "Allow internal t-mobile ptms compute dev and qa tcp communication outbound for domain join back to on-prem"
            source_ranges           = [
                "10.225.3.0/24",      # Compute resources for tmobile ptms dev us-east4
                "10.225.128.0/24",    # Compute resources for tmobile ptms qa us-east4
                "10.227.128.0/24",    # Compute resources for tmobile ptms qa us-south1
                "10.227.144.0/24"     # Compute resources for tmobile ptms dev us-south1
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
            priority                = 1001
            name                    = "allow-tmobile-ptms-compute-udp-domainjoin-egress"
            description             = "Allow internal t-mobile ptms compute dev and qa udp communication outbound for domain join back to on-prem"
            source_ranges           = [
                "10.225.3.0/24",      # Compute resources for tmobile ptms dev us-east4
                "10.225.128.0/24",    # Compute resources for tmobile ptms qa us-east4
                "10.227.128.0/24",    # Compute resources for tmobile ptms qa us-south1
                "10.227.144.0/24"     # Compute resources for tmobile ptms dev us-south1
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
        },
        {
            priority                = 1002
            name                    = "allow-tmobile-ptms-gke-to-db-egress"
            description             = "Allow GKE clusters (pods, services, nodes) to connect to Cloud SQL databases"
            source_ranges           = [
                # us-east4 GKE PTMS dev cluster
                "10.225.2.0/24",      # GKE PTMS dev nodes us-east4
                "10.225.4.0/22",      # GKE PTMS dev services us-east4
                "10.225.8.0/21",      # GKE PTMS dev pods us-east4
                # us-south1 GKE dev cluster (same region as DB)
                "10.227.16.0/21",     # GKE dev nodes us-south1
                "10.227.32.0/19",     # GKE dev services us-south1
                "10.227.64.0/18",     # GKE dev pods us-south1
            ]
            destination_ranges      = [
                "10.227.131.0/27",    # DB resources for tmobile ptms dev (Cloud SQL PSC endpoint)
            ]
            allow = [{
                protocol = "tcp"
                ports    = [
                    "1433",           # SQL Server
                ]
            }]
        }        
    ]
    regions = {
        "us-east4" = {
            asn = 65158
            psc_subnet_ip = "10.225.0.0/24"
            subnets = [
                {
                    name = "regional-managed-proxy"
                    ip = "10.225.254.0/24"
                    description = "The proxy-only subnet provides a set of IP addresses that Google uses to run Envoy proxies on your behalf. You must create one proxy-only subnet in each region of a VPC network where you use load balancers. https://cloud.google.com/load-balancing/docs/tcp#proxy-only_subnet"
                    purpose = "REGIONAL_MANAGED_PROXY"
                    role = "ACTIVE"
                },
                {
                    name = "private-dns"
                    ip = "10.225.255.248/29"
                    description = "This subnet is used to ensure that the DNS inbound policy IP does not change when subnets get deleted. We have one per region."
                    purpose = "PRIVATE"
                },
                {
                    name = "gke-dev-ptms"
                    ip = "10.225.2.0/24"
                    description = "Subnet for GKE Dev PTMS Nodes in VPC Native Setup"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "internal-lb"
                    ip = "10.225.16.0/24"
                    description = "Subnet for Internal Load Balancers Frontend IP for GKE Dev PTMS"
                    purpose = "PRIVATE"
                    private_access = true
                },                
                {
                    name = "tmobile-ptms-compute-qa"
                    ip = "10.225.128.0/24"
                    description = "Compute resources for TMobile PTMS QA only"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "tmobile-ptms-compute-dev"
                    ip = "10.225.3.0/24"
                    description = "Compute resources for TMobile PTMS Dev only"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "tmobile-ptms-db-dev"
                    ip = "10.225.131.0/27"
                    description = "DB resources for TMobile PTMS Dev only"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "tmobile-ptms-db-qa"
                    ip = "10.225.131.32/27"
                    description = "DB resources for TMobile PTMS QA only"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "global-managed-proxy-subnet1"
                    ip = "10.225.131.64/26"
                    description = "The proxy-only subnet provides a set of IP addresses that Google uses to run Envoy proxies on your behalf. You must create one proxy-only subnet in each region of a VPC network where you use load balancers. https://cloud.google.com/load-balancing/docs/tcp#proxy-only_subnet"
                    purpose = "GLOBAL_MANAGED_PROXY"
                    role = "ACTIVE"
                },
            ],
            routers = {
                "r1" = {
                    attachments = {
                        "aus" = {
                            interconnect_id = "aus-zone1-1483-10g-lumen-445481965"
                            candidate_subnets = ["169.254.150.16/29"]
                            vlan = 3007
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
                            candidate_subnets = ["169.254.150.24/29"]
                            vlan = 3008
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
            asn = 65159
            subnets = [
                {
                    name = "regional-managed-proxy"
                    ip = "10.226.254.0/24"
                    description = "The proxy-only subnet provides a set of IP addresses that Google uses to run Envoy proxies on your behalf. You must create one proxy-only subnet in each region of a VPC network where you use load balancers. https://cloud.google.com/load-balancing/docs/tcp#proxy-only_subnet"
                    purpose = "REGIONAL_MANAGED_PROXY"
                    role = "ACTIVE"
                },
                {
                    name = "private-dns"
                    ip = "10.226.255.248/29"
                    description = "This subnet is used to ensure that the DNS inbound policy IP does not change when subnets get deleted. We have one per region."
                    purpose = "PRIVATE"
                },
            ],
            routers = {
                "r1" = {
                    attachments = {
                        "aus" = {
                            interconnect_id = "aus-zone1-1483-10g-lumen-445481965"
                            candidate_subnets = ["169.254.150.48/29"]
                            vlan = 3009
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
                            candidate_subnets = ["169.254.150.56/29"]
                            vlan = 3010
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
            asn = 65160
            psc_subnet_ip = "10.227.2.0/24"
            subnets = [
                {
                    name = "composer-network-d"
                    ip = "10.227.0.0/23"
                    description = "Cloud composer instances will run on this subnet"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "regional-managed-proxy"
                    ip = "10.227.254.0/24"
                    description = "The proxy-only subnet provides a set of IP addresses that Google uses to run Envoy proxies on your behalf. You must create one proxy-only subnet in each region of a VPC network where you use load balancers. https://cloud.google.com/load-balancing/docs/tcp#proxy-only_subnet"
                    purpose = "REGIONAL_MANAGED_PROXY"
                    role = "ACTIVE"
                },
                {
                    name = "private-dns"
                    ip = "10.227.255.248/29"
                    description = "This subnet is used to ensure that the DNS inbound policy IP does not change when subnets get deleted. We have one per region."
                    purpose = "PRIVATE"
                },
                {
                    name = "dataflow-logging"
                    ip = "10.227.3.0/26"
                    description = "Subnet for Dataflow instance for Datadog logging"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "internal-lb"
                    ip = "10.227.10.0/24"
                    description = "Subnet for Internal Load Balancers Frontend IP"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "gke-dev"
                    ip = "10.227.16.0/21"
                    description = "Subnet for GKE Nodes in VPC Native Setup"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "iaas-vms"
                    ip = "10.227.250.0/28"
                    description = "Subnet just to test code for IaaS VMs"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "tmobile-ptms-compute-qa"
                    ip = "10.227.128.0/24"
                    description = "Compute resources for TMobile PTMS QA only"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "tmobile-ptms-compute-dev"
                    ip = "10.227.144.0/24"
                    description = "Compute resources for TMobile PTMS Dev only"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "tmobile-ptms-db-dev"
                    ip = "10.227.131.0/27"
                    description = "DB resources for TMobile PTMS Dev only"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "tmobile-ptms-db-qa"
                    ip = "10.227.131.32/27"
                    description = "DB resources for TMobile PTMS Qa only"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "global-managed-proxy-subnet2"
                    ip = "10.227.131.64/26"
                    description = "The proxy-only subnet provides a set of IP addresses that Google uses to run Envoy proxies on your behalf. You must create one proxy-only subnet in each region of a VPC network where you use load balancers. https://cloud.google.com/load-balancing/docs/tcp#proxy-only_subnet"
                    purpose = "GLOBAL_MANAGED_PROXY"
                    role = "ACTIVE"
                },
            ],
            routers = {
                "r1" = {
                    attachments = {
                        "aus" = {
                            interconnect_id = "aus-zone1-1483-10g-lumen-445481965"
                            candidate_subnets = ["169.254.150.80/29"]
                            vlan = 3011
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
                            candidate_subnets = ["169.254.150.88/29"]
                            vlan = 3012
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

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
    network_name = "prod"
    base_labels = merge(include.common.locals.base_labels, {"env": include.gcp.locals.env})
    interconnects_project_id = "freight-interconnects"
    private_service_connect_google_ip = "10.243.0.0"

    global_advertised_ranges = [
        {
            range = "10.243.0.0/16"
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
        {
            range = "10.221.0.0/22"
            description = "GCP PSA for Cloud SQL Prod - advertised to on-prem via BGP"
        },
    ]
    secondary_ranges = {
        "us-south1-gke-poc" = [
            {
                range_name    = "services"
                ip_cidr_range = "10.239.128.0/20"
            },
            {
                range_name    = "pods"
                ip_cidr_range = "10.239.144.0/20"
            }
        ],
        "us-south1-gke-dev" = [
            {
                range_name    = "services"
                ip_cidr_range = "10.247.32.0/19"
            },
            {
                range_name    = "pods"
                ip_cidr_range = "10.247.64.0/18"
            }
        ],
        "us-south1-composer-network" = [
            {
                range_name = "services"
                ip_cidr_range = "10.247.6.0/23"
            },
            {
                range_name = "pods"
                ip_cidr_range = "10.247.8.0/23"
            }
        ]
        "us-south1-gke-prod-ptms-south1" = [
            {
                range_name = "services"
                ip_cidr_range = "10.247.132.0/22"
            },
            {
                range_name = "pods"
                ip_cidr_range = "10.247.136.0/21"
            }
        ]
        "us-east4-gke-prod-ptms-east4" = [
            {
                range_name = "services"
                ip_cidr_range = "10.245.20.0/22"
            },
            {
                range_name = "pods"
                ip_cidr_range = "10.245.24.0/21"
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
            name                    = "allow-workstations-to-control-plane-ingress"
            description             = "Allow ingress to the control plane IP address from the workstation VMs. https://cloud.google.com/workstations/docs/configure-firewall-rules?hl=en#allow_ingress"
            source_tags             = ["cloud-workstations-instance"]
            destination_ranges      = ["10.245.1.2"] # gcloud beta workstations clusters describe devpod-us-east4 --project=uf-cloud-workstations-p --region=us-east4
            allow = [{
                protocol = "tcp"
            }]
        },
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
            name                    = "allow-kafka-internal"
            description             = "Allow ingress to kafka connect & control center UI from internal IPs"
            source_ranges           = [ "10.0.0.0/8" ]
            destination_ranges      = [ "10.247.2.0/28" ]
            allow = [{
                protocol = "icmp"
            },
            {
                protocol = "tcp"
                ports    = [
                    "8083",
                    "9021",
                    "1521",
                    "443", #rest api port for confluent cloud
                    "9092", #bootstrap server port for confluent cloud
                    "8081", #schema registry port for confluent cloud
                    "29092" #bootstrap server port for confluent platform managed
                    ]
            }]
        },
        {
            name                    = "allow-kafka-connect-subnet-internal-ingress"
            description             = "Allow ingress communication between VMs in kafka-connect subnet"
            source_ranges           = [ "10.247.2.0/28" ]
            destination_ranges      = [ "10.247.2.0/28" ]
            allow = [{
                protocol = "icmp"
            },
            {
                protocol = "tcp"
                ports    = [
                    "8083",
                    "9021",
                    "1521",
                    "8081",
                    "9092",
                    "29092"
                    ]
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
            name                    = "allow-composer-network-subnet-internal-ingress"
            description             = "Allow ingress communication in composer-network subnet"
            source_ranges           = [ "10.247.4.0/23","10.247.6.0/23","10.247.8.0/23"]
            destination_ranges      = [ "10.247.4.0/23","10.247.6.0/23","10.247.8.0/23"]
            allow                   = [ {protocol = "all" }]
        },
        {
            name                    = "allow-gke-endpoint-access"
            description             = "Allow access to GKE master endpoint"
            source_ranges           = ["10.1.0.0/16", "10.2.0.0/16", "10.230.0.0/16", "10.231.0.0/16"]
            destination_ranges      = ["10.239.240.0/28", "10.247.11.0/24", "10.247.129.0/28", "10.245.17.0/28"]
            allow = [{
                protocol = "tcp"
                ports    = ["443", "10250"]
            }]
        },
        {
            name                    = "allow-gke-all-ingress"
            description             = "Allow all internal GKE communication (master, nodes, pods, services)"
            source_ranges           = [
                "10.239.0.0/24",      # GKE POC Cluster Node CIDR
                "10.239.128.0/20",    # GKE POC Cluster Service CIDR
                "10.239.144.0/20",    # GKE POC Cluster Pod CIDR
                "10.239.240.0/28"     # GKE POC Cluster Master CIDR
            ]
            destination_ranges      = [
                "10.239.0.0/24",      # GKE POC Cluster Node CIDR
                "10.239.128.0/20",    # GKE POC Cluster Service CIDR
                "10.239.144.0/20",    # GKE POC Cluster Pod CIDR
                "10.239.240.0/28"     # GKE POC Cluster Master CIDR
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["0-65535"]
            }]
        },
        {
            name                    = "allow-gke-dev-all-ingress"
            description             = "Allow all internal GKE communication (master, nodes, pods, services)"
            source_ranges           = [
                "10.247.11.0/24",     # GKE DEV Cluster Master CIDR
                "10.247.16.0/21",     # GKE DEV Cluster Node CIDR
                "10.247.32.0/19",     # GKE DEV Cluster Service CIDR
                "10.247.64.0/18",      # GKE DEV Cluster Pod CIDR
                "10.247.10.0/24",
                "10.247.254.0/24"
            ]
            destination_ranges      = [
                "10.247.11.0/24",     # GKE DEV Cluster Master CIDR
                "10.247.16.0/21",     # GKE DEV Cluster Node CIDR
                "10.247.32.0/19",     # GKE DEV Cluster Service CIDR
                "10.247.64.0/18",     # GKE DEV Cluster Pod CIDR
                "10.247.10.0/24",
                "10.247.254.0/24"
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["0-65535"]
            }]
        },
# GKE Prod PTMS South1
        {
            name                    = "allow-gke-prod-ptms-south1-all-ingress"
            description             = "Allow all internal GKE communication (master, nodes, pods, services)"
            source_ranges           = [
                "10.247.129.0/28",     # GKE Prod PTMS South1 Cluster Master CIDR
                "10.247.130.0/24",     # GKE Prod PTMS South1 Cluster Node CIDR
                "10.247.132.0/22",     # GKE Prod PTMS South1 Cluster Service CIDR
                "10.247.136.0/21",     # GKE Prod PTMS South1 Cluster Pod CIDR
                "10.247.10.0/24",      # Internal LB
                "10.1.0.0/16",
                "10.2.0.0/16",
                "10.247.254.0/24"      # Regional Managed Proxy
            ]
            destination_ranges      = [
                "10.247.129.0/28",     # GKE Prod PTMS South1 Cluster Master CIDR
                "10.247.130.0/24",     # GKE Prod PTMS South1 Cluster Node CIDR
                "10.247.132.0/22",     # GKE Prod PTMS South1 Cluster Service CIDR
                "10.247.136.0/21",     # GKE Prod PTMS South1 Cluster Pod CIDR
                "10.247.10.0/24",      # Internal LB
                "10.247.254.0/24"      # Regional Managed Proxy
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["0-65535"]
            }]
        },
# GKE Prod PTMS East4
        {
            name                    = "allow-gke-prod-ptms-east4-all-ingress"
            description             = "Allow all internal GKE communication (master, nodes, pods, services)"
            source_ranges           = [
                "10.245.17.0/28",     # GKE Prod PTMS East4 Cluster Master CIDR
                "10.245.18.0/24",     # GKE Prod PTMS East4 Cluster Node CIDR
                "10.245.20.0/22",     # GKE Prod PTMS East4 Cluster Service CIDR
                "10.245.24.0/21",     # GKE Prod PTMS East4 Cluster Pod CIDR
                "10.1.0.0/16",
                "10.2.0.0/16",
                "10.245.254.0/24",     # Regional Managed Proxy
                "10.245.10.0/24"     # Internal LB East4
            ]
            destination_ranges      = [
                "10.245.17.0/28",     # GKE Prod PTMS East4 Cluster Master CIDR
                "10.245.18.0/24",     # GKE Prod PTMS East4 Cluster Node CIDR
                "10.245.20.0/22",     # GKE Prod PTMS East4 Cluster Service CIDR
                "10.245.24.0/21",     # GKE Prod PTMS East4 Cluster Pod CIDR
                "10.245.254.0/24",    # Regional Managed Proxy
                "10.245.10.0/24"     # Internal LB East4
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
            name                    = "allow-ilb-to-backends"
            description             = "Allow HTTP from proxy subnet to backends"
            source_ranges           = [
                "10.247.254.0/24",
                "10.245.254.0/24",
                "10.246.254.0/24"
            ]
            destination_ranges      = [
                "10.2.60.29",
                "10.2.60.30",
                "10.2.60.31",
                "10.2.60.69",
                "10.2.60.70",
                "10.2.60.71"
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["80", "443", "8080"]
            }]
        },
        {
            name                    = "allow-gke-dev-openshift-all-ingress"
            description             = "Allow Connectivity between GKE DEV and OpenShift"
            source_ranges           = [
                 "10.2.60.120",      # Openshift api.ocp4-uat.transplace.com
                 "10.2.60.121",      # Openshift api.ocp4-uat.transplace.com
                 "10.1.224.29",      # Docker PROD Onpremise Registry
                 "10.2.224.21",      # Docker NONPROD Onpremise Registry
                 "10.2.154.76",
                 "10.2.154.77",
                 "10.2.154.78",
                 "10.2.154.79",
                 "10.2.154.80",
                 "10.2.154.81",
                 "10.2.154.82",
                 "10.2.154.83",
                 "10.2.154.84",
                 "10.2.154.85",
                 "10.2.154.86",
                 "10.67.100.202"
            ]
            destination_ranges      = [
                "10.247.11.0/24",     # GKE DEV Cluster Master CIDR
                "10.247.16.0/21",     # GKE DEV Cluster Node CIDR
                "10.247.32.0/19",     # GKE DEV Cluster Service CIDR
                "10.247.64.0/18"      # GKE DEV Cluster Pod CIDR
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["0-65535"]
            }]
        },
        {
            name                    = "allow-dataproc-internal-ingress"
            description             = "Allow internal traffic between Dataproc nodes"
            source_ranges           = ["10.247.14.0/23"]
            destination_ranges      = ["10.247.14.0/23"]
            allow = [{
                protocol = "all"
            }]
            target_tags             = ["dataproc-node"]
        },
        {
            name                    = "allow-data-fusion-ssh"
            description             = "Allow IPs from the the allocation for private data fusion instance to SSH to dataproc clusters"
            source_ranges           = ["172.27.20.0/22"]
            destination_ranges      = ["10.247.14.0/23"]
            allow = [{
                protocol = "tcp"
                ports    = ["22"]
            }]
        },
        {
            name                    = "allow-tmobile-ptms-compute-tcp-ingress"
            description             = "Allow inbound communication for management of tmobile ptms compute prod resources"
            source_ranges           = [
                "10.1.0.0/16",        # On-prem Dallas data center subnets
                "10.2.0.0/16",        # On-prem Austin data center subnets
                "10.3.0.0/16",        # On-prem Frisco office subnets
                "10.231.0.0/17"       # VPN worldwide user subnets                
            ]
            destination_ranges      = [
                "10.245.16.0/24",     # Compute resources for tmobile ptms east4
                "10.247.128.0/24"     # Compute resources for tmobile ptms south1
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
            description             = "Allow inbound communication for management of tmobile ptms compute prod resources"
            source_ranges           = [
                "10.1.0.0/16",        # On-prem Dallas data center subnets
                "10.2.0.0/16",        # On-prem Austin data center subnets
                "10.3.0.0/16",        # On-prem Frisco office subnets
                "10.231.0.0/17"       # VPN worldwide user subnets                
            ]
            destination_ranges      = [
                "10.245.16.0/24",     # Compute resources for tmobile ptms east4
                "10.247.128.0/24"     # Compute resources for tmobile ptms south1
            ]
            allow = [{
                protocol = "udp"
                ports    = [
                    "3389",           # RDP
                ]
            }]
        },
        {
            name                    = "allow-vertex-ai-internal-ingress"
            description             = "Allow internal traffic between Vertex AI nodes"
            source_ranges           = ["10.247.12.0/23"]
            destination_ranges      = ["10.247.12.0/23"]
            allow = [{
                protocol = "all"
            }]
            target_tags             = ["vertex-ai-node"]
        },
        {
            name                    = "allow-vertex-ai-ssh-iap"
            description             = "Allows SSH access to Vertex AI nodes only via Google Identity-Aware Proxy (IAP) ranges"
            source_ranges           = ["35.235.240.0/20"]
            destination_ranges      = ["10.247.12.0/23"]
            allow = [{
                protocol = "tcp"
                ports    = ["22"]
            }]
            target_tags             = ["vertex-ai-node"]
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
                "10.221.0.0/22",      # GCP PSA for Cloud SQL Prod
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
                    "443"
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
            name                    = "allow-workstations-to-control-plane-egress"
            description             = "Allow egress to the control plane IP address from VMs with the cloud-workstations-instance tag. https://cloud.google.com/workstations/docs/configure-firewall-rules?hl=en#allow_egress"
            target_tags             = ["cloud-workstations-instance"]
            destination_ranges      = ["10.245.1.2"] # gcloud beta workstations clusters describe devpod-us-east4 --project=uf-cloud-workstations-p --region=us-east4
            allow = [{
                protocol = "tcp"
                ports    = [
                    "980",
                    "443"
                ]
            }]
        },
        {
            priority                = 65527
            name                    = "allow-terraform-to-network-devices"
            description             = "GitHub Runners need to have access to management VLAN of network devices to execute terraform changes"
            source_ranges           = [ "10.247.1.0/24" ]
            destination_ranges      = [
                "10.1.150.0/24",
                "10.2.150.0/24",
            ]
            allow                   = [ {
                protocol = "tcp"
                ports = ["443"]
            }]
        },
        {
            priority                = 65527
            name                    = "allow-open-shift-api"
            description             = "GitHub Runners need to have access to open shift in order to execute deployments"
            source_ranges           = [ "10.247.1.0/24" ]
            destination_ranges      = [
                "10.2.60.250", # api.ocp4-dev.transplace.com
                "10.2.60.75", # api.ocp4-test.transplace.com
                "10.1.60.40", # api.ocp4-prod.transplace.com
                "10.2.60.120", # api.ocp4-uat.transplace.com
                "10.2.60.92", # api.ocp4-alpha.transplace.com
                "10.2.60.55", # api.ocp4-staging.transplace.com
                "10.227.11.0/28",
                "10.227.8.0/28"   # GKE ETL Dev Master
            ]
            allow = [{
                protocol = "tcp"
                ports    = [
                    "6443",
                    "443"
                ]
            }]
        },
        {
            priority                = 65527
            name                    = "allow-cloud-workstation-uber-rpc"
            description             = "Cloud workstations need to have access to uber-gw endpoints in order to make calls to Uber RPCs"
            source_ranges           = [ "10.245.1.0/24" ]
            destination_ranges      = [
                "10.249.0.166", # uber-gw-prod-dca.uberfreight.com
                "10.249.0.178", # uber-gw-prod-phx.uberfreight.com
                "10.249.0.163", # uber-gw-staging-dca.uberfreight.com
                "10.249.0.175", # uber-gw-staging-phx.uberfreight.com
            ]
            allow = [{
                protocol = "tcp"
                ports    = [
                    "80"
                ]
            }]
        },
        {
            priority                = 65527
            name                    = "allow-cloud-workstation-maven-repo"
            description             = "Cloud workstations need to have access to downoad maven artifacts from repo.transplace.com"
            source_ranges           = [ "10.245.1.0/24" ]
            destination_ranges      = [
                "10.67.200.242", # repo.transplace.com
                "10.1.104.76",   # maven.transplace.com
            ]
            allow = [{
                protocol = "tcp"
                ports    = [
                    "80",
                    "443"
                ]
            }]
        },
        {
            priority                = 65527
            name                    = "allow-cloud-workstation-oracle-db"
            description             = "Cloud workstations need to have access to oracle databases"
            source_ranges           = [ "10.245.1.0/24" ]
            destination_ranges      = [
                "10.2.154.76",
                "10.2.154.77",
                "10.2.154.78",
                "10.2.154.79",
                "10.2.154.80",
                "10.2.154.81",
                "10.2.154.82",
                "10.2.154.83",
                "10.2.154.84",
                "10.2.154.85",
                "10.2.154.86"
            ]
            allow = [{
                protocol = "tcp"
                ports    = [
                    "1521"
                ]
            }]
        },
        {
            priority                = 65527
            name                    = "allow-cloud-workstation-openshift"
            description             = "Cloud workstations need to have access to non-prod openshift api and external ips of kubernetes deployments"
            source_ranges           = [ "10.245.1.0/24" ]
            destination_ranges      = [
                "10.2.60.0/24" # non prod ocp
            ]
            allow = [{
                protocol = "tcp"
                ports    = [
                    "443",
                    "6443"
                ]
            }]
        },
        {
            priority                = 65527
            name                    = "allow-maven-http"
            description             = "GitHub Runners need to have access to maven registries in order to download artifacts"
            source_ranges           = [ "10.247.1.0/24" ]
            destination_ranges      = [
                "10.1.104.76", # maven.transplace.com
                "10.67.200.242", # repo.transplace.com
            ]
            allow = [{
                protocol = "tcp"
                ports    = [
                    "80"
                ]
            }]
        },
        {
            priority                = 65527
            name                    = "allow-kafka-connect-to-uber-accessible-psc"
            description             = "UF-data-warehouse-p Kafka connect instances need to have access to Uber Accessible PSC"
            source_ranges           = [ "10.247.2.0/28" ]
            destination_ranges      = [
                "10.255.252.128/26"
            ]
            allow = [{
                protocol = "tcp"
                ports    = [
                    "9092",
                    "443"
                ]
            }]
        },
        {
            priority                = 65527
            name                    = "allow-confluent-kafka-oracle-connection"
            description             = "Kafka connect instances need to have access to Oracle DB IPs"
            source_ranges           = [ "10.247.2.0/28" ]
            destination_ranges      = [
                "10.1.154.76", #dx8mp1-start
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
                "10.2.88.96", #ax8mr1-start
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
                "10.2.154.76", #lx8mu1-start
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
            priority                = 65527
            name                    = "allow-kafka-connect-subnet-internal-egress"
            description             = "Allow egress communication between VMs in kafka-connect subnet"
            source_ranges           = [ "10.247.2.0/28" ]
            destination_ranges      = [ "10.247.2.0/28" ]
            allow = [{
                protocol = "icmp"
            },
            {
                protocol = "tcp"
                ports    = [
                    "8083",
                    "9021",
                    "1521",
                    "8081",
                    "9092",
                    "29092"
                    ]
            }]
        },
        {
            priority                = 65527
            name                    = "allow-kafka-connect-vms-to-mexico-dbs"
            description             = "UF-data-warehouse-p vms and cloudcomposer to access mexico db"
            source_ranges           = [
                "10.247.2.0/28", #kafka-connect vms 
                "10.247.4.0/23", #composer-network primary_ranges
                "10.247.6.0/23", #composer-network secondary_ranges
                "10.247.8.0/23"  #composer-network secondary_ranges
            ]
            destination_ranges      = [
                "172.19.22.7", #mexicodb mysql db
                "10.1.110.48", #mexicodb sqlserver db
                "172.19.21.7", #mexicodb mysql db uat
                "10.2.246.25"  #mexicodb sqlserver db uat 
            ]
            allow = [{
                protocol = "tcp"
                ports    = [
                    "3306", #mysql port
                    "1433"  #sqlserver port
                ]
            }]
        },
        {
            priority                = 65527
            name                    = "allow-google-api-psc"
            description             = "The destination is Google Private Service Connect (PSC) IP that we use for Google APIs"
            destination_ranges      = [ "10.243.0.0" ]
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
                        9092
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
            name                    = "allow-gke-all-egress"
            description             = "Allow all internal GKE communication (master, nodes, pods, services)"
            source_ranges           = [
                "10.239.0.0/24",      # GKE POC Cluster Node CIDR
                "10.239.128.0/20",    # GKE POC Cluster Service CIDR
                "10.239.144.0/20",    # GKE POC Cluster Pod CIDR
                "10.239.240.0/28"     # GKE POC Cluster Master CIDR
            ]
            destination_ranges      = [
                "10.239.0.0/24",      # GKE POC Cluster Node CIDR
                "10.239.128.0/20",    # GKE POC Cluster Service CIDR
                "10.239.144.0/20",    # GKE POC Cluster Pod CIDR
                "10.239.240.0/28"     # GKE POC Cluster Master CIDR
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["0-65535"]
            }]
        },
        {
            priority                = 998
            name                    = "allow-gke-dev-openshift-all-egress"
            description             = "Allow Connectivity from GKE-Dev to Openshift"
            source_ranges           = [
                "10.247.11.0/24",     # GKE DEV Cluster Master CIDR
                "10.247.16.0/21",     # GKE DEV Cluster Node CIDR
                "10.247.32.0/19",     # GKE DEV Cluster Service CIDR
                "10.247.64.0/18"      # GKE DEV Cluster Pod CIDR
            ]
            destination_ranges      = [
                 "10.2.60.120",      # Openshift api.ocp4-uat.transplace.com
                 "10.2.60.121",      # Openshift api.ocp4-uat.transplace.com
                 "10.1.224.29",      # Docker PROD On-premise Registry
                 "10.2.224.21",      # Docker NONPROD On-premise Registry
                 "10.2.154.76",
                 "10.2.154.77",
                 "10.2.154.78",
                 "10.2.154.79",
                 "10.2.154.80",
                 "10.2.154.81",
                 "10.2.154.82",
                 "10.2.154.83",
                 "10.2.154.84",
                 "10.2.154.85",
                 "10.2.154.86",
                 "10.67.100.202",
                 "10.1.120.101",
                 "10.1.120.100",
                 "10.2.120.100",
                 "10.2.120.101",
                 "10.2.0.0/16",      # on-premise DEV Servers
                 "172.19.32.6",      # KMS Dev
                 "10.67.100.212"
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
                "10.247.11.0/24",     # GKE DEV Cluster Master CIDR
                "10.247.16.0/21",     # GKE DEV Cluster Node CIDR
                "10.247.32.0/19",     # GKE DEV Cluster Service CIDR
                "10.247.64.0/18",     # GKE DEV Cluster Pod CIDR
                "10.247.10.0/24",
                "10.247.254.0/24"
            ]
            destination_ranges      = [
                "10.247.11.0/24",     # GKE DEV Cluster Master CIDR
                "10.247.16.0/21",     # GKE DEV Cluster Node CIDR
                "10.247.32.0/19",     # GKE DEV Cluster Service CIDR
                "10.247.64.0/18",     # GKE DEV Cluster Pod CIDR
                "10.247.10.0/24",
                "10.247.254.0/24"
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["0-65535"]
            }]
        },
        {
            name                    = "allow-dataproc-egress"
            description             = "Allow egress traffic from Dataproc nodes"
            source_ranges           = ["10.247.14.0/23"]   
            destination_ranges      = ["0.0.0.0/0"]
            allow = [{
                protocol = "icmp"
            },
            {
                protocol = "tcp"
                ports    = ["0-65535"]
            },
            {
                protocol = "udp"
                ports    = ["0-65535"]
            }]
            target_tags             = ["dataproc-node"]
        },
# Egress PTMS South1
        {
            priority                = 998
            name                    = "allow-gke-prod-ptms-south1-all-egress"
            description             = "Allow all internal GKE communication (master, nodes, pods, services)"
            source_ranges           = [
                "10.247.129.0/28",     # GKE Prod PTMS South1 Cluster Master CIDR
                "10.247.130.0/24",     # GKE Prod PTMS South1 Cluster Node CIDR
                "10.247.132.0/22",     # GKE Prod PTMS South1 Cluster Service CIDR
                "10.247.136.0/21",     # GKE Prod PTMS South1 Cluster Pod CIDR
                "10.247.10.0/24",     # Internal LB South1
                "10.247.254.0/24"     # Regional Managed Proxy
            ]
            destination_ranges      = [
                "10.247.129.0/28",     # GKE Prod PTMS South1 Cluster Master CIDR
                "10.247.130.0/24",     # GKE Prod PTMS South1 Cluster Node CIDR
                "10.247.132.0/22",     # GKE Prod PTMS South1 Cluster Service CIDR
                "10.247.136.0/21",     # GKE Prod PTMS South1 Cluster Pod CIDR
                "10.247.10.0/24",     # Internal LB South1
                "10.247.254.0/24",    # Regional Managed Proxy
                "10.1.0.0/16",        # on-premise data center Servers
                "10.2.0.0/16",        # on-premise data center Servers
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["0-65535"]
            }]
        },
# Egress PTMS East4
        {
            priority                = 998
            name                    = "allow-gke-prod-ptms-east4-all-egress"
            description             = "Allow all internal GKE communication (master, nodes, pods, services)"
            source_ranges           = [
                "10.245.17.0/28",     # GKE Prod PTMS East4 Cluster Master CIDR
                "10.245.18.0/24",     # GKE Prod PTMS East4 Cluster Node CIDR
                "10.245.20.0/22",     # GKE Prod PTMS East4 Cluster Service CIDR
                "10.245.24.0/21",     # GKE Prod PTMS East4 Cluster Pod CIDR
                "10.245.254.0/24",     # Regional Managed Proxy
                "10.245.10.0/24"     # Internal LB East4
            ]
            destination_ranges      = [
                "10.245.17.0/28",     # GKE Prod PTMS East4 Cluster Master CIDR
                "10.245.18.0/24",     # GKE Prod PTMS East4 Cluster Node CIDR
                "10.245.20.0/22",     # GKE Prod PTMS East4 Cluster Service CIDR
                "10.245.24.0/21",     # GKE Prod PTMS East4 Cluster Pod CIDR
                "10.245.254.0/24",    # Regional Managed Proxy
                "10.1.0.0/16",        # on-premise data center Servers
                "10.2.0.0/16",        # on-premise data center Servers
                "10.245.10.0/24"     # Internal LB East4
            ]
            allow = [{
                protocol = "tcp"
                ports    = ["0-65535"]
            }]
        },
        {
            priority                = 65527
            name                    = "allow-composer-prod-email-egress"
            description             = "Allow composer email outbound to mailblast server on-prem"
            source_ranges           = [
                "10.247.4.0/23",      # composer-network subnet
                "10.247.6.0/23",
                "10.247.8.0/23"
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
            description             = "Allow internal t-mobile ptms compute prod tcp communication outbound for domain join to on-prem"
            source_ranges           = [
                "10.245.16.0/24",     # Compute resources for tmobile ptms east4
                "10.247.128.0/24"     # Compute resources for tmobile ptms south1
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
            description             = "Allow internal t-mobile ptms compute prod udp communication outbound for domain join to on-prem"
            source_ranges           = [
                "10.245.16.0/24",     # Compute resources for tmobile ptms east4
                "10.247.128.0/24"     # Compute resources for tmobile ptms south1
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
            asn = 65152
            psc_subnet_ip = "10.245.0.0/24"
            subnets = [
                {
                    name = "cloud-workstations-s1"
                    ip = "10.245.1.0/24"
                    description = "Used for GCP managed developer Cloud Workstations in Dallas GCP region"
                    purpose = "PRIVATE"
                },
                {
                    name = "regional-managed-proxy"
                    ip = "10.245.254.0/24"
                    description = "The proxy-only subnet provides a set of IP addresses that Google uses to run Envoy proxies on your behalf. You must create one proxy-only subnet in each region of a VPC network where you use load balancers. https://cloud.google.com/load-balancing/docs/tcp#proxy-only_subnet"
                    purpose = "REGIONAL_MANAGED_PROXY"
                    role = "ACTIVE"
                },
                {
                    name = "private-dns"
                    ip = "10.245.255.248/29"
                    description = "This subnet is used to ensure that the DNS inbound policy IP does not change when subnets get deleted. We have one per region."
                    purpose = "PRIVATE"
                },
                {
                    name = "tmobile-ptms-compute-prod"
                    ip = "10.245.16.0/24"
                    description = "Compute resources for TMobile PTMS Prod only"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "tmobile-ptms-db-prod"
                    ip = "10.245.19.0/27"
                    description = "Subnet for DB Resources, reserved for T-Mobile PTMS"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "gke-prod-ptms-east4"
                    ip = "10.245.18.0/24"
                    description = "Subnet for GKE Nodes in VPC Native Setup"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "internal-lb"
                    ip = "10.245.10.0/24"
                    description = "Subnet for Internal Load Balancers Frontend IP"
                    purpose = "PRIVATE"
                    private_access = true
                },
            ],
            routers = {
                "r1" = {
                    attachments = {
                        "dal" = {
                            interconnect_id = "dfw-zone1-4-10g-lumen-445481978"
                            candidate_subnets = ["169.254.91.104/29"]
                            vlan = 3000
                            peer = {
                                name     = "dal-rt1-9508"
                                peer_asn = 65101
                            }
                        }
                        "aus" = {
                            interconnect_id = "aus-zone1-1483-10g-lumen-445481965"
                            candidate_subnets = ["169.254.100.80/29"]
                            vlan = 3000
                            peer = {
                                name     = "aus-r1c6-34-agg1"
                                peer_asn = 65105
                            }
                        }
                    }
                }
                "r2" = {
                    attachments = {
                        "dal" = {
                            interconnect_id = "dfw-zone2-4-10g-zayo-ogyx386323zyo"
                            candidate_subnets = ["169.254.195.160/29"]
                            vlan = 3001
                            peer = {
                                name     = "dal-rt1-9508"
                                peer_asn = 65101
                            }
                        }
                        "aus" = {
                            interconnect_id = "aus-zone2-1483-10g-zayo-ogyx386722zyo"
                            candidate_subnets = ["169.254.45.168/29"]
                            vlan = 3001
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
            asn = 65153
            subnets = [
                {
                    name = "regional-managed-proxy"
                    ip = "10.246.254.0/24"
                    description = "The proxy-only subnet provides a set of IP addresses that Google uses to run Envoy proxies on your behalf. You must create one proxy-only subnet in each region of a VPC network where you use load balancers. https://cloud.google.com/load-balancing/docs/tcp#proxy-only_subnet"
                    purpose = "REGIONAL_MANAGED_PROXY"
                    role = "ACTIVE"
                },
                {
                    name = "private-dns"
                    ip = "10.246.255.248/29"
                    description = "This subnet is used to ensure that the DNS inbound policy IP does not change when subnets get deleted. We have one per region."
                    purpose = "PRIVATE"
                },
            ],
            routers = {
                "r1" = {
                    attachments = {
                        "dal" = {
                            interconnect_id = "dfw-zone1-4-10g-lumen-445481978"
                            candidate_subnets = ["169.254.207.32/29"]
                            vlan = 3002
                            peer = {
                                name     = "dal-rt1-9508"
                                peer_asn = 65101
                            }
                        }
                        "aus" = {
                            interconnect_id = "aus-zone1-1483-10g-lumen-445481965"
                            candidate_subnets = ["169.254.3.152/29"]
                            vlan = 3002
                            peer = {
                                name     = "aus-r1c6-34-agg1"
                                peer_asn = 65105
                            }
                        }
                    }
                }
                "r2" = {
                    attachments = {
                        "dal" = {
                            interconnect_id = "dfw-zone2-4-10g-zayo-ogyx386323zyo"
                            candidate_subnets = ["169.254.34.8/29"]
                            vlan = 3003
                            peer = {
                                name     = "dal-rt1-9508"
                                peer_asn = 65101
                            }
                        }
                        "aus" = {
                            interconnect_id = "aus-zone2-1483-10g-zayo-ogyx386722zyo"
                            candidate_subnets = ["169.254.56.216/29"]
                            vlan = 3003
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
            asn = 65154
            psc_subnet_ip = "10.247.0.0/24"
            subnets = [
                {
                    name = "github-runners"
                    ip = "10.247.1.0/24"
                    description = "Self hosted GitHub runner"
                    purpose = "PRIVATE"
                },
                {
                    name = "kafka-connect"
                    ip = "10.247.2.0/28"
                    description = "Kafka connect instances will run in this subnet"
                    purpose = "PRIVATE"
                },
                {
                    name = "cameyo"
                    ip = "10.247.2.64/26"
                    description = "Cameyo servers used to run remote apps"
                    purpose = "PRIVATE"
                },
                {
                    name = "regional-managed-proxy"
                    ip = "10.247.254.0/24"
                    description = "The proxy-only subnet provides a set of IP addresses that Google uses to run Envoy proxies on your behalf. You must create one proxy-only subnet in each region of a VPC network where you use load balancers. https://cloud.google.com/load-balancing/docs/tcp#proxy-only_subnet"
                    purpose = "REGIONAL_MANAGED_PROXY"
                    role = "ACTIVE"
                },
                {
                    name = "private-dns"
                    ip = "10.247.255.248/29"
                    description = "This subnet is used to ensure that the DNS inbound policy IP does not change when subnets get deleted. We have one per region."
                    purpose = "PRIVATE"
                },
                {
                    name = "dataflow-logging"
                    ip = "10.247.3.0/26"
                    description = "Subnet for Dataflow instance for Datadog logging"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "gke-poc"
                    ip = "10.239.0.0/24"
                    description = "Subnet for GKE Nodes in VPC Native Setup"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "gke-dev"
                    ip = "10.247.16.0/21"
                    description = "Subnet for GKE Nodes in VPC Native Setup"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "composer-network"
                    ip = "10.247.4.0/23"
                    description = "Cloud composer instances will run in this subnet"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "internal-lb"
                    ip = "10.247.10.0/24"
                    description = "Subnet for Internal Load Balancers Frontend IP"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "uberdev-internal-lb"
                    ip = "10.255.252.248/29"
                    description = "Subnet for Uber Internal Load Balancers Frontend IP"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "uber-accessible-psc"
                    ip = "10.255.252.128/26"
                    description = "US South IPs that are accessible from Uber Infra"
                    purpose = "PRIVATE"
                },
                {
                    name = "datafusion-network"
                    ip = "10.247.14.0/23"
                    description = "Cloud data fusion instances will run in this subnet"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "tmobile-ptms-compute-prod"
                    ip = "10.247.128.0/24"
                    description = "Compute resources for TMobile PTMS Prod only"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "tmobile-ptms-db-prod"
                    ip = "10.247.2.32/27"
                    description = "Subnet for DB Resources, reserved for T-Mobile PTMS"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "gke-prod-ptms-south1"
                    ip = "10.247.130.0/24"
                    description = "Subnet for GKE Nodes in VPC Native Setup"
                    purpose = "PRIVATE"
                    private_access = true
                },
                {
                    name = "vertex-ai-network"
                    ip = "10.247.12.0/23"
                    description = "Vertex AI models and ML notebooks will run in this subnet"
                    purpose = "PRIVATE"
                    private_access = true
                },
            ],
            routers = {
                "r1" = {
                    attachments = {
                        "dal" = {
                            interconnect_id = "dfw-zone1-4-10g-lumen-445481978"
                            candidate_subnets = ["169.254.162.200/29"]
                            vlan = 3004
                            peer = {
                                name     = "dal-rt1-9508"
                                peer_asn = 65101
                            }
                        }
                        "aus" = {
                            interconnect_id = "aus-zone1-1483-10g-lumen-445481965"
                            candidate_subnets = ["169.254.31.224/29"]
                            vlan = 3004
                            peer = {
                                name     = "aus-r1c6-34-agg1"
                                peer_asn = 65105
                            }
                        }
                    }
                }
                "r2" = {
                    attachments = {
                        "dal" = {
                            interconnect_id = "dfw-zone2-4-10g-zayo-ogyx386323zyo"
                            candidate_subnets = ["169.254.17.120/29"]
                            vlan = 3005
                            peer = {
                                name     = "dal-rt1-9508"
                                peer_asn = 65101
                            }
                        }
                        "aus" = {
                            interconnect_id = "aus-zone2-1483-10g-zayo-ogyx386722zyo"
                            candidate_subnets = ["169.254.187.248/29"]
                            vlan = 3005
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

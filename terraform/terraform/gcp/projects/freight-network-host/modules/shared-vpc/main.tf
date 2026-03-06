module "network" {
  source  = "terraform-google-modules/network/google"
  version = "9.0.0"

  shared_vpc_host = true
  description     = "Uber Freight shared VPC for environment"

  # See here why https://uberfreight.atlassian.net/wiki/spaces/NT/pages/76415207/6.3+Firewall+policies#6.3.4-Evaluation-order
  # and here https://cloud.google.com/firewall/docs/firewall-policies-overview#rule-evaluation
  network_firewall_policy_enforcement_order = "BEFORE_CLASSIC_FIREWALL"

  network_name = var.network_name
  project_id   = var.project_id

  subnets = concat(
    [
      for region, rconfig in var.regions : {
        subnet_name   = "${region}-psc"
        subnet_region = region
        subnet_ip     = rconfig.psc_subnet_ip
      } if rconfig.psc_subnet_ip != null
    ],
    [
      for region, rconfig in var.regions : [
        for subnet in rconfig.subnets : {
          subnet_name                      = "${region}-${subnet.name}"
          subnet_ip                        = subnet.ip
          subnet_region                    = region
          subnet_private_access            = subnet.private_access
          subnet_private_ipv6_access       = subnet.private_ipv6_access
          subnet_flow_logs                 = subnet.flow_logs
          subnet_flow_logs_interval        = subnet.flow_logs_interval
          subnet_flow_logs_sampling        = subnet.flow_logs_sampling
          subnet_flow_logs_metadata        = subnet.flow_logs_metadata
          subnet_flow_logs_filter          = subnet.flow_logs_filter
          subnet_flow_logs_metadata_fields = subnet.flow_logs_metadata_fields
          description                      = subnet.description
          purpose                          = subnet.purpose
          role                             = subnet.role
          stack_type                       = subnet.stack_type
          ipv6_access_type                 = subnet.ipv6_access_type
        }
      ]
    ]...
  )

  secondary_ranges = var.secondary_ranges

  routes = var.routes

  ingress_rules = [
    for rule in var.ingress_rules : merge(rule, {
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    })
  ]

  egress_rules = [
    for rule in var.egress_rules : merge(rule, {
      log_config = {
        metadata = "INCLUDE_ALL_METADATA"
      }
    })
  ]
}

module "cloud_router_interconnect" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 6.0"

  for_each = merge([
    for region, reconfig in var.regions : {
      for router, rtconfig in reconfig.routers : "${region}-${router}" => {
        asn    = reconfig.asn
        region = region
      }
    }
  ]...)

  name    = each.key
  project = var.project_id
  network = var.network_name
  region  = each.value.region

  bgp = {
    asn               = each.value.asn
    advertised_groups = ["ALL_SUBNETS"]

    advertised_ip_ranges = var.global_advertised_ranges
  }
}

module "cloud_router_nat" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 6.0"

  for_each = var.regions

  name    = "${each.key}-nat"
  project = var.project_id
  network = var.network_name
  region  = each.key

  nats = [
    {
      name                               = each.key
      nat_ip_allocate_option             = "AUTO_ONLY"
      source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
    }
  ]
}

module "interconnect_attachment" {
  source  = "terraform-google-modules/cloud-router/google//modules/interconnect_attachment"
  version = "~> 6.0"

  for_each = merge([
    for region, reconfig in var.regions : merge([
      for router, rtconfig in reconfig.routers : {
        for attachment, iconfig in rtconfig.attachments : "${region}-${router}-${attachment}" => {
          region            = region
          router_name       = "${region}-${router}"
          interconnect_id   = iconfig.interconnect_id
          type              = iconfig.type
          bandwidth         = iconfig.bandwidth
          vlan              = iconfig.vlan
          peer              = iconfig.peer
          candidate_subnets = iconfig.candidate_subnets
        }
      }
    ]...)
  ]...)

  name              = each.key
  type              = each.value.type
  vlan_tag8021q     = each.value.vlan
  bandwidth         = each.value.bandwidth
  project           = var.project_id
  region            = each.value.region
  candidate_subnets = each.value.candidate_subnets
  router            = module.cloud_router_interconnect[each.value.router_name].router.name

  interconnect = each.value.type == "DEDICATED" ? "https://www.googleapis.com/compute/v1/projects/${var.interconnects_project_id}/global/interconnects/${each.value.interconnect_id}" : null

  interface = {
    name = each.key
  }

  peer = {
    name                      = each.value.peer.name
    peer_asn                  = each.value.peer.peer_asn
    advertised_route_priority = each.value.peer.advertised_route_priority
    bfd = each.value.peer.bfd != null ? {
      session_initialization_mode = each.value.peer.bfd.session_initialization_mode
      min_transmit_interval       = each.value.peer.bfd.min_transmit_interval
      min_receive_interval        = each.value.peer.bfd.min_receive_interval
      multiplier                  = each.value.peer.bfd.multiplier
    } : null
  }
}

module "private_service_connect_google" {
  source     = "terraform-google-modules/network/google//modules/private-service-connect"
  version    = "9.1.0"
  depends_on = [module.network]

  count = var.private_service_connect_google_ip != "" ? 1 : 0

  forwarding_rule_name         = "google"
  private_service_connect_name = "psc-global-google"
  project_id                   = var.project_id
  network_self_link            = module.network.network_self_link
  private_service_connect_ip   = var.private_service_connect_google_ip
  forwarding_rule_target       = "all-apis"
}

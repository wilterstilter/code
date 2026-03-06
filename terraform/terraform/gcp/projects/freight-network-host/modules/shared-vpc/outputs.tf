output "network_id" {
  value       = module.network.network_id
  description = "Shared VPC ID"
}

output "network" {
  value       = module.network
  description = "Shared VPC Network with all associated outputs."
}

output "network_self_link" {
  value       = module.network.network_self_link
  description = "The URI of the VPC being created."
}

output "psc_regional_subnets" {
  value = {
    for region, rconfig in var.regions : region => module.network.subnets["${region}/${region}-psc"].id if rconfig.psc_subnet_ip != null
  }
  description = "The subnet name that was created for Private Service Connection endpoints"
}

output "gke_subnet" {
  description = "The self link of the gke nodes subnet"
  value = {
    for region, rconfig in var.regions : region => try(module.network.subnets["${region}/${region}-gke-poc"], null) if contains(keys(module.network.subnets), "${region}/${region}-gke-poc")
  }
}

output "gke_subnet_dev" {
  description = "The self link of the gke nodes subnet"
  value = {
    for region, rconfig in var.regions : region => try(module.network.subnets["${region}/${region}-gke-dev"], null) if contains(keys(module.network.subnets), "${region}/${region}-gke-dev")
  }
}

output "gke_subnet_nonprod" {
  description = "The self link of the gke nodes subnet"
  value = {
    for region, rconfig in var.regions : region => try(module.network.subnets["${region}/${region}-gke-nonprod"], null) if contains(keys(module.network.subnets), "${region}/${region}-gke-nonprod")
  }
}
output "gke_subnet_dev_ptms" {
  description = "The self link of the gke nodes subnet"
  value = {
    for region, rconfig in var.regions : region => try(module.network.subnets["${region}/${region}-gke-dev-ptms"], null) if contains(keys(module.network.subnets), "${region}/${region}-gke-dev-ptms")
  }
}
output "gke_subnet_nonprod_ptms_south1" {
  description = "The self link of the gke nodes subnet"
  value = {
    for region, rconfig in var.regions : region => try(module.network.subnets["${region}/${region}-gke-nonprod-ptms-south1"], null) if contains(keys(module.network.subnets), "${region}/${region}-gke-nonprod-ptms-south1")
  }
}

output "gke_subnet_nonprod_ptms_east4" {
  description = "The self link of the gke nodes subnet"
  value = {
    for region, rconfig in var.regions : region => try(module.network.subnets["${region}/${region}-gke-nonprod-ptms-east4"], null) if contains(keys(module.network.subnets), "${region}/${region}-gke-nonprod-ptms-east4")
  }
}

output "gke_subnet_prod_ptms_south1" {
  description = "The self link of the gke nodes subnet"
  value = {
    for region, rconfig in var.regions : region => try(module.network.subnets["${region}/${region}-gke-prod-ptms-south1"], null) if contains(keys(module.network.subnets), "${region}/${region}-gke-prod-ptms-south1")
  }
}

output "gke_subnet_prod_ptms_east4" {
  description = "The self link of the gke nodes subnet"
  value = {
    for region, rconfig in var.regions : region => try(module.network.subnets["${region}/${region}-gke-prod-ptms-east4"], null) if contains(keys(module.network.subnets), "${region}/${region}-gke-prod-ptms-east4")
  }
}

output "dataflow-subnet" {
  description = "The self link of the dataflow logging subnet"
  value = {
    for region, rconfig in var.regions : region => try(module.network.subnets["${region}/${region}-dataflow-logging"], null) if contains(keys(module.network.subnets), "${region}/${region}-dataflow-logging")
  }
}

output "composer-network" {
  description = "The self link of the composer-network subnet"
  value = {
    for region, rconfig in var.regions : region => try(module.network.subnets["${region}/${region}-composer-network"], null) if contains(keys(module.network.subnets), "${region}/${region}-composer-network")
  }
}

output "iaas_vms_subnet" {
  description = "The self link of the iaas virtual machines subnet"
  value = {
    for region, rconfig in var.regions : region => try(module.network.subnets["${region}/${region}-iaas-vms"], null) if contains(keys(module.network.subnets), "${region}/${region}-iaas-vms")
  }
}

output "composer-network-secondary-ranges" {
  description = "Secondary ranges for composer-network subnet"
  value = {
    for region, rconfig in var.regions : region => contains(keys(module.network.subnets), "${region}/${region}-composer-network") ? try([
      for range in var.secondary_ranges["composer-network"] : {
        range_name    = range.range_name
        subnet_id     = try(module.network.subnets["${region}/${region}-composer-network"].id, null)
        ip_cidr_range = range.ip_cidr_range
      }
    ], null) : null
  }
}

output "gke_poc_secondary_ranges" {
  description = "Secondary range for gke-poc network"
  value = {
    for region, rconfig in var.regions : region => contains(keys(module.network.subnets), "${region}/${region}-gke-poc") ? try([
      for range in var.secondary_ranges["gke-poc"] : {
        range_name    = range.range_name
        subnet_id     = try(module.network.subnets["${region}/${region}-gke-poc"].id, null)
        ip_cidr_range = range.ip_cidr_range
      }
    ], null) : null
  }
}

output "gke_dev_secondary_ranges" {
  description = "Secondary range for gke-dev network"
  value = {
    for region, rconfig in var.regions : region => contains(keys(module.network.subnets), "${region}/${region}-gke-dev") ? try([
      for range in var.secondary_ranges["gke-dev"] : {
        range_name    = range.range_name
        subnet_id     = try(module.network.subnets["${region}/${region}-gke-dev"].id, null)
        ip_cidr_range = range.ip_cidr_range
      }
    ], null) : null
  }
}

output "gke_dev_ptms_secondary_ranges" {
  description = "Secondary range for gke-dev-ptms network"
  value = {
    for region, rconfig in var.regions : region => contains(keys(module.network.subnets), "${region}/${region}-gke-dev-ptms") ? try([
      for range in var.secondary_ranges["gke-dev-ptms"] : {
        range_name    = range.range_name
        subnet_id     = try(module.network.subnets["${region}/${region}-gke-dev-ptms"].id, null)
        ip_cidr_range = range.ip_cidr_range
      }
    ], null) : null
  }
}

output "gke_nonprod_ptms_south1_secondary_ranges" {
  description = "Secondary range for gke-nonprod-ptms-south1 network"
  value = {
    for region, rconfig in var.regions : region => contains(keys(module.network.subnets), "${region}/${region}-gke-nonprod-ptms-south1") ? try([
      for range in var.secondary_ranges["us-south1-gke-nonprod-ptms-south1"] : {
        range_name    = range.range_name
        subnet_id     = try(module.network.subnets["${region}/${region}-gke-nonprod-ptms-south1"].id, null)
        ip_cidr_range = range.ip_cidr_range
      }
    ], null) : null
  }
}

output "gke_prod_ptms_south1_secondary_ranges" {
  description = "Secondary range for gke-prod-ptms-south1 network"
  value = {
    for region, rconfig in var.regions : region => contains(keys(module.network.subnets), "${region}/${region}-gke-prod-ptms-south1") ? try([
      for range in var.secondary_ranges["us-south1-gke-prod-ptms-south1"] : {
        range_name    = range.range_name
        subnet_id     = try(module.network.subnets["${region}/${region}-gke-prod-ptms-south1"].id, null)
        ip_cidr_range = range.ip_cidr_range
      }
    ], null) : null
  }
}

output "gke_nonprod_ptms_east4_secondary_ranges" {
  description = "Secondary range for gke-nonprod-ptms-east4 network"
  value = {
    for region, rconfig in var.regions : region => contains(keys(module.network.subnets), "${region}/${region}-gke-nonprod-ptms-east4") ? try([
      for range in var.secondary_ranges["us-east4-gke-nonprod-ptms-east4"] : {
        range_name    = range.range_name
        subnet_id     = try(module.network.subnets["${region}/${region}-gke-nonprod-ptms-east4"].id, null)
        ip_cidr_range = range.ip_cidr_range
      }
    ], null) : null
  }
}

output "gke_prod_ptms_east4_secondary_ranges" {
  description = "Secondary range for gke-prod-ptms-east4 network"
  value = {
    for region, rconfig in var.regions : region => contains(keys(module.network.subnets), "${region}/${region}-gke-prod-ptms-east4") ? try([
      for range in var.secondary_ranges["us-east4-gke-prod-ptms-east4"] : {
        range_name    = range.range_name
        subnet_id     = try(module.network.subnets["${region}/${region}-gke-prod-ptms-east4"].id, null)
        ip_cidr_range = range.ip_cidr_range
      }
    ], null) : null
  }
}

output "secondary_ranges" {
  value       = { for subnet, ranges in var.secondary_ranges : subnet => { for range in ranges : range.range_name => range.ip_cidr_range } }
  description = "Map of subnets to range names to IP CIDR ranges"
}

output "uber_accessible_psc_subnet" {
  description = "The self link of the uber accessible psc subnet"
  value = {
    for region, rconfig in var.regions : region => try(module.network.subnets["${region}/${region}-uber-accessible-psc"], null) if contains(keys(module.network.subnets), "${region}/${region}-uber-accessible-psc")
  }
}

output "internal-lb" {
  description = "The self link of the internal load balancer subnet"
  value = {
    for region, rconfig in var.regions : region => try(module.network.subnets["${region}/${region}-internal-lb"], null) if contains(keys(module.network.subnets), "${region}/${region}-internal-lb")
  }
}

output "uberdev-internal-lb" {
  description = "The self link of the uber internal load balancer subnet"
  value = {
    for region, rconfig in var.regions : region => try(module.network.subnets["${region}/${region}-uberdev-internal-lb"], null) if contains(keys(module.network.subnets), "${region}/${region}-uberdev-internal-lb")
  }
}

output "regional-managed-proxy" {
  description = "The self link of the regional managed proxy subnet"
  value = {
    for region, rconfig in var.regions : region => try(module.network.subnets["${region}/${region}-regional-managed-proxy"], null) if contains(keys(module.network.subnets), "${region}/${region}-regional-managed-proxy")
  }
}

output "tmobile-ptms-compute-dev" {
  description = "The self link of the tmobile-ptms-compute-dev subnets"
  value = {
    for region, rconfig in var.regions : region => try(module.network.subnets["${region}/${region}-tmobile-ptms-compute-dev"], null) if contains(keys(module.network.subnets), "${region}/${region}-tmobile-ptms-compute-dev")
  }
}

output "tmobile-ptms-compute-qa" {
  description = "The self link of the tmobile-ptms-compute-qa subnets"
  value = {
    for region, rconfig in var.regions : region => try(module.network.subnets["${region}/${region}-tmobile-ptms-compute-qa"], null) if contains(keys(module.network.subnets), "${region}/${region}-tmobile-ptms-compute-qa")
  }
}

output "tmobile-ptms-compute-nonprod" {
  description = "The self link of the tmobile-ptms-compute-nonprod subnets"
  value = {
    for region, rconfig in var.regions : region => try(module.network.subnets["${region}/${region}-tmobile-ptms-compute-nonprod"], null) if contains(keys(module.network.subnets), "${region}/${region}-tmobile-ptms-compute-nonprod")
  }
}

output "tmobile-ptms-compute-prod" {
  description = "The self link of the tmobile-ptms-compute-prod subnets"
  value = {
    for region, rconfig in var.regions : region => try(module.network.subnets["${region}/${region}-tmobile-ptms-compute-prod"], null) if contains(keys(module.network.subnets), "${region}/${region}-tmobile-ptms-compute-prod")
  }
}

output "tmobile-ptms-db-dev" {
  description = "The self link of the tmobile-ptms-db-dev subnets"
  value = {
    for region, rconfig in var.regions : region => try(module.network.subnets["${region}/${region}-tmobile-ptms-db-dev"], null) if contains(keys(module.network.subnets), "${region}/${region}-tmobile-ptms-db-dev")
  }
}

output "tmobile-ptms-db-qa" {
  description = "The self link of the tmobile-ptms-db-qa subnets"
  value = {
    for region, rconfig in var.regions : region => try(module.network.subnets["${region}/${region}-tmobile-ptms-db-qa"], null) if contains(keys(module.network.subnets), "${region}/${region}-tmobile-ptms-db-qa")
  }
}

output "tmobile-ptms-db-uat" {
  description = "The self link of the tmobile-ptms-db-uat subnets"
  value = {
    for region, rconfig in var.regions : region => try(module.network.subnets["${region}/${region}-tmobile-ptms-db-uat"], null) if contains(keys(module.network.subnets), "${region}/${region}-tmobile-ptms-db-uat")
  }
}

output "global-managed-proxy" {
  description = "The self link of the global managed proxy subnet for cross-regional load balancers"
  value = {
    for region, rconfig in var.regions : region => try(module.network.subnets["${region}/${region}-global-managed-proxy"], null) if contains(keys(module.network.subnets), "${region}/${region}-global-managed-proxy")
  }
}
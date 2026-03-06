# Private Service Access (PSA) in Nonprod
#
# This configuration reserves an IP range and sets up service networking connection
# to enable Google-managed services (Cloud SQL, Memorystore, Data Fusion, etc.) 
# with Private Service Access connectivity.
#
# PSA provides:
# - Private IP allocation for Google-managed services
# - Automatic DNS management (write endpoints for Cloud SQL)
# - VPC-native connectivity without public IPs
# 
# IP Ranges:
# - 172.27.24.0/22 (1,024 IPs) - Follows prod pattern: prod uses 172.27.20.0/22 for Data Fusion
# - 10.221.4.0/22 (1,024 IPs) - Additional range for Cloud SQL and other services
# - Google will automatically allocate IPs from these ranges for PSA-enabled services

include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

include "common" {
  path   = find_in_parent_folders("common.hcl")
  expose = true
}

terraform {
  source = "${dirname(find_in_parent_folders())}//projects/freight-network-host/modules/private-service-access"
}

inputs = {
  project_id   = include.gcp.locals.project_id
  network_name = "nonprod"
  psa_ranges = {
    "cloudsql-psa-nonprod" = {
      address       = "172.27.24.0"
      prefix_length = 22
      description   = "IP range reserved for Cloud SQL Private Service Access in nonprod"
    }
    "psa-nonprod" = {
      address       = "10.221.4.0"
      prefix_length = 22
      description   = "IP range reserved for Private Service Access (Cloud SQL, Memorystore, Data Fusion, etc.) in nonprod"
    }
  }
}

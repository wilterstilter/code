# Common configuration for OCI POC compartment
locals {
  # OCI Region
  region = "us-phoenix-1"

  # Get compartment OCID from OCI Console:
  # Identity & Security → Compartments → Click "Terafarm_POC" → Copy OCID
  compartment_id = "ocid1.compartment.oc1..aaaaaaaat3dohocc7xaaewdzdjde2g6y5fcrxj7tjcukwp7ltyjk4ziber4q"

  # Object Storage namespace (visible in OCI console under Object Storage settings)
  namespace = "axxfnu2zuvam"

  # Common tags
  common_tags = {
    Environment = "poc"
    ManagedBy   = "terraform"
    Team        = "platform"
  }

  fastconnect = {
    megaport_primary_service_key   = "MP-PRIMARY-KEY-PLACEHOLDER"
    megaport_secondary_service_key = "MP-SECONDARY-KEY-PLACEHOLDER"
  }
}


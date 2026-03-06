terraform {
  required_version = ">=1.5"

  required_providers {
    nxos = {
      source  = "CiscoDevNet/nxos"
      version = "0.5.2"
    }
    iosxe = {
      source  = "CiscoDevNet/iosxe"
      version = "0.5.5"
    }
  }
}

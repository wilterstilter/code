module "disable_serial_port_access" {
  source  = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version = "5.3.0"

  policy_root      = "organization"
  policy_root_id   = var.organization_id
  constraint       = "compute.disableSerialPortAccess"
  policy_type      = "boolean"
  exclude_folders  = []
  exclude_projects = []

  rules = [
    {
      conditions  = []
      allow       = []
      deny        = []
      enforcement = true
    },
  ]
}

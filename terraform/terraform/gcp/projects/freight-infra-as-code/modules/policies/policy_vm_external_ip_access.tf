module "vm_external_ip_access" {
  source  = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version = "5.3.0"

  policy_root      = "organization"
  policy_root_id   = var.organization_id
  constraint       = "compute.vmExternalIpAccess"
  policy_type      = "list"
  exclude_folders  = []
  exclude_projects = []

  rules = [
    {
      conditions  = []
      allow       = []
      deny        = []
      deny_all    = true
      enforcement = true
    },
  ]
}

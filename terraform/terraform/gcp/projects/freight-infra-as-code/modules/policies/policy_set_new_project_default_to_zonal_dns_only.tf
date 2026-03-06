module "set_new_project_default_to_zonal_dns_only" {
  source  = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version = "5.3.0"

  policy_root      = "organization"
  policy_root_id   = var.organization_id
  constraint       = "compute.setNewProjectDefaultToZonalDNSOnly"
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

module "cost_center" {
  source  = "GoogleCloudPlatform/tags/google"
  version = "0.1.0"

  tag_for         = "organization"
  org_id          = var.organization_id
  key             = "cost-center"
  key_description = "Used to tag all resources with their resepective cost centers"
  value_specs = [
    {
      value       = "cc14512"
      description = "tag for resources within cost center cc14512"
      tag_binding = {}
    },
  ]
}

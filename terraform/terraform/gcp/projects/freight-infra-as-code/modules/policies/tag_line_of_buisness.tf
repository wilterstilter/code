module "line_of_buisness" {
  source  = "GoogleCloudPlatform/tags/google"
  version = "0.1.0"

  tag_for         = "organization"
  org_id          = var.organization_id
  key             = "LOB"
  key_description = "Used to tag all resources with their respective line of buisness"
  value_specs = [
    {
      value       = "TMS"
      description = "tag for resources that fall under TMS"
      tag_binding = {}
    },
    {
      value       = "digital-brokerage"
      description = "tag for resources that fall under digital brokerage"
      tag_binding = {}
    },
    {
      value       = "mexico"
      description = "tag for resources that fall under mexico"
      tag_binding = {}
    },
    {
      value       = "intermodal"
      description = "tag for resources that fall under mexico"
      tag_binding = {}
    },
  ]
}

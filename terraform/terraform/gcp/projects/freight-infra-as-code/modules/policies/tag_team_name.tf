module "team_name" {
  source  = "GoogleCloudPlatform/tags/google"
  version = "0.1.0"

  tag_for         = "organization"
  org_id          = var.organization_id
  key             = "team"
  key_description = "Used to tag all resources with their resepective team names"
  value_specs = [
    {
      value       = "freight-data"
      description = "tag for resources managed by freight-data team"
      tag_binding = {}
    },
    {
      value       = "fintech"
      description = "tag for resources managed by fintech team"
      tag_binding = {}
    },
    {
      value       = "data-science"
      description = "tag for resources managed by data-science team"
      tag_binding = {}
    },
  ]
}

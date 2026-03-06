module "environment_values" {
  source  = "GoogleCloudPlatform/tags/google"
  version = "0.1.0"

  tag_for         = "organization"
  org_id          = var.organization_id
  key             = "environment"
  key_description = "Used to tag all resources with their resepective environment names"
  value_specs = [
    {
      value       = "dev"
      description = "tag for resources within dev environment"
      tag_binding = {}
    },
    {
      value       = "nonprod"
      description = "tag for resources within nonprod environment"
      tag_binding = {}
    },
    {
      value       = "prod"
      description = "tag for resources within prod environment"
      tag_binding = {}
    },
  ]
}

module "public_access_bucket" {
  source  = "GoogleCloudPlatform/tags/google"
  version = "0.1.0"

  tag_for         = "organization"
  org_id          = var.organization_id
  key             = "publicAccessBucket"
  key_description = "Used to tag buckets that should be allowed public access"
  value_specs = [
    {
      value       = "allowed"
      description = "we only allow one value because tag presence means allow"
      tag_binding = {
        "global" : []
      }
    },
  ]
}

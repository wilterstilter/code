module "public_access_prevention" {
  source  = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version = "5.3.0"

  policy_root      = "organization"
  policy_root_id   = var.organization_id
  constraint       = "storage.publicAccessPrevention"
  policy_type      = "boolean"
  exclude_folders  = []
  exclude_projects = []

  rules = [
    {
      conditions = [{
        title       = "Public access for tagged buckets"
        description = "Buckets with this pecific tag will be allowed public access"
        expression  = "resource.matchTag('${var.organization_id}/publicAccessBucket', 'allowed')"
        location    = ""
      }]
      allow       = []
      deny        = []
      enforcement = false
    },
    {
      conditions  = []
      allow       = []
      deny        = []
      enforcement = true
    },
  ]
}

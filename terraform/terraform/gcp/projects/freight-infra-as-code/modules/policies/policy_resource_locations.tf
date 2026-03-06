module "resource_locations" {
  source  = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version = "5.3.0"

  policy_root      = "organization"
  policy_root_id   = var.organization_id
  constraint       = "gcp.resourceLocations"
  policy_type      = "list"
  exclude_folders  = []
  exclude_projects = []

  rules = [
    {
      conditions = [{
        title       = "Multi-region US"
        description = "Projects that need multi-region resources in US"
        expression  = "resource.matchTag('${var.organization_id}/resourceLocations', 'us-locations')"
        location    = ""
      }]
      allow = [
        "global",
        "in:us-locations",
        "in:asia-south1-locations",
      ]
      deny        = []
      enforcement = null
    },
    {
      conditions = []
      allow = [
        "global",
        # Temporarely allow US location because the previous restrictions blocked creation of resources such as US buckets.
        "in:us-locations",
        "in:us-south1-locations",
        "in:us-east4-locations",
        "in:us-west8-locations",
        "in:asia-south1-locations",
      ]
      deny        = []
      enforcement = null
    },
  ]
}

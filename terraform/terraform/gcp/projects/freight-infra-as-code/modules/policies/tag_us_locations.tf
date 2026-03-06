module "tag_resource_us_locations" {
  source  = "GoogleCloudPlatform/tags/google"
  version = "0.1.0"

  tag_for         = "organization"
  org_id          = var.organization_id
  key             = "resourceLocations"
  key_description = "Used to tag projects that need multi-region resources"
  value_specs = [
    {
      value       = "us-locations"
      description = "US locations for multi-region resources"
      tag_binding = {
        "global" : []
      }
    },
  ]
}

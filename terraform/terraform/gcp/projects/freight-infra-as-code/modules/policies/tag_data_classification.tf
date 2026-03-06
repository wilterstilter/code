module "data_classification" {
  source  = "GoogleCloudPlatform/tags/google"
  version = "0.1.0"

  tag_for         = "organization"
  org_id          = var.organization_id
  key             = "data-classification"
  key_description = "Used to tag all data related resources as PII or nonPII"
  value_specs = [
    {
      value       = "PII"
      description = "tag for resources that contains PII data"
      tag_binding = {}
    },
    {
      value       = "Non-PII"
      description = "tag for resources that contains Non-PII data"
      tag_binding = {}
    },
  ]
}

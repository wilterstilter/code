module "service_account_key_creation" {
  source  = "GoogleCloudPlatform/tags/google"
  version = "0.1.0"

  tag_for         = "organization"
  org_id          = var.organization_id
  key             = "serviceAccountKeyCreation"
  key_description = "There are cases when we want to allow key creation so we will allow it when tagged"
  value_specs = [
    {
      value       = "allowed"
      description = "Allow creating keys for tagged accounts"
      tag_binding = {
        "global" : []
      }
    },
  ]
}

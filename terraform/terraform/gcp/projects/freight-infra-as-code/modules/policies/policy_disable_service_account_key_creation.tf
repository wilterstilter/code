module "disable_service_account_key_creation" {
  source  = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version = "5.3.0"

  policy_root      = "organization"
  policy_root_id   = var.organization_id
  constraint       = "iam.disableServiceAccountKeyCreation"
  policy_type      = "boolean"
  exclude_folders  = []
  exclude_projects = []

  rules = [
    {
      conditions = [{
        title       = "Allow creating keys for tagged accounts"
        description = "There are cases when we want to allow key creation so we will allow it when tagged"
        expression  = "resource.matchTag('${var.organization_id}/serviceAccountKeyCreation', 'allowed')"
        location    = ""
      }]
      allow       = []
      deny        = []
      allow_all   = true
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

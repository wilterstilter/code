module "allowed_policy_member_domains" {
  source  = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
  version = "5.3.0"

  policy_root      = "organization"
  policy_root_id   = var.organization_id
  constraint       = "iam.allowedPolicyMemberDomains"
  policy_type      = "list"
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
      allow_all   = true
      enforcement = false
    },
    {
      conditions = []
      allow = [
        "C03e3rd1g", # Uber Freight DIRECTORY_CUSTOMER_ID
        "C040ao83r", # Uber DIRECTORY_CUSTOMER_ID
        "C0147pk0i", # Datadog’s customer identity (https://docs.datadoghq.com/integrations/google_cloud_platform/?tab=project#prerequisites)
      ]
      deny        = []
      enforcement = null
    },
  ]
}

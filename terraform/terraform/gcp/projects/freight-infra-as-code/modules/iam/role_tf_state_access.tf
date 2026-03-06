resource "google_project_iam_custom_role" "state_force_unlock" {
  project     = "freight-infra-as-code"
  role_id     = "terraformStateForceUnlock"
  title       = "Terraform State Force Unlock"
  description = "Temporary access to force unlock terraform state"
  permissions = [
    "storage.objects.get",
    "storage.objects.list",
    "storage.objects.update",
    "storage.objects.delete",
    "storage.buckets.get"
  ]
}

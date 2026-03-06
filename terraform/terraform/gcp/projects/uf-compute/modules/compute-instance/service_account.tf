# modules/compute-instance/service_account.tf

# Create user-managed service account if requested
resource "google_service_account" "vm_service_account" {
  # Only create if create_service_account is true and account_id is provided
  count = var.create_service_account && var.service_account_config != null ? 1 : 0

  account_id   = var.service_account_config.account_id
  display_name = var.service_account_config.display_name
  description  = var.service_account_config.description
  project      = var.project_id
}

# Grant project-level IAM roles to the user-managed service account
resource "google_project_iam_member" "service_account_roles" {
  for_each = var.create_service_account && var.service_account_config != null ? toset(var.service_account_config.project_roles) : []

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.vm_service_account[0].email}"
}
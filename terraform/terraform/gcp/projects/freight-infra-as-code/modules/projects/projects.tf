# Uber Freight GCP project creation

module "projects" {
  source = "github.com/robertdolca/terraform-google-project-factory?ref=workstations"

  for_each = {
    for item in local.projects_final :
    item.id => item
  }

  // Project
  name            = each.value.name
  project_id      = each.value.id
  org_id          = each.value.org_id
  folder_id       = var.environment_folders[each.value.folder_key]
  billing_account = each.value.billing_account
  language_tag    = "en-US"

  // Service Account
  create_project_sa = true

  // Networking configurations
  grant_network_role   = each.value.grant_network_role
  svpc_host_project_id = each.value.svpc_host_project_id
  shared_vpc_subnets   = each.value.shared_vpc_subnets

  // Prevent accidental deletion
  lien = false

  // Bucket Creation
  bucket_project       = var.iac_project_id # buckets are created on the base project
  bucket_name          = each.value.bucket_name
  bucket_location      = "US"
  bucket_ula           = true
  bucket_versioning    = true
  bucket_force_destroy = true
  bucket_pap           = "enforced"
  bucket_labels        = each.value.bucket_labels

  // Budget Specific configs
  budget_calendar_period      = "MONTH"
  budget_display_name         = "Project ${each.value.id}"
  budget_amount               = each.value.monthly_budget == 0 ? 0 : each.value.monthly_budget
  budget_alert_spent_percents = [0.95, 1.0, 1.2, 1.5, 2.0, 3.0, 4.0, 5.0, 8.0, 10.0]

  // Global labels
  labels = each.value.labels

  # GCP APIs
  activate_apis = distinct(
    flatten(
      [each.value.activate_apis, [
        "compute.googleapis.com",
        "cloudasset.googleapis.com",
        "networkmanagement.googleapis.com",
        "serviceusage.googleapis.com",
        "cloudaicompanion.googleapis.com",
        "privilegedaccessmanager.googleapis.com",
    ]])
  )
}

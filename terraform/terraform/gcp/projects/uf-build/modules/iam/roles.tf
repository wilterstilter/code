
module "role_developer" {
  source  = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version = "~> 7.7.1"

  target_level = "project"
  target_id    = var.project_id
  role_id      = "developer"
  title        = "Developer"
  description  = "Roles that is assigned to developers"
  permissions = [
    "artifactregistry.repositories.list",
  ]
}

module "role_global_secret_viewer" {
  source  = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version = "~> 7.7.1"

  target_level = "org"
  target_id    = var.organization_id
  role_id      = "globalSecretViewer"
  title        = "Global Secret Viewer"
  description  = "Allows read only access to secrets"
  permissions = [
    "secretmanager.versions.access"
  ]
}

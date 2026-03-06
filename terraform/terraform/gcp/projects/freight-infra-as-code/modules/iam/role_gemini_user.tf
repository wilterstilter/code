module "role_gemini_user" {
  source  = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version = "~> 7.7.1"

  target_level = "org"
  target_id    = var.organization_id
  role_id      = "geminiUser"
  title        = "Gemini User"
  description  = "All of the users who have been granted this role can access Gemini features in the Google Cloud console within the specified project and Gemini Code Assist."
  permissions = [
    "cloudaicompanion.companions.generateChat",
    "cloudaicompanion.companions.generateCode",
    "serviceusage.services.get",
  ]
}

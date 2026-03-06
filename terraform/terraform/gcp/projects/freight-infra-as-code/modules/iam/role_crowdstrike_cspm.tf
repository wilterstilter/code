module "role_crowdstrike_cspm" {
  source  = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version = "~> 7.7.1"

  target_level = "org"
  target_id    = var.organization_id
  role_id      = "crowdstrike_cspm_role"
  title        = "CrowdStrike CSPM Custom Role"
  description  = "Custom role for CrowdStrike CSPM integration with required and optional permissions"
  permissions = [
    # Browser Role (Required)
    "resourcemanager.projects.get",
    "resourcemanager.folders.get",

    # Cloud Asset Viewer (Required)
    "cloudasset.assets.exportResource",
    "cloudasset.assets.listResource",
    "cloudasset.assets.searchAllIamPolicies",
    "cloudasset.assets.searchAllResources",
    "cloudasset.assets.exportIamPolicy",

    # App Engine Viewer (Optional)
    "appengine.versions.get",

    # Firebase App Check Viewer (Optional)
    "firebase.clients.list",
    "firebase.projects.get",
    "firebaseappcheck.services.get",

    # Firebase Authentication Viewer (Optional)
    "firebaseauth.configs.get",

    # Firebase Realtime Database Viewer (Optional)
    "firebasedatabase.instances.list",

    # Cloud Functions Developer (Optional)
    "cloudfunctions.functions.sourceCodeGet"
  ]
}
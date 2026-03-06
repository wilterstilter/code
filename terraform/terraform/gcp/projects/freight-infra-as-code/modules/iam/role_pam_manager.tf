module "role_pam_manager" {
  source  = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version = "~> 7.7.1"

  target_level = "org"
  target_id    = var.organization_id
  role_id      = "pamManager"
  title        = "PAM Manager"
  description  = "Allows access to setup PAM components"
  permissions = [
    "resourcemanager.projects.get",
    "resourcemanager.projects.setIamPolicy",
    "resourcemanager.projects.getIamPolicy",
    "resourcemanager.organizations.get",
    "resourcemanager.organizations.getIamPolicy",
    "resourcemanager.organizations.setIamPolicy",
    "resourcemanager.projects.get",
    "resourcemanager.folders.delete",
    "resourcemanager.folders.get",
    "resourcemanager.folders.getIamPolicy",
    "resourcemanager.folders.list",
    "resourcemanager.folders.createPolicyBinding",
    "resourcemanager.folders.deletePolicyBinding",
    "resourcemanager.folders.searchPolicyBindings",
    "resourcemanager.folders.setIamPolicy",
    "resourcemanager.folders.updatePolicyBinding",
    "privilegedaccessmanager.entitlements.create",
    "privilegedaccessmanager.entitlements.delete",
    "privilegedaccessmanager.entitlements.get",
    "privilegedaccessmanager.entitlements.list",
    "privilegedaccessmanager.entitlements.setIamPolicy",
    "privilegedaccessmanager.entitlements.update",
    "privilegedaccessmanager.grants.get",
    "privilegedaccessmanager.grants.list",
    "privilegedaccessmanager.grants.revoke",
    "privilegedaccessmanager.locations.checkOnboardingStatus",
    "privilegedaccessmanager.locations.get",
    "privilegedaccessmanager.locations.list",
    "privilegedaccessmanager.operations.delete",
    "privilegedaccessmanager.operations.get",
    "privilegedaccessmanager.operations.list"
  ]
}

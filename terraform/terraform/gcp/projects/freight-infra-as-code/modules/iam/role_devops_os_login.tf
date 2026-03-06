module "role_devops_os_login" {
  source  = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version = "~> 7.7.1"

  target_level = "org"
  target_id    = var.organization_id
  role_id      = "devopsOsLogin"
  title        = "Devops OS Login"
  description  = "Allows log into any VM for emergency situations"
  permissions = [
    "iam.serviceAccounts.actAs",
    "compute.instances.osLogin",
    "compute.instances.osAdminLogin",
    "iap.tunnelDestGroups.accessViaIAP",
    "iap.tunnelInstances.accessViaIAP",
  ]
}

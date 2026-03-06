module "role_compute_admin" {
  source       = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version      = "~> 7.7"
  target_level = "project"
  target_id    = var.project_id
  role_id      = "computeAdmin"
  title        = "Compute Admin"
  description  = "Role for managing compute instances and instance groups"
  permissions = [
    # Instance permissions
    "compute.instances.start",
    "compute.instances.stop",
    "compute.instances.reset",
    "compute.instances.get",
    "compute.instances.list",

    # Instance Group Management
    "compute.instanceGroups.get",
    "compute.instanceGroups.list",
    "compute.instanceGroups.update",

    # Instance Group Manager
    "compute.instanceGroupManagers.get",
    "compute.instanceGroupManagers.list",
    "compute.instanceGroupManagers.update",
  ]
}

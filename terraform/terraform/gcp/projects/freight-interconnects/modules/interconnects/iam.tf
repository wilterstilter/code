data "google_project" "current" {}

module "role_inerconnect_admin" {
  source  = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version = "~> 7.7.1"

  target_level = "project"
  target_id    = data.google_project.current.project_id
  role_id      = "networking.interconnectAdmin"
  title        = "Interconnect Admin"
  description  = "Custom for allowing Interconnects management through UI due to no terraform support."
  permissions = [
    "compute.interconnectAttachments.get",
    "compute.interconnectAttachments.list",
    "compute.interconnectLocations.get",
    "compute.interconnectLocations.list",
    "compute.interconnectRemoteLocations.get",
    "compute.interconnectRemoteLocations.list",
    "compute.interconnects.create",
    "compute.interconnects.delete",
    "compute.interconnects.get",
    "compute.interconnects.getMacsecConfig",
    "compute.interconnects.list",
    "compute.interconnects.setLabels",
    "compute.interconnects.update",
    "compute.interconnects.use",
  ]
}

module "projects_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 7.7"
  mode    = "authoritative"

  projects = [data.google_project.current.project_id]

  bindings = {
    "projects/${data.google_project.current.project_id}/roles/${module.role_inerconnect_admin.custom_role_id}" = [
      "group:sg-az-gcp-network-admins@uberfreight.com",
    ]
  }
  depends_on = [module.role_inerconnect_admin]
}

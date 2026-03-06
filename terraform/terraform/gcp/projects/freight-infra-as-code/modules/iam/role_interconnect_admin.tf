module "role_interconnect_admin" {
  source  = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version = "~> 7.7.1"

  target_level = "org"
  target_id    = var.organization_id
  role_id      = "interconnectAdmin"
  title        = "Interconnect Admin"
  description  = "Allows network engineers Interconnect Admin access to all Projects"
  permissions = [
    "compute.interconnects.create",
    "compute.interconnects.createTagBinding",
    "compute.interconnects.delete",
    "compute.interconnects.deleteTagBinding",
    "compute.interconnects.get",
    "compute.interconnects.getMacsecConfig",
    "compute.interconnects.list",
    "compute.interconnects.listEffectiveTags",
    "compute.interconnects.listTagBindings",
    "compute.interconnects.setLabels",
    "compute.interconnects.update",
    "compute.interconnects.use",
    "compute.interconnectAttachments.create",
    "compute.interconnectAttachments.createTagBinding",
    "compute.interconnectAttachments.delete",
    "compute.interconnectAttachments.deleteTagBinding",
    "compute.interconnectAttachments.get",
    "compute.interconnectAttachments.list",
    "compute.interconnectAttachments.listEffectiveTags",
    "compute.interconnectAttachments.listTagBindings",
    "compute.interconnectAttachments.setLabels",
    "compute.interconnectAttachments.update",
    "compute.interconnectAttachments.use",
    "compute.interconnectLocations.get",
    "compute.interconnectLocations.list",
    "compute.interconnectRemoteLocations.get",
    "compute.interconnectRemoteLocations.list",
  ]
}

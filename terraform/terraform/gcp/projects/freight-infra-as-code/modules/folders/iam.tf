locals {
  # developer_group = "group:sg-az-gcp-developers@uberfreight.com"

  folder_level_authorization = {}
}


module "cs_folders_iam_computeinstanceAdminv1" {

  for_each = local.folder_level_authorization

  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  version = "~> 7.4"

  folders  = [module.env_folders[each.key].id]
  bindings = each.value["bindings"]

  depends_on = [module.env_folders]
}

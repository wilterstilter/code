
# Creation initial layer of folders
# These should contain our environments
// Accessing it: module.env_folders["prod"]
module "env_folders" {

  for_each = var.environments

  source  = "terraform-google-modules/folders/google"
  version = "~> 4.0"

  parent = "organizations/${var.organization_id}"
  names  = [each.value]
}

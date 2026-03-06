# module "trusted_image_projects" {
#   source  = "terraform-google-modules/org-policy/google//modules/org_policy_v2"
#   version = "5.3.0"

#   policy_root      = "organization"
#   policy_root_id   = var.organization_id
#   constraint       = "compute.trustedImageProjects"
#   policy_type      = "list"
#   exclude_folders  = []
#   exclude_projects = []

#   rules = [
#     {
#       conditions  = []
#       allow       = ["projects/uf-build"]
#       deny        = []
#       enforcement = null
#     },
#   ]
# }

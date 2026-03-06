# Use this module to force terragrunt to delete your resources. Delete everything
# except the first `include` statement from your `terragrunt.hcl` and add the snippet
# below in your terragrunt file.
#
# terraform {
#     source = "${dirname(find_in_parent_folders())}/../common/terragrunt-delete"
# }

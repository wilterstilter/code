locals {
  custom_roles = {
    "custom.projects.update" = {
      roleId             = "custom.projects.update",
      title              = "Project Update Role",
      description        = "Custom role to get and update projects",
      stage              = "BETA",
      project_level_role = true, #specifies if the custom role needs to be applied on project level
      permissions = [
        "resourcemanager.projects.get",
        "resourcemanager.projects.update"
      ]
    }
  }

  members_by_role_map = {
    "default" = [
      "group:freight-data@uberfreight.com",
    ],
    "custom.projects.update" = [
      "group:freight-data@uberfreight.com",
      "group:sg-az-gcp-billing-admins@uberfreight.com"
    ]
  }
}

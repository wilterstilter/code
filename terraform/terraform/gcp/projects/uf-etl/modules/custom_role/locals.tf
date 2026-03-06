locals {
  custom_roles = {
    "custom.composer.daguser" = {
      roleId             = "custom.composer.daguser",
      title              = "Cloud composer Dags user",
      description        = "Custom role for engineers to view and run dags in Cloud Composer",
      stage              = "BETA",
      project_level_role = false,
      permissions = [
        "composer.dags.execute",
        "composer.dags.get",
        "composer.dags.getSourceCode",
        "composer.dags.list",
        "composer.environments.get",
        "composer.environments.list"
      ]
    }
  }

  members_by_role_map = {
    "default" = [
      "group:freight-data-vendor@uberfreight.com",
      "group:freight-data@uberfreight.com",
    ]
  }
}

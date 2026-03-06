locals {
  custom_roles = {
    "custom.namespace.editor" = {
      roleId             = "custom.namespace.editor",
      title              = "Namespace Data Editor",
      description        = "Custom role for engineers to edit Namespace(Big query dataset)",
      stage              = "BETA",
      project_level_role = false,
      permissions = [
        "bigquery.config.get",
        "bigquery.datasets.get",
        "bigquery.tables.create",
        "bigquery.tables.createIndex",
        "bigquery.tables.createSnapshot",
        "bigquery.tables.delete",
        "bigquery.tables.deleteIndex",
        "bigquery.tables.get",
        "bigquery.tables.getData",
        "bigquery.tables.list",
        "bigquery.tables.replicateData",
        "bigquery.tables.restoreSnapshot",
        "bigquery.tables.update",
        "bigquery.tables.updateData"
      ]
    },
    "custom.notebooks.editor" = {
      roleId             = "custom.notebooks.editor",
      title              = "Colabs notebooks editor",
      description        = "Custom role for users to create, edit and run colab notebooks",
      stage              = "BETA",
      project_level_role = false,
      permissions = ["bigquery.config.get",
        "bigquery.jobs.create",
        "bigquery.readsessions.create",
        "bigquery.readsessions.getData",
        "bigquery.readsessions.update",
        "resourcemanager.projects.get",
        "dataform.locations.get",
        "dataform.locations.list",
        "dataform.repositories.create",
        "dataform.repositories.list",
        "dataform.collections.create",
        "dataform.collections.list",
        "aiplatform.notebookRuntimeTemplates.apply",
        "aiplatform.notebookRuntimeTemplates.get",
        "aiplatform.notebookRuntimeTemplates.list",
        "aiplatform.notebookRuntimeTemplates.getIamPolicy",
        "aiplatform.notebookRuntimes.assign",
        "aiplatform.notebookRuntimes.get",
        "aiplatform.notebookRuntimes.list",
        "aiplatform.operations.list"
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

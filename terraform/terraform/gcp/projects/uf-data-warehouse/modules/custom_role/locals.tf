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
    "custom.namespace.editor.serviceAccount" = {
      roleId             = "custom.namespace.editor.serviceAccount",
      title              = "Namespace Data Editor (Service account)",
      description        = "Custom role for service accounts to edit Namespace(Big query dataset)",
      stage              = "BETA",
      project_level_role = false,
      permissions = [
        "bigquery.config.get",
        "bigquery.datasets.get",
        "bigquery.jobs.update",
        "bigquery.tables.create",
        "bigquery.tables.createIndex",
        "bigquery.tables.delete",
        "bigquery.tables.deleteIndex",
        "bigquery.tables.get",
        "bigquery.tables.getData",
        "bigquery.tables.list",
        "bigquery.tables.update",
        "bigquery.tables.updateData"
      ]
    },
    "custom.namespace.viewer" = {
      roleId             = "custom.namespace.viewer",
      title              = "Namespace Data Viewer",
      description        = "Custom role to view Namespace(Big query dataset)",
      stage              = "BETA",
      project_level_role = false,
      permissions = [
        "bigquery.config.get",
        "bigquery.datasets.get",
        "bigquery.tables.get",
        "bigquery.tables.getData",
        "bigquery.tables.list"
      ]
    },
    "custom.devopsOsLogin" = {
      roleId             = "custom.devopsOsLogin",
      title              = "Devops OS Login",
      description        = "Allows log into any VM for emergency situations",
      stage              = "BETA",
      project_level_role = true,
      permissions = [
        "compute.instances.osLogin",
        "compute.instances.osAdminLogin",
        "iam.serviceAccounts.actAs"
      ]
    },
    "custom.bqStudio.user" = {
      roleId             = "custom.bqStudio.user",
      title              = "BigQuery Studio UI user",
      description        = "Custom role to run queries in Bigquery Studio UI",
      stage              = "BETA",
      project_level_role = true, #specifies if the custom role needs to be applied on project level
      permissions = [
        "bigquery.jobs.create"
      ]
    },
    "custom.gcs.storageBucketViewer" = {
      roleId             = "custom.gcs.storageBucketViewer",
      title              = "GCS Storage Bucket Viewer",
      description        = "Custom role to grant permissions to list and get Cloud Storage buckets.",
      stage              = "BETA",
      project_level_role = true, #specifies if the custom role needs to be applied on project level
      permissions = [
        "storage.buckets.get",
        "storage.buckets.list",
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

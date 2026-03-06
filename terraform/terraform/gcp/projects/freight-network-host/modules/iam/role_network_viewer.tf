
module "role_network_viewer" {
  source  = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version = "~> 7.7.1"

  target_level = "project"
  target_id    = data.google_project.current.project_id
  role_id      = "networking.viewer"
  title        = "Interconnect Viewer"
  description  = "Custom for allowing network inspection."
  permissions = [
    "logging.buckets.copyLogEntries",
    "logging.buckets.get",
    "logging.buckets.list",
    "logging.exclusions.get",
    "logging.exclusions.list",
    "logging.fields.access",
    "logging.links.get",
    "logging.links.list",
    "logging.locations.get",
    "logging.locations.list",
    "logging.logEntries.download",
    "logging.logEntries.list",
    "logging.logMetrics.get",
    "logging.logMetrics.list",
    "logging.logs.list",
    "logging.logServiceIndexes.list",
    "logging.logServices.list",
    "logging.notificationRules.get",
    "logging.notificationRules.list",
    "logging.operations.get",
    "logging.operations.list",
    "logging.privateLogEntries.list",
    "logging.queries.create",
    "logging.queries.delete",
    "logging.queries.get",
    "logging.queries.list",
    "logging.queries.listShared",
    "logging.queries.update",
    "logging.sinks.get",
    "logging.sinks.list",
    "logging.usage.get",
    "logging.views.access",
    "logging.views.get",
    "logging.views.list",
    "logging.views.listLogs",
    "logging.views.listResourceKeys",
    "logging.views.listResourceValues",
  ]
}

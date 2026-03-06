output "project_details" {
  value = [
    for item in local.projects_final : {
      id   = item.id
      team = item.labels.team
    }
  ]
  description = "List of project details including project IDs and associated team names."
}

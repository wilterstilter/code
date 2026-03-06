output "custom_role_name" {
  description = "The Custom role name and its full name property"
  value = {
    for role_id in var.custom_roles : role_id => google_project_iam_custom_role.custom_roles[role_id].name
  }
}

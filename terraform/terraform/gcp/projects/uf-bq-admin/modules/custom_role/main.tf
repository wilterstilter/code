resource "google_project_iam_custom_role" "custom_roles" {
  for_each = {
    for role_id in var.custom_roles : role_id => local.custom_roles[role_id]
  }

  role_id     = each.value.roleId
  title       = each.value.title
  description = each.value.description
  stage       = each.value.stage
  permissions = each.value.permissions
}

resource "google_project_iam_binding" "custom_role" {
  for_each = {
    for role_id in var.custom_roles : role_id => local.custom_roles[role_id]
    if local.custom_roles[role_id].project_level_role == true
  }
  project = var.project_id
  role    = "projects/${var.project_id}/roles/${each.value.roleId}"

  members = concat(
    local.members_by_role_map.default,                       #by default we will have freight-data and freight-data-vendors on all custom roles
    lookup(local.members_by_role_map, each.value.roleId, []) #add additional members to the custom roles if there are any else default to []
  )
  depends_on = [google_project_iam_custom_role.custom_roles]
}

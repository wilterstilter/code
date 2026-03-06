module "project_pams" {
  source   = "../pam"
  for_each = { for entitlement in flatten([for project in local.projects_final : project.entitlements]) : "${entitlement.project_id}_${entitlement.entitlement_id}" => entitlement }

  entitlement_id       = each.value.entitlement_id
  max_request_duration = "1800s"
  parent_id            = each.value.project_id
  parent_type          = "project"

  eligible_requesters = [
    "group:${local.teams[each.value.team].email}"
  ]

  approvers = [
    can(regex("emergency", each.value.entitlement_id)) ? "group:sg-az-gcp-devops@uberfreight.com" : "group:${local.teams[each.value.team].email}"
  ]

  role_bindings = each.value.role_bindings
}

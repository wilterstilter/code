module "projects_iam_bindings" {
  for_each = var.project_iam_bindings
  source   = "terraform-google-modules/iam/google//modules/projects_iam"
  version  = "~> 7.7"
  mode     = "authoritative"
  projects = [
    var.project_id
  ]
  bindings = {
    (each.key) = each.value.entities
  }
}

module "service_account_iam_binding" {
  for_each         = var.service_account_iam_bindings
  source           = "terraform-google-modules/iam/google//modules/service_accounts_iam"
  version          = "~> 8.0"
  service_accounts = [var.looker_service_account]
  project          = var.looker_sa_project_id
  mode             = "additive"
  bindings = {
    (each.key) = each.value.entities
  }
}
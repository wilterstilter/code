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
  for_each = var.service_account_iam_bindings
  source   = "terraform-google-modules/iam/google//modules/service_accounts_iam"
  version  = "~> 8.0"
  service_accounts = [
    var.etl_service_account,
    "etl-sa-enterprise-analysts-${substr(var.project_id, -1, 1)}@${var.project_id}.iam.gserviceaccount.com",
    "etl-sa-freight-data-science-${substr(var.project_id, -1, 1)}@${var.project_id}.iam.gserviceaccount.com",
    "etl-sa-logistics-engineering-${substr(var.project_id, -1, 1)}@${var.project_id}.iam.gserviceaccount.com",
    "etl-sa-mx-${substr(var.project_id, -1, 1)}@${var.project_id}.iam.gserviceaccount.com",
  ]
  project = var.etl_sa_project_id
  mode    = "additive"
  bindings = {
    (each.key) = each.value.entities
  }
}
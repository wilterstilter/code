module "projects_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 7.7"
  mode    = "authoritative"

  projects = [
    var.project_id
  ]

  bindings = {
    "roles/aiplatform.user" = [
      "group:${local.freight_mle_group}",
    ]
    "roles/aiplatform.colabEnterpriseUser" = [
      "group:${local.freight_mle_group}",
    ]
  }
}

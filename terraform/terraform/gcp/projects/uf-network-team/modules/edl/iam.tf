module "projects_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 7.7"
  mode    = "authoritative"

  projects = [data.google_project.current.project_id]

  bindings = {
    "roles/viewer" = [
      "group:sg-az-gcp-network-admins@uberfreight.com",
    ]
  }
}

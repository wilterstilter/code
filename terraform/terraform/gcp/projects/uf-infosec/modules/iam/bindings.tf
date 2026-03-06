module "project_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 7.7"

  projects = [var.project_id]
  mode     = "additive"

  bindings = {
    "roles/viewer" = [
      "group:sg-az-gcp-security-admins@uberfreight.com"
    ]
    "roles/secretmanager.viewer" = [
      "group:sg-az-gcp-security-admins@uberfreight.com"
    ]
    "roles/browser" = [
      "group:sg-az-gcp-security-admins@uberfreight.com"
    ]
    "roles/secretmanager.secretAccessor" = [
      "group:sg-az-gcp-security-admins@uberfreight.com"
    ]

  }
}

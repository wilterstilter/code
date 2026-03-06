module "projects_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 7.7"
  mode    = "authoritative"

  projects = [data.google_project.current.project_id]

  bindings = {
    "projects/${data.google_project.current.project_id}/roles/${module.role_network_viewer.custom_role_id}" = [
      "group:sg-az-gcp-network-admins@uberfreight.com",
    ]
  }
  depends_on = [module.role_network_viewer]
}

resource "google_project_iam_binding" "shared_vpc_agent" {
  project = data.google_project.current.project_id
  role    = "roles/composer.sharedVpcAgent"
  members = [
    "serviceAccount:cloud-composer-sa@uf-data-warehouse-p.iam.gserviceaccount.com",
  ]
}

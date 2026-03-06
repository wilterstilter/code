module "projects_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 7.7"
  mode    = "authoritative"

  projects = [var.project_id]

  bindings = {
    "projects/${var.project_id}/roles/${module.role_developer.custom_role_id}" = [
      local.all_engineers,
    ]
    "projects/${var.project_id}/roles/${module.role_compute_admin.custom_role_id}" = [
      "group:sg-az-gcp-devops@uberfreight.com"
    ]
  }
}

module "storage_bucket_iam_bindings_workstation_artifacts" {
  source  = "terraform-google-modules/iam/google//modules/storage_buckets_iam"
  version = "~> 7.7"

  storage_buckets = ["uf-cloud-workstation-artifacts"]
  mode            = "authoritative"

  bindings = {
    "projects/${var.project_id}/roles/${module.role_storage_artifact_admin.custom_role_id}" = [
      "group:sg-az-gcp-devops@uberfreight.com",
    ]
    "projects/${var.project_id}/roles/${module.role_storage_artifact_reader.custom_role_id}" = [
      "serviceAccount:ghr-us-south1-monorepo@uf-build-p.iam.gserviceaccount.com",
    ]
  }
}

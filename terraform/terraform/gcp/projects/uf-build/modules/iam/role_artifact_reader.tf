module "role_storage_artifact_reader" {
  source  = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version = "~> 7.7.1"

  target_level = "project"
  target_id    = var.project_id
  role_id      = "storageArtifactReader"
  title        = "Storage artifact reader"
  description  = "User retrieve artifacts from google cloud storage"
  permissions = [
    "storage.buckets.get",
    "storage.objects.get",
    "storage.objects.list",
  ]
}

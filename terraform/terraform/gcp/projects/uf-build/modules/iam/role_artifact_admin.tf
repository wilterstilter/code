module "role_storage_artifact_admin" {
  source  = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version = "~> 7.7.1"

  target_level = "project"
  target_id    = var.project_id
  role_id      = "storageArtifactAdmin"
  title        = "Storage artifact administrator"
  description  = "User used to manually upload and manage artifacts within google cloud storage"
  permissions = [
    "storage.buckets.get",
    "storage.objects.create",
    "storage.objects.delete",
    "storage.objects.get",
    "storage.objects.getIamPolicy",
    "storage.objects.list",
  ]
}

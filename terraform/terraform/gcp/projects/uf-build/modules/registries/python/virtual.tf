resource "google_artifact_registry_repository" "all" {
  depends_on    = []
  location      = "us"
  repository_id = "python-all"
  description   = "Virtual repository to merge all python repositories"
  format        = "Python"
  mode          = "VIRTUAL_REPOSITORY"

  virtual_repository_config {
    upstream_policies {
      id         = google_artifact_registry_repository.internal.name
      repository = google_artifact_registry_repository.internal.id
      priority   = 10
    }
  }
}

# Read access is given all to uberfreight users
resource "google_artifact_registry_repository_iam_binding" "all_viewer" {
  project    = google_artifact_registry_repository.all.project
  location   = google_artifact_registry_repository.all.location
  repository = google_artifact_registry_repository.all.name
  role       = "roles/artifactregistry.reader"
  members = [
    local.all_users,
  ]
}

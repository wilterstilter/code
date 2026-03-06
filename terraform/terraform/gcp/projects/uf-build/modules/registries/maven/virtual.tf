resource "google_artifact_registry_repository" "all" {
  depends_on    = []
  location      = "us"
  repository_id = "maven-all"
  description   = "Virtual repository to merge all maven repositories"
  format        = "Maven"
  mode          = "VIRTUAL_REPOSITORY"
  virtual_repository_config {
    dynamic "upstream_policies" {
      for_each = local.internal_repos
      content {
        id         = google_artifact_registry_repository.internal[upstream_policies.key].name
        repository = google_artifact_registry_repository.internal[upstream_policies.key].id
        priority   = upstream_policies.value.priority
      }
    }

    upstream_policies {
      id         = google_artifact_registry_repository.central.name
      repository = google_artifact_registry_repository.central.id
      priority   = 20
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

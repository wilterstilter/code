resource "google_artifact_registry_repository" "all" {
  depends_on    = []
  location      = "us"
  repository_id = "docker-all"
  description   = "Virtual repository to merge all docker repositories"
  format        = "DOCKER"
  mode          = "VIRTUAL_REPOSITORY"

  # Higher priority takes precedemce
  virtual_repository_config {
    upstream_policies {
      id         = google_artifact_registry_repository.internal.name
      repository = google_artifact_registry_repository.internal.id
      priority   = 100
    }
    upstream_policies {
      id         = google_artifact_registry_repository.hub.name
      repository = google_artifact_registry_repository.hub.id
      priority   = 90
    }
    dynamic "upstream_policies" {
      for_each = local.remotes
      content {
        id         = google_artifact_registry_repository.remote[upstream_policies.key].name
        repository = google_artifact_registry_repository.remote[upstream_policies.key].id
        priority   = upstream_policies.value.priority
      }
    }
  }
}

# Read access is given all to uberfreight users
resource "google_artifact_registry_repository_iam_binding" "all_viewer" {
  project    = google_artifact_registry_repository.all.project
  location   = google_artifact_registry_repository.all.location
  repository = google_artifact_registry_repository.all.name
  role       = "roles/artifactregistry.reader"
  members = concat(
    [
      local.all_users,
    ],
    [
      for sa in var.service_account_readers : "serviceAccount:${sa}"
    ]
  )
}

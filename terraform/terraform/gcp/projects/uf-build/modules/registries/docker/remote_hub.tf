resource "google_artifact_registry_repository" "hub" {
  repository_id = "docker-remote-hub"
  location      = "us"
  description   = "Docker hub remote repository"
  format        = "DOCKER"
  mode          = "REMOTE_REPOSITORY"
  remote_repository_config {
    description = "docker hub"
    docker_repository {
      public_repository = "DOCKER_HUB"
    }
  }
}

# Read access is given all to uberfreight users
resource "google_artifact_registry_repository_iam_binding" "hub_viewer" {
  project    = google_artifact_registry_repository.hub.project
  location   = google_artifact_registry_repository.hub.location
  repository = google_artifact_registry_repository.hub.name
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

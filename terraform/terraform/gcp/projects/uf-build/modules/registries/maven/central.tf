resource "google_artifact_registry_repository" "central" {
  location      = "us"
  repository_id = "maven-central"
  description   = "Proxy repository"
  format        = "MAVEN"
  mode          = "REMOTE_REPOSITORY"
  remote_repository_config {
    maven_repository {
      public_repository = "MAVEN_CENTRAL"
    }
  }
}

# Read access is given all to uberfreight users
resource "google_artifact_registry_repository_iam_binding" "central_viewer" {
  project    = google_artifact_registry_repository.central.project
  location   = google_artifact_registry_repository.central.location
  repository = google_artifact_registry_repository.central.name
  role       = "roles/artifactregistry.reader"
  members = [
    local.all_users,
  ]
}

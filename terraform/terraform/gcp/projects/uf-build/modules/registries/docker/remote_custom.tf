locals {
  remotes = {
    gcr = {
      url      = "https://gcr.io",
      priority = 20,
    }
    ghcr = {
      url      = "https://ghcr.io"
      priority = 10,
    }
  }
}

resource "google_artifact_registry_repository" "remote" {
  for_each = local.remotes

  repository_id = "docker-remote-${each.key}"
  location      = "us"
  description   = "Docker hub remote repository for ${each.value.url}"
  format        = "DOCKER"
  mode          = "REMOTE_REPOSITORY"
  remote_repository_config {
    docker_repository {
      custom_repository {
        uri = each.value.url
      }
    }
  }
}

# Read access is given all to uberfreight users
resource "google_artifact_registry_repository_iam_binding" "remote_viewer" {
  for_each = local.remotes

  project    = google_artifact_registry_repository.remote[each.key].project
  location   = google_artifact_registry_repository.remote[each.key].location
  repository = google_artifact_registry_repository.remote[each.key].name
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

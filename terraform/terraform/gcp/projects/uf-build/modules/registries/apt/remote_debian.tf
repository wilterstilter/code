locals {
  debian_repos = {
    "bookworm"         = "debian/dists/bookworm",
    "bookworm-updates" = "debian/dists/bookworm-updates"
  }
}

resource "google_artifact_registry_repository" "remote_debian" {
  for_each = local.debian_repos

  project       = var.project_id
  location      = "us"
  repository_id = "apt-remote-debian-${each.key}"
  description   = "Uber Freight remote Apt registry for Debian ${each.key}"
  format        = "APT"
  mode          = "REMOTE_REPOSITORY"

  cleanup_policy_dry_run = false

  remote_repository_config {
    apt_repository {
      public_repository {
        repository_base = "DEBIAN"
        repository_path = each.value
      }
    }
  }
}

# Read access is given all to uberfreight users
resource "google_artifact_registry_repository_iam_binding" "remote_debian_viewer" {
  for_each = local.debian_repos

  project    = google_artifact_registry_repository.remote_debian[each.key].project
  location   = google_artifact_registry_repository.remote_debian[each.key].location
  repository = google_artifact_registry_repository.remote_debian[each.key].name
  role       = "roles/artifactregistry.reader"
  members = [
    local.all_users,
  ]
}

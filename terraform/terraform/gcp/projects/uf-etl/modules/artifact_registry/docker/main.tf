resource "google_artifact_registry_repository" "create_repositories" {
  for_each = var.repositories

  project       = var.project_id
  location      = var.location
  repository_id = each.key
  description   = lookup(each.value, "description", "Docker repository for ${each.key}")
  format        = "DOCKER"

  docker_config {
    immutable_tags = lookup(each.value, "immutable_tags", false)
  }

  cleanup_policies {
    id     = "keep-recent-versions"
    action = "KEEP"
    most_recent_versions {
      keep_count = lookup(each.value, "keep_count", 10)
    }
  }
}

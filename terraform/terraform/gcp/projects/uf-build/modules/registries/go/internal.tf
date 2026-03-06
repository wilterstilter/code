// Artifact Repository for Docker images to be used by Cloud Run/GKE/GCE
resource "google_artifact_registry_repository" "internal" {
  project       = var.project_id
  location      = "us"
  repository_id = "go-internal"
  description   = "Uber Freight internal Go registry"
  format        = "Go"

  cleanup_policy_dry_run = false

  // Clean up pre releases with prefix alpha that older than 30 days (2592000s)
  cleanup_policies {
    id     = "delete-prerelease"
    action = "DELETE"
    condition {
      tag_state    = "TAGGED"
      tag_prefixes = ["alpha"]
      older_than   = "2592000s"
    }
  }

  // Keep all tag releases with release or vX.XX prefix
  cleanup_policies {
    id     = "keep-tagged-release"
    action = "KEEP"
    condition {
      tag_state    = "TAGGED"
      tag_prefixes = ["release", "v", "latest"]
    }
  }

  // Keep all with a package name prefix webapp/mobile/sandbox
  // for at least the 20 last
  cleanup_policies {
    id     = "keep-minimum-versions"
    action = "KEEP"
    most_recent_versions {
      package_name_prefixes = ["webapp", "mobile", "sandbox"]
      keep_count            = 20
    }
  }

  // Global cleanup policy (deletes) any images that are older than 365 days
  // (31536000 seconds) and do not fall into another clean up keep policy
  // https://cloud.google.com/artifact-registry/docs/repositories/cleanup-policy
  // "Keep policies work with delete policies to keep artifacts that would be deleted according
  // to the specifications of your delete policy, but that you want to keep. When an artifact
  // matches the criteria for both a delete policy and a keep policy, the artifact is kept."
  cleanup_policies {
    id     = "delete-global"
    action = "DELETE"
    condition {
      tag_state  = "ANY"
      older_than = "31536000s"
    }
  }
}

# Read access is given all to uberfreight users
resource "google_artifact_registry_repository_iam_binding" "internal_viewer" {
  project    = google_artifact_registry_repository.internal.project
  location   = google_artifact_registry_repository.internal.location
  repository = google_artifact_registry_repository.internal.name
  role       = "roles/artifactregistry.reader"
  members = [
    local.all_users,
  ]
}

# Read/Write access is given to all engineers (under Val)
resource "google_artifact_registry_repository_iam_binding" "internal_editor" {
  project    = google_artifact_registry_repository.internal.project
  location   = google_artifact_registry_repository.internal.location
  repository = google_artifact_registry_repository.internal.name
  role       = "roles/artifactregistry.writer"
  members = [
    local.all_engineers,
  ]
}

# This allows for read/write and delete artifacts, but not the registry
# as management of the registry should be done via
# infra-as-code not (roles/artifactregistry.admin) the UI
resource "google_artifact_registry_repository_iam_binding" "internal_admin" {
  project    = google_artifact_registry_repository.internal.project
  location   = google_artifact_registry_repository.internal.location
  repository = google_artifact_registry_repository.internal.name
  role       = "roles/artifactregistry.repoAdmin"
  members = [
    local.all_devops,
  ]
}

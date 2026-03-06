locals {
  internal_repos = {
    "internal-release" = {
      priority                  = 20
      version_policy            = "RELEASE"
      allow_snapshot_overwrites = false
    },
    "internal-snapshots" = {
      priority                  = 40
      version_policy            = "SNAPSHOT"
      allow_snapshot_overwrites = false
    },
    "internal-thirdparty" = {
      priority                  = 30
      version_policy            = null
      allow_snapshot_overwrites = false
    },
    "internal-testing" = {
      priority                  = 50
      version_policy            = null
      allow_snapshot_overwrites = false
    },
  }
}

// Artifact Repository for Docker images to be used by Cloud Run/GKE/GCE
resource "google_artifact_registry_repository" "internal" {
  for_each = local.internal_repos

  project       = var.project_id
  location      = "us"
  repository_id = "maven-${each.key}"
  description   = "Uber Freight internal Maven registry"
  format        = "Maven"

  cleanup_policy_dry_run = false

  maven_config {
    version_policy            = each.value.version_policy
    allow_snapshot_overwrites = each.value.allow_snapshot_overwrites
  }

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
  for_each = local.internal_repos

  project    = google_artifact_registry_repository.internal[each.key].project
  location   = google_artifact_registry_repository.internal[each.key].location
  repository = google_artifact_registry_repository.internal[each.key].name
  role       = "roles/artifactregistry.reader"
  members = [
    local.all_users,
  ]
}

# Read/Write access is given to all engineers (under Val)
resource "google_artifact_registry_repository_iam_binding" "internal_editor" {
  for_each = local.internal_repos

  project    = google_artifact_registry_repository.internal[each.key].project
  location   = google_artifact_registry_repository.internal[each.key].location
  repository = google_artifact_registry_repository.internal[each.key].name
  role       = "roles/artifactregistry.writer"
  members = [
    local.all_engineers,
  ]
}

# This allows for read/write and delete artifacts, but not the registry
# as management of the registry should be done via
# infra-as-code not (roles/artifactregistry.admin) the UI
resource "google_artifact_registry_repository_iam_binding" "internal_admin" {
  for_each = local.internal_repos

  project    = google_artifact_registry_repository.internal[each.key].project
  location   = google_artifact_registry_repository.internal[each.key].location
  repository = google_artifact_registry_repository.internal[each.key].name
  role       = "roles/artifactregistry.repoAdmin"
  members = [
    local.all_devops,
  ]
}

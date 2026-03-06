resource "google_gke_hub_feature" "configmanagement_feature" {
  name     = "configmanagement"
  count    = var.configmanagement_feature_exists ? 0 : 1
  location = "global"
}
resource "google_gke_hub_feature_membership" "configmanagement_feature_member" {
  location            = "global"
  feature             = "configmanagement"
  membership_location = var.region
  count               = var.configmanagement_feature_exists && var.configmanagement_feature_membership_exists ? 0 : 1
  membership          = "projects/${var.project_id}/locations/${var.region}/memberships/${var.name}"
  configmanagement {
    config_sync {
      source_format = "unstructured"
      enabled       = true
      git {
        sync_repo   = var.sync_repo
        sync_branch = var.sync_branch
        policy_dir  = var.policy_dir
        secret_type = var.secret_type
      }
    }
  }
  depends_on = [google_gke_hub_feature.configmanagement_feature]
}
resource "google_gke_hub_feature" "mesh_feature" {
  name     = "servicemesh"
  count    = var.mesh_feature_exists ? 0 : 1 # Skip creation if feature already exists
  location = "global"
  fleet_default_member_config {
    mesh {
      management = "MANAGEMENT_AUTOMATIC"
    }
  }
}
resource "google_gke_hub_feature_membership" "service_mesh_feature_member" {
  count               = var.mesh_feature_membership_exists ? 0 : 1
  location            = "global"
  feature             = "servicemesh"
  membership          = "projects/${var.project_id}/locations/${var.region}/memberships/${var.name}"
  membership_location = var.region
  mesh {
    management = "MANAGEMENT_AUTOMATIC"
  }
}

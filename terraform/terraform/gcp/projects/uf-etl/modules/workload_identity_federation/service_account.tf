resource "google_service_account" "wif_sa" {
  account_id   = var.service_account_id
  display_name = var.service_account_display_name
}

resource "google_project_iam_custom_role" "wif_custom_role" {
  role_id     = "wif_custom_role"
  title       = "Workload Identity Pool Custom Role"
  description = "Custom role with get, list, and update permissions for Workload Identity Pools and Providers."
  permissions = [
    # Workload Identity Pool and Provider Permissions
    "iam.workloadIdentityPools.get",
    "iam.workloadIdentityPools.list",
    "iam.workloadIdentityPools.update",
    "iam.workloadIdentityPoolProviders.get",
    "iam.workloadIdentityPoolProviders.list",
    "iam.workloadIdentityPoolProviders.update",

    # Storage Objects and Folder Permissions
    "storage.objects.create",
    "storage.objects.get",
    "storage.objects.list",
    "storage.objects.delete",
    "storage.folders.get",
    "storage.folders.list",

    # Service Account Permissions
    "iam.serviceAccounts.create",
    "iam.serviceAccounts.get",
    "iam.serviceAccounts.list",

    # Workload Identity User Permissions
    "iam.serviceAccounts.signBlob",
    "iam.serviceAccounts.signJwt",
    "iam.serviceAccounts.implicitDelegation",
    "iam.serviceAccounts.getOpenIdToken",

    # Composer Permissions
    "composer.environments.get",
    "composer.environments.list",
    "composer.imageversions.list",
    "composer.operations.get",
    "composer.operations.list",
    "composer.operations.delete",
    "composer.userworkloadssecrets.get",
    "composer.userworkloadssecrets.list",

    # Add Airflow Permission
    "composer.environments.executeAirflowCommand",

    # Artifact Registry Permissions
    "artifactregistry.repositories.create",
    "artifactregistry.repositories.uploadArtifacts",
    "artifactregistry.repositories.downloadArtifacts",
    "artifactregistry.repositories.get",
    "artifactregistry.repositories.list",
  ]
  project = var.project_id
}

resource "google_service_account_iam_binding" "wif_sa_binding" {
  service_account_id = google_service_account.wif_sa.name
  role               = google_project_iam_custom_role.wif_custom_role.name
  members = [
    "principalSet://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/${var.pool_id}/*"
  ]
}

resource "google_service_account_iam_member" "wif_impersonation" {
  service_account_id = google_service_account.wif_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/projects/${var.project_number}/locations/global/workloadIdentityPools/${var.pool_id}/*"
}

resource "google_project_iam_member" "wif_custom_role_project_binding" {
  project = var.project_id
  role    = google_project_iam_custom_role.wif_custom_role.name
  member  = "serviceAccount:${google_service_account.wif_sa.email}"
}
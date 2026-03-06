###### HashiCorp GCP KMS Resource Module
# This module creates a Google Cloud KMS key ring and crypto key, along with a service
# account that has permissions to encrypt and decrypt using the crypto key.
# Updated to ensure KMS IAM bindings are applied correctly
# Create service account for kmskey
resource "google_service_account" "nonprod_vault_unsealer_sa" {
  project                      = var.project_id
  account_id                   = "np-vault-unsealer-sa"
  display_name                 = "Hashicorp - Non Prod Vault Unsealer Service Account"
  create_ignore_already_exists = true
}
resource "google_kms_key_ring" "nonprod-vault-k8s-unsealer-key" {
  name     = var.key_ring_name
  location = var.location
  project  = var.project_id
}

resource "google_kms_crypto_key" "nonprod-vault-k8s-crypto-key" {
  name     = var.crypto_key_name
  key_ring = google_kms_key_ring.nonprod-vault-k8s-unsealer-key.id
  #rotation_period = var.rotation_period
  purpose = "ENCRYPT_DECRYPT"
}

resource "google_kms_crypto_key_iam_member" "nonprod_vault_unsealer_sa_decrypt" {
  crypto_key_id = google_kms_crypto_key.nonprod-vault-k8s-crypto-key.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_service_account.nonprod_vault_unsealer_sa.email}"

  depends_on = [
    google_kms_crypto_key.nonprod-vault-k8s-crypto-key,
    google_service_account.nonprod_vault_unsealer_sa
  ]
}

resource "google_kms_crypto_key_iam_member" "nonprod_vault_unsealer_sa_key_view" {
  crypto_key_id = google_kms_crypto_key.nonprod-vault-k8s-crypto-key.id
  role          = "roles/cloudkms.viewer"
  member        = "serviceAccount:${google_service_account.nonprod_vault_unsealer_sa.email}"

  depends_on = [
    google_kms_crypto_key.nonprod-vault-k8s-crypto-key,
    google_service_account.nonprod_vault_unsealer_sa
  ]
}


resource "google_service_account_iam_binding" "vault_workload_identity" {
  service_account_id = google_service_account.nonprod_vault_unsealer_sa.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "serviceAccount:${var.project_id}.svc.id.goog[tp-vault/vault]",
  ]
}
###### END HashiCorp Non Prod GCP KMS Resource ######

###### Start HashiCorp Non Prod GCP KMS Resource #####
output "key_ring_id" {
  value = google_kms_key_ring.nonprod-vault-k8s-unsealer-key.id
}

output "crypto_key_id" {
  value = google_kms_crypto_key.nonprod-vault-k8s-crypto-key.id
}

output "google_service_account_id" {
  value = google_service_account.nonprod_vault_unsealer_sa.id
}

output "service_account_email" {
  description = "The email address of the Vault KMS service account"
  value       = google_service_account.nonprod_vault_unsealer_sa.email
}
###### END HashiCorp Non Prod GCP KMS Resource #####

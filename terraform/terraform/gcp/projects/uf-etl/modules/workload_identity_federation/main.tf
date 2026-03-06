resource "google_iam_workload_identity_pool" "tfc_identity_pool" {
  workload_identity_pool_id = var.pool_id
  display_name              = var.pool_name
  description               = var.pool_description
  disabled                  = var.pool_disabled
}

resource "google_iam_workload_identity_pool_provider" "pool-provider" {
  workload_identity_pool_id          = var.pool_id
  workload_identity_pool_provider_id = var.pool_provider_id
  display_name                       = var.pool_provider_display_name
  description                        = var.pool_provider_description
  disabled                           = var.pool_provider_disabled

  attribute_mapping = var.attribute_mapping

  oidc {
    issuer_uri = var.oidc_uri
  }

  attribute_condition = var.attribute_condition
}
# Include GCP configuration
include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

# Terraform configuration source
terraform {
  source = "../../../modules/workload_identity_federation"
}

# Inputs for the terragrunt configuration
inputs = {
  project_id                 = include.gcp.locals.project_id
  pool_id                    = "wif-prod"                                           # Name of WIF Pool Id
  pool_name                  = "wif-prod"                                           # The display name of the wif pool
  pool_description           = "prod WIF pool for authentication of composer CI/CD" # The description of the wif pool and what it is used for
  pool_disabled              = false                                                # A boolean depicting whether the wif pool is disabled or not. Should always be false
  pool_provider_id           = "terraform-cloud-oidc-prod"                          # The unique identifier for the Workload Identity Pool Provider within the specified pool.
  pool_provider_display_name = "oidc_provider_for_prod"                             # A human-readable name for the Workload Identity Pool Provider.
  pool_provider_description  = "Terraform Cloud OIDC Provider"                      # A detailed description of the Workload Identity Pool Provider.
  pool_provider_disabled     = false                                                # Shows whether the wif pool provider is disabled. Should always be false

  # The list of mapped attributes for wif
  attribute_mapping = {
    "attribute.aud"        = "assertion.aud"        # Maps the audience claim from the OIDC token. Verifies the token's audience
    "attribute.workflow"   = "assertion.workflow"   # Maps a custom workflow claim which shows the CI/CD pipeline that this is related to
    "attribute.actor"      = "assertion.actor"      # Maps the actor claim, representing the service that triggered the token issuance
    "google.subject"       = "assertion.sub"        # Maps the subject claim which identifies the principal for the identity provider.
    "attribute.repository" = "assertion.repository" # Maps a custom repository claim, specifying the repository associated with the token.
  }

  oidc_uri = "https://token.actions.githubusercontent.com" # Github uri where we can get the token for WIF

  # Any attribute conditions on WIF
  attribute_condition = "assertion.repository_owner=='uber-freight-internal'"

  sa_region                    = "us-south1"                        # Region for the service account
  service_account_id           = "wif-storage-prod"                 # WIF service account name dedicated to prod
  service_account_display_name = "prod WIF Storage Service Account" # WIF service account display name for prod
  project_id                   = include.gcp.locals.project_id
  project_number               = 747655092365
}
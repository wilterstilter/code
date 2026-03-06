# Include GCP configuration
include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

# Include common configuration
include "common" {
  path   = find_in_parent_folders("common.hcl")
  expose = true
}

# Terraform configuration source
terraform {
  source = "${dirname(find_in_parent_folders())}//projects/uf-data-warehouse/modules/workflow_identity_federation"
}

# Inputs for the Workflow Identity Federation
inputs = {
  pool_id                         = "wif-nonprod" # WIF environment name dedicated to nonprod
  pool_name                       = "wif-nonprod" # WIF display name for nonprod
  pool_description                = "Nonprod WIF pool for cloud composer CI/CD" # Description of the WIF pool
  pool_disabled                   = false # Should always be false
  pool_provider_id                = "terraform-cloud-oidc-nonprod" # The official name for the WIF pool provider
  pool_provider_display_name      = "oidc_provider_for_nonprod" # The display name for the WIF pool provider
  pool_provider_description       = "Terraform Cloud OIDC Provider" # The description for the WIF pool provider
  pool_provider_disabled          = false # Should always be false

  attribute_mapping = {
    "attribute.aud"   	        = "assertion.aud" # Maps the audience claim from the OIDC token. Verifies the token's audience
    "attribute.workflow"        = "assertion.workflow" # Maps a custom workflow claim which shows the CI/CD pipeline that this is related to
    "attribute.actor"      	    = "assertion.actor" # Maps the actor claim, representing the service that triggered the token issuance
    "google.subject"            = "assertion.sub" # Maps the subject claim which identifies the principal for the identity provider.
    "attribute.repository"    	= "assertion.repository" # Maps a custom repository claim, specifying the repository associated with the token.
  }

  oidc_uri              = "https://token.actions.githubusercontent.com" # Github uri for wif token access
  attribute_condition   = "assertion.repository_owner=='uber-freight-internal'"

  sa_region                    = "us-south1" # Region for the service account
  service_account_id           = "wif-storage-nonprod" # WIF service account name dedicated to nonprod
  service_account_display_name = "Nonprod WIF Storage Service Account" # WIF service account display name for nonprod
  project_id                   = include.gcp.locals.project_id
  project_number               = 125324592177
}
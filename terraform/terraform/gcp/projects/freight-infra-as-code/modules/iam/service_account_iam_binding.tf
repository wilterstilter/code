# Binds permissions to a service account
module "service_account-iam-bindings" {
  source  = "terraform-google-modules/iam/google//modules/service_accounts_iam"
  version = "~> 8.0"

  service_accounts = [google_service_account.bq-usage-monitor.email]
  project          = "freight-infra-as-code"
  mode             = "additive"

  bindings = {
    "roles/iam.serviceAccountUser" = [
      "group:freight-data@uberfreight.com",
    ]
  }
}

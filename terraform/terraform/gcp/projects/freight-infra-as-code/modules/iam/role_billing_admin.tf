module "role_billing_admin" {
  source  = "terraform-google-modules/iam/google//modules/custom_role_iam"
  version = "~> 7.7.1"

  target_level = "org"
  target_id    = var.organization_id
  role_id      = "billingAdmin"
  title        = "Billing Admin"
  description  = "Access to review budgets and analyze spend"
  permissions = [
    "resourcemanager.organizations.get",
    "billing.accounts.get",
    "billing.accounts.getIamPolicy",
    "billing.accounts.getPaymentInfo",
    "billing.accounts.getPricing",
    "billing.accounts.getSpendingInformation",
    "billing.accounts.getUsageExportSpec",
    "billing.accounts.list",
    "billing.accounts.redeemPromotion",
    "billing.budgets.get",
    "billing.budgets.list",
    "billing.credits.list",
    "billing.finOpsBenchmarkInformation.get",
    "billing.finOpsHealthInformation.get",
    "billing.resourceAssociations.list",
    "billing.subscriptions.list",
    "cloudasset.assets.searchAllResources",
    "cloudnotifications.activities.list",
    "cloudsupport.properties.get",
    "cloudsupport.techCases.list",
    "consumerprocurement.accounts.list",
    "consumerprocurement.orders.list",
    "logging.logEntries.list",
    "logging.logs.list",
    "logging.logServiceIndexes.list",
    "logging.logServices.list",
    "logging.privateLogEntries.list",
    "recommender.costRecommendations.listAll",
    "recommender.costRecommendations.summarizeAll",
    "recommender.resourcemanagerProjectUtilizationRecommendations.list",
    "recommender.spendBasedCommitmentRecommenderConfig.get",
    "resourcemanager.projects.get",
    "resourcemanager.projects.list",
  ]
}

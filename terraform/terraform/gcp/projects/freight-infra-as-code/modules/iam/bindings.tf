module "organization-iam-bindings" {
  source  = "terraform-google-modules/iam/google//modules/organizations_iam"
  version = "7.7.1"

  organizations = [var.organization_id]
  mode          = "authoritative"

  bindings = {
    "organizations/${var.organization_id}/roles/${module.role_infra_as_code_bot.custom_role_id}" = [
      "serviceAccount:iac-cicd@freight-infra-as-code.iam.gserviceaccount.com",
    ]
    "organizations/${var.organization_id}/roles/${module.role_base.custom_role_id}" = [
      "domain:uberfreight.com",
    ]
    "organizations/${var.organization_id}/roles/${module.role_datadog_viewer.custom_role_id}" = [
      google_service_account.datadog.member,
    ]
    "organizations/${var.organization_id}/roles/${module.role_crowdstrike_cspm.custom_role_id}" = [
      "serviceAccount:crowdstrike-cspm-integration@uf-infosec-p.iam.gserviceaccount.com",
    ]
    "roles/iam.serviceAccountTokenCreator" = [
      "serviceAccount:ddgci-3f5b9d2fc585e06875ef@datadog-gci-sts-us5-prod.iam.gserviceaccount.com",
      # As per doc: https://docs.datadoghq.com/integrations/google_cloud_platform/?tab=project#2-add-the-datadog-principal-to-your-service-account
      "serviceAccount:service-org-223503570424@gcp-sa-datastudio.iam.gserviceaccount.com" # Get this ID from https://lookerstudio.google.com/u/0/serviceAgentHelp
    ]
    "roles/cloudfunctions.serviceAgent" = [
      "serviceAccount:${local.securityCommandCenterServiceAccount}",
    ]
    "roles/securitycenter.serviceAgent" = [
      "serviceAccount:${local.securityCommandCenterServiceAccount}",
    ]
    "roles/serviceusage.serviceUsageAdmin" = [
      "serviceAccount:${local.securityCommandCenterServiceAccount}",
    ]
    # Org Policy permissions are not supported in custom roles
    "roles/orgpolicy.policyAdmin" = [
      "serviceAccount:iac-cicd@freight-infra-as-code.iam.gserviceaccount.com",
    ]
    "roles/securitycenter.assetsViewer" = [
      "serviceAccount:svc-csm-prod@cloudsec-prod.iam.gserviceaccount.com"
    ]
    "roles/securitycenter.findingsViewer" = [
      "serviceAccount:svc-csm-prod@cloudsec-prod.iam.gserviceaccount.com"
    ]
    "roles/bigquery.resourceViewer" = [
      google_service_account.bq-usage-monitor.member,
      "serviceAccount:looker-bq-monitoring@uf-bq-admin-p.iam.gserviceaccount.com",
    ]
    "organizations/${var.organization_id}/roles/${module.role_pam_manager.custom_role_id}" = [
      "serviceAccount:service-org-223503570424@gcp-sa-pam.iam.gserviceaccount.com"
    ]
    "organizations/${var.organization_id}/roles/${module.role_bq_usage_viewer.custom_role_id}" = [
      google_service_account.bq-usage-monitor.member,
    ]
    "roles/billing.viewer" = [
      "group:freight-data-eng@uberfreight.com",
    ]
  }
}

module "wiz" {
  source                           = "https://wizio-public.s3.amazonaws.com/deployment-v2/gcp/wiz-gcp-org-terraform-module.zip"
  org_id                           = var.organization_id
  wiz_managed_identity_external_id = var.wiz_managed_identity_external_id
  serverless_scanning              = true
  data_scanning                    = true
  forensic                         = true

}

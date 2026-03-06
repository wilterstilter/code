include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "${dirname(find_in_parent_folders())}//projects/uf-infosec/modules/wiz"
}

inputs = {
  project_id = include.gcp.locals.project_id
  organization_id = include.gcp.locals.organization_id
  wiz_managed_identity_external_id = "wiz966af5859a6f68e96156d3ebf4f@prod-us76.iam.gserviceaccount.com"
}

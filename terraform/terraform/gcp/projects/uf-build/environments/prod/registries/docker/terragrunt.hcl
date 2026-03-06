# Adds all terraform + provider blocks
include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "${dirname(find_in_parent_folders())}//projects/uf-build/modules/registries/docker"
}

inputs = {
  project_id = include.gcp.locals.project_id
  service_account_readers = [
    "devpod-us-east4@uf-cloud-workstations-p.iam.gserviceaccount.com",
    "openshift-dev@uf-build-p.iam.gserviceaccount.com",
    "openshift-test@uf-build-p.iam.gserviceaccount.com",
    "openshift-uat@uf-build-p.iam.gserviceaccount.com",
    "openshift-alpha@uf-build-p.iam.gserviceaccount.com",
    "openshift-staging@uf-build-p.iam.gserviceaccount.com",
    "openshift-prod@uf-build-p.iam.gserviceaccount.com",
    "jenkins-nonprod@uf-build-p.iam.gserviceaccount.com"
  ]
}

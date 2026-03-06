# Adds all terraform + provider blocks
include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-build/modules/iam"
}

inputs = {
    project_id = include.gcp.locals.project_id
    service_accounts = [
        "openshift-dev",
        "openshift-test",
        "openshift-uat",
        "openshift-alpha",
        "openshift-staging",
        "openshift-prod",
        "jenkins-nonprod",
        "ptms-cvs"
    ]
}

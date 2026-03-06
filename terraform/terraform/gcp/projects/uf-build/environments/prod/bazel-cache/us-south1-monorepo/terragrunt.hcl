# Adds all terraform + provider blocks
include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-build/modules/bazel-cache"
}

include "cache" {
    path = find_in_parent_folders("cache.hcl")
    expose = true
}

inputs = {
    name         = include.cache.locals.name
    region       = "us-south1"
    service_accounts = [
        "ghr-us-south1-monorepo@uf-build-p.iam.gserviceaccount.com",
        "devpod-us-east4@uf-cloud-workstations-p.iam.gserviceaccount.com",
        "iac-cicd@freight-infra-as-code.iam.gserviceaccount.com",
        "arc-controller-sa@uf-compute-d.iam.gserviceaccount.com",
    ],
    groups = [
        "val-marchevsky-all-staff@uberfreight.com",
    ]
}

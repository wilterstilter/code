include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

include "common" {
    path = find_in_parent_folders("common.hcl")
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/freight-infra-as-code/modules/buckets"
}

inputs = {
    buckets = [
        "uf-digger-locks",
        "uf-digger-plans",
        "uf-iac-cisco",
        "uf-iac-github"
    ]
}

include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-build/modules/buckets"
}

inputs = {
    buckets = [
        "uf-cloud-workstation-artifacts"
    ]
}

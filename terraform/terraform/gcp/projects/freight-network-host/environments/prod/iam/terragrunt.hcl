include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

include "common" {
    path = find_in_parent_folders("common.hcl")
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/freight-network-host/modules/iam"
}

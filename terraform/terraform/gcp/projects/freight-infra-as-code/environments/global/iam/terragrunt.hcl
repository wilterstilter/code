include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/freight-infra-as-code/modules/iam"
}

inputs = {
    organization_id = include.gcp.locals.organization_id
}



include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

include "common" {
    path = find_in_parent_folders("common.hcl")
    expose = true
}


terraform {
    source = "${dirname(find_in_parent_folders())}//projects/freight-infra-as-code/modules/folders"
}

inputs = {
    organization_id = include.gcp.locals.organization_id
    environments = include.common.locals.environments
}

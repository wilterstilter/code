#
include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-fintech-doc-automation/modules/processors"
}

inputs = {
    project_id  = include.gcp.locals.project_id
    authorized_project_numbers = ["908221627857"]
}

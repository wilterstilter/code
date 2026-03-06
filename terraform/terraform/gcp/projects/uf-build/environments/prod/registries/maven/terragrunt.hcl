# Adds all terraform + provider blocks
include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-build/modules/registries/maven"
}

inputs = {
    project_id      = include.gcp.locals.project_id
}

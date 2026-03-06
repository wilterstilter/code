include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-cameyo/modules/byoc"
}

inputs = {
    project_id  = include.gcp.locals.project_id
}

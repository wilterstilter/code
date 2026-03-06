# Adds all terraform + provider blocks
include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

include "common" {
    path = find_in_parent_folders("common.hcl")
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-change-data-capture/modules/cdc"
}

inputs = {
    env = include.gcp.locals.env // i.e. nonprod
    // region = include.common.locals.region

    project_id               = include.gcp.locals.project_id
    env                      = include.gcp.locals.env
    bucket_location          = "US"
    base_labels              = merge(include.common.locals.base_labels, {"env": include.gcp.locals.env})
    debezium_resource_labels = include.common.locals.debezium_resource_labels
}

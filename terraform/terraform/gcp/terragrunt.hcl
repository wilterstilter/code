
# https://terragrunt.gruntwork.io/docs/reference/config-blocks-and-attributes/#remote_state
remote_state {
    backend = "gcs"
    # disable_init = true # only allow creation of bucket via base
    # (for local testing + --terragrunt-log-level=debug --terragrunt-source-update)

    generate = {
        path      = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }

    config = {
        skip_bucket_creation = true # only allow creation of bucket via base
        prefix   = join("/", slice(split("/", path_relative_to_include()), 4, length(split("/", path_relative_to_include()))))
        project  = "freight-infra-as-code" # where bucket will be created (always point to main infra as code project for bucket management)
        bucket   = "uf-iac-${local.project_id}" # for project override change (should only have single env)
    }
}

generate "provider" {
    path = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
provider "google" {
    project               = "${local.project_id}"
    billing_project       = "freight-infra-as-code"
    user_project_override = true
}
provider "google-beta" {
    project               = "${local.project_id}"
    billing_project       = "freight-infra-as-code"
    user_project_override = true
}
EOF
}

locals {
    env               = split("/", path_relative_to_include())[3]
    env_short         = substr(local.env, 0, 1)

    project_id_global = split("/", path_relative_to_include())[1]
    project_id_env    = "${split("/", path_relative_to_include())[1]}-${local.env_short}"

    organization_id = "223503570424"
    project_id      = contains(["prod", "nonprod", "dev"], split("/", path_relative_to_include())[3]) ? local.project_id_env : local.project_id_global
}

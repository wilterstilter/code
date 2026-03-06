
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
        prefix   = join("/", slice(split("/", path_relative_to_include()), 1, length(split("/", path_relative_to_include()))))
        project  = "freight-infra-as-code" # where bucket will be created (always point to main infra as code project for bucket management)
        bucket   = "uf-iac-github"
    }
}

generate "provider" {
    path = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
provider "github" {
  owner = "${local.organization}"
  token = "${split("/", path_relative_to_include())[1] == "internal" ? get_env("GH_TF_TOKEN_INTERNAL") : get_env("GH_TF_TOKEN_SANDBOX")}"
}
EOF
}

locals {
    organization = format("uber-freight-%s", split("/", path_relative_to_include())[1])
}

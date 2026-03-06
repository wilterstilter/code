
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
        project  = "freight-infra-as-code"
        bucket   = "uf-iac-cisco"
    }
}

generate "provider" {
    path = "provider.tf"
    if_exists = "overwrite_terragrunt"
    contents = <<EOF
provider "nxos" {
  username = "${get_env("IAC_CISCO_USERNAME", "cisco-infra-as-code")}"
  password = "${get_env("IAC_CISCO_PASSWORD")}"
  url      = "https://${split("/", path_relative_to_include())[1]}"
}
provider "iosxe" {
  username = "${get_env("IAC_CISCO_USERNAME", "cisco-infra-as-code")}"
  password = "${get_env("IAC_CISCO_PASSWORD")}"
  url      = "https://${split("/", path_relative_to_include())[1]}"
}
EOF
}

locals {
    device = split("/", path_relative_to_include())[1]
}

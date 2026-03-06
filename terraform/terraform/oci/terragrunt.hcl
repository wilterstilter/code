# Root terragrunt configuration for OCI POC
# Using GCS backend for simplicity (state stored in GCP)
remote_state {
  backend = "gcs"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    skip_bucket_creation = true
    bucket               = "uf-iac-oci"
    prefix               = join("/", compact(["oci", path_relative_to_include()]))
    project              = "freight-infra-as-code"
  }
}

# Generate provider configuration
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
# OCI Provider will use CLI config from ~/.oci/config
provider "oci" {
  region = var.region
}
EOF
}

# Auto-retry configuration
terraform {
  extra_arguments "retry_lock" {
    commands = [
      "init",
      "apply",
      "refresh",
      "import",
      "plan",
      "taint",
      "untaint"
    ]

    arguments = [
      "-lock-timeout=10m"
    ]
  }
}


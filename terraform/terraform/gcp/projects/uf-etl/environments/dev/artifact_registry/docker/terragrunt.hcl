# Include GCP configuration
include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

# Terraform configuration source
terraform {
  source = "../../../../modules/artifact_registry/docker"
}

inputs = {
  project_id = include.gcp.locals.project_id
  location   = "us-south1"
  repositories = {
    # Main Docker repository for ETL development images
    "uf-etl-dev-internal-docker" = {
      description    = "Internal Docker images for dev environment"
      keep_count     = 3     # Minimum number of versions of an image to keep.
      immutable_tags = false # The repository which enabled this flag prevents all tags from being modified, moved or deleted. This does not prevent tags from being created.
    }
  }
}

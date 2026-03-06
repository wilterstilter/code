# Include GCP configuration
include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

# Terraform configuration source
terraform {
  source = "../../../modules/gcs"
}

inputs = {
  project_id = include.gcp.locals.project_id
  location   = "us-south1"
  buckets = [
    {
      name = "uf-vertex-ai-suite-p-freight-data-artifacts"
      controls = {
        "roles/storage.objectUser" = {
          entities = [
            "group:freight-data@uberfreight.com",
          ]
        }
      }
    },
    {
      name = "uf-vertex-ai-suite-p-data-science-artifacts"
      controls = {
        "roles/storage.objectUser" = {
          entities = [
            "group:ufds-group@uberfreight.com",
          ]
        }
      }
    }
  ]
}

# Include GCP configuration
include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

# Include common configuration
include "common" {
  path   = find_in_parent_folders("common.hcl")
  expose = true
}

terraform {
  source = "${dirname(find_in_parent_folders())}//projects/uf-data-warehouse/modules/compute_instance"
}

inputs = {
  project_id   = include.gcp.locals.project_id
  name         = "prod"

  # global VM defaults that can be overriden
  # network defualts
  subnetwork = "projects/freight-network-host-p/regions/us-south1/subnetworks/us-south1-kafka-connect"

  # machine spec defualts
  machine_type  = "n2-standard-16"
  disk_size_gb  = 256
  disk_type     = "pd-ssd"
  restart_policy        = "Always"

  # OS defaults - defaulted to COS
  cos_project      = "cos-cloud"
  cos_image_family = "stable"
  cos_image_name   = "cos-stable-113-18244-85-65"

  # optional global env (applied to every VM's container). Keep generic.
  env_defaults = {
    APP_ENV   = "prod"
    REST_PORT = "8083"
  }

  # optional extra metadata/tags/labels for all VMs
  additional_metadata = {}
  default_tags   = []
  default_labels = { team = "data-platform" }

  # Use instance naming convention : cdc-<env>-<domain>-<purpose>. e.g., cdc-(prod|non-prod)-(tms|mx|celtic)-(monitor|kafka-connect)
  instances = {
    cdc-prod-monitor = {
      name     = "cdc-prod-monitor"
      hostname = "cdc-prod-monitor"
      disk_size_gb = 512
      labels = {
        instance-group = "cdc-prod"
      }
    },
    cdc-non-prod-monitor = {
      name     = "cdc-non-prod-monitor"
      hostname = "cdc-non-prod-monitor"
      labels = {
        instance-group = "cdc-non-prod"
      }
    },
    cdc-prod-mx-kafka-connect = {
      name     = "cdc-prod-mx-kafka-connect"
      hostname = "cdc-prod-mx-kafka-connect"
      disk_size_gb = 512
      labels = {
        instance-group = "cdc-prod"
      }
    },
    cdc-non-prod-mx-kafka-connect = {
      name     = "cdc-non-prod-mx-kafka-connect"
      hostname = "cdc-non-prod-mx-kafka-connect"
      labels = {
        instance-group = "cdc-non-prod"
      }
    },
    cdc-prod-monitor-temp = {
      name     = "cdc-prod-monitor-temp"
      hostname = "cdc-prod-monitor-temp"
      cos_image_name = "cos-125-19216-104-74"
      disk_size_gb = 512
      labels = {
        instance-group = "cdc-prod"
      }
    },
    cdc-non-prod-monitor-temp = {
      name     = "cdc-non-prod-monitor-temp"
      hostname = "cdc-non-prod-monitor-temp"
      cos_image_name = "cos-125-19216-104-74"
      labels = {
        instance-group = "cdc-non-prod"
      }
    },
    cdc-prod-mx-kafka-connect-temp = {
      name     = "cdc-prod-mx-kafka-connect-temp"
      hostname = "cdc-prod-mx-kafka-connect-temp"
      cos_image_name = "cos-125-19216-104-74"
      disk_size_gb = 512
      labels = {
        instance-group = "cdc-prod"
      }
    },
    cdc-non-prod-mx-kafka-connect-temp = {
      name     = "cdc-non-prod-mx-kafka-connect-temp"
      hostname = "cdc-non-prod-mx-kafka-connect-temp"
      cos_image_name = "cos-125-19216-104-74"
      labels = {
        instance-group = "cdc-non-prod"
      }
    }
  }
}

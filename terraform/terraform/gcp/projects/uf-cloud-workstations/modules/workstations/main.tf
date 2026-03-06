locals {
  configs = {
    standard = {
      machine_type = "n2-standard-2" # 2vCPU, 8GB memory

      container = {
        image = "us-docker.pkg.dev/uf-build-p/docker-all/cloud-workstations-images/custom/code-oss"
      }
    }
    large = {
      machine_type = "n2-standard-8" # 8vCPU, 32GB memory

      container = {
        image = "us-docker.pkg.dev/uf-build-p/docker-all/cloud-workstations-images/custom/code-oss"
      }
    }

    vanilla-standard = {
      machine_type = "n2-standard-2" # 2vCPU, 8GB memory

      container = {
        image = "us-central1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss"
      }
    }
  }
}

# Workstation Cluster
resource "google_workstations_workstation_cluster" "cluster" {
  provider               = google-beta
  workstation_cluster_id = "${var.name}-${var.region}"
  display_name           = "${var.name}-${var.region}"
  network                = var.network_id
  subnetwork             = var.subnet_id
  location               = var.region

  private_cluster_config {
    enable_private_endpoint = true
    allowed_projects        = []
  }

  domain_config {
    domain = "${var.region}.${var.name}.ufinternal.com"
  }

  labels      = var.labels
  annotations = {}
}

resource "google_service_account" "default" {
  account_id   = "${var.name}-${var.region}"
  display_name = "Service Account used on all VMs"
}

# Cluster configuration
resource "google_workstations_workstation_config" "default" {
  for_each = local.configs

  provider               = google-beta
  workstation_config_id  = "${var.name}-${var.region}-${each.key}"
  workstation_cluster_id = google_workstations_workstation_cluster.cluster.workstation_cluster_id
  location               = var.region
  display_name           = each.key

  idle_timeout    = "7200s"  # 2 hours
  running_timeout = "43200s" # 12 hours

  replica_zones = var.replica_zones
  annotations   = {}

  labels = var.labels

  # Default to Base Editor (Code OSS for Cloud Workstations)
  # But we can also create own image later with specific packages installed
  container {
    image = each.value.container.image
  }

  host {
    gce_instance {
      service_account              = google_service_account.default.email
      enable_nested_virtualization = true
      disable_public_ip_addresses  = true
      machine_type                 = each.value.machine_type
      boot_disk_size_gb            = 35 # must be > 30gb
      pool_size                    = 1  # slower startup (lower cost)

      shielded_instance_config {
        enable_integrity_monitoring = true
        enable_secure_boot          = true
        enable_vtpm                 = true
      }
    }
  }

  persistent_directories {
    gce_pd {
      disk_type      = "pd-standard"
      fs_type        = "ext4"
      reclaim_policy = "RETAIN"
      size_gb        = 200
    }
    mount_path = "/home"
  }
}

resource "google_workstations_workstation_config_iam_binding" "creator" {
  for_each = local.configs

  provider               = google-beta
  project                = google_workstations_workstation_config.default[each.key].project
  location               = google_workstations_workstation_config.default[each.key].location
  workstation_cluster_id = google_workstations_workstation_config.default[each.key].workstation_cluster_id
  workstation_config_id  = google_workstations_workstation_config.default[each.key].workstation_config_id
  role                   = "roles/workstations.workstationCreator"
  members                = [local.everyone]
}

module "projects_iam_bindings" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
  version = "~> 7.7"
  mode    = "authoritative"

  projects = [var.project_id]

  bindings = {
    "roles/workstations.operationViewer" = [local.everyone]
  }
}

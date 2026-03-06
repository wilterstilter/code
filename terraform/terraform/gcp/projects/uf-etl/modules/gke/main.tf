# Create a GKE cluster
resource "google_container_cluster" "gke" {
  project          = var.project_id
  name             = var.name
  location         = var.region
  network          = var.network
  subnetwork       = var.subnetwork
  node_locations   = var.zones
  enable_autopilot = true

  # Add IP allocation policy for shared VPC
  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  node_pool_auto_config {
    network_tags {
      tags = [
        "gke-${var.name}"
      ]
    }
  }

  cluster_autoscaling {
    auto_provisioning_defaults {
      service_account = google_service_account.gke.email
      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform"
      ]
    }
  }

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks
      content {
        cidr_block   = cidr_blocks.value
        display_name = "Network-${cidr_blocks.key}"
      }
    }
  }

  # Private cluster configuration
  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block # e.g., "10.227.8.0/28"
  }

  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  # Deletion protection
  deletion_protection = false

  # Maintenance window
  maintenance_policy {
    recurring_window {
      start_time = var.maintenance_start_time
      recurrence = var.maintenance_recurrence
      end_time   = var.maintenance_end_time
    }
  }

  # Release channel
  release_channel {
    channel = "STABLE"
  }
}

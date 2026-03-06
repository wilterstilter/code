# Create a GKE cluster
resource "google_container_cluster" "gke" {
  project          = var.project_id
  name             = var.name
  location         = var.region
  network          = var.network
  subnetwork       = var.subnetwork
  node_locations   = var.zones
  enable_autopilot = true

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

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
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

  # Enable private cluster
  private_cluster_config {
    enable_private_endpoint = true
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }
    gke_backup_agent_config {
      enabled = true
    }
  }

  # Fleet management
  fleet {
    project = var.project_id
  }

  # Deletion protection
  deletion_protection = false

  # Release channel
  release_channel {
    channel = "STABLE"
  }

  # Maintenance window
  maintenance_policy {
    recurring_window {
      start_time = var.maintenance_start_time
      recurrence = var.maintenance_recurrence
      end_time   = var.maintenance_end_time
    }
  }

  # Labels
  resource_labels = var.cluster_labels
  cost_management_config {
    enabled = true
  }

}

# GKE Module Outputs

# =============================================================================
# GKE Cluster Outputs
# =============================================================================

output "cluster_name" {
  description = "The name of the GKE cluster"
  value       = google_container_cluster.gke.name
}

output "cluster_endpoint" {
  description = "The endpoint of the GKE cluster"
  value       = google_container_cluster.gke.endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "The CA certificate of the GKE cluster"
  value       = google_container_cluster.gke.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "cluster_location" {
  description = "The location of the GKE cluster"
  value       = google_container_cluster.gke.location
}

output "gke_service_account_email" {
  description = "The email address of the GKE service account"
  value       = google_service_account.gke.email
}

# =============================================================================
# OpenTelemetry Outputs
# =============================================================================

output "opentelemetry_service_account_email" {
  description = "The email address of the OpenTelemetry Collector service account"
  value       = var.enable_opentelemetry ? google_service_account.opentelemetry_collector[0].email : null
}

output "opentelemetry_service_account_name" {
  description = "The name of the OpenTelemetry Collector service account"
  value       = var.enable_opentelemetry ? google_service_account.opentelemetry_collector[0].name : null
}

output "opentelemetry_service_account_id" {
  description = "The ID of the OpenTelemetry Collector service account"
  value       = var.enable_opentelemetry ? google_service_account.opentelemetry_collector[0].id : null
}

output "opentelemetry_workload_identity_annotation" {
  description = "The annotation for Kubernetes service account Workload Identity binding"
  value = var.enable_opentelemetry ? {
    "iam.gke.io/gcp-service-account" = google_service_account.opentelemetry_collector[0].email
  } : {}
}

output "opentelemetry_helm_values" {
  description = "Helm values for OpenTelemetry Collector configuration"
  value = var.enable_opentelemetry ? {
    serviceAccount = {
      create = false
      name   = var.opentelemetry_service_account_name
      annotations = {
        "iam.gke.io/gcp-service-account" = google_service_account.opentelemetry_collector[0].email
      }
    }
    global = {
      projectId = var.project_id
    }
    exporters = {
      datadog = {
        enabled          = var.opentelemetry_enable_datadog
        apiKeySecretName = var.opentelemetry_datadog_secret_name
      }
    }
    } : {
    serviceAccount = {
      create      = false
      name        = ""
      annotations = {}
    }
    global = {
      projectId = ""
    }
    exporters = {
      datadog = {
        enabled          = false
        apiKeySecretName = ""
      }
    }
  }
}

output "opentelemetry_datadog_secret_name" {
  description = "The name of the Datadog API key secret in Secret Manager"
  value       = var.enable_opentelemetry ? var.opentelemetry_datadog_secret_name : null
}

output "kubernetes_host" {
  description = "The hostname of the GKE cluster."
  value       = data.google_container_cluster.primary.endpoint
}

output "cluster_ca_certificate" {
  description = "The cluster CA certificate (base64 encoded)."
  value       = data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "custom_runner_image" {
  description = "The full tag of the runner image being used"
  value       = local.final_runner_image
}

output "custom_build_enabled" {
  description = "Whether custom image is enabled"
  value       = var.enable_custom_image
}

output "runner_namespace" {
  description = "The Kubernetes namespace where runners are deployed"
  value       = local.arc_namespace
}

output "runner_set_names" {
  description = "The names of all runner sets (use these in workflows with runs-on)"
  value = {
    for key, runner_set in var.runner_sets : key => runner_set.runner_set_name
  }
}
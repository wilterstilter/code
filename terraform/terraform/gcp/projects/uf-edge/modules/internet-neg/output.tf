output "name" {
  value = google_compute_global_network_endpoint_group.default.name
}

output "neg_self_link" {
  description = "A map containing the self-link of the global network endpoint group. The key is 'global'."
  value       = { "global" = google_compute_global_network_endpoint_group.default.self_link }
}

output "self_link" {
  description = "The self-link of the global network endpoint group."
  value       = google_compute_global_network_endpoint_group.default.self_link
}

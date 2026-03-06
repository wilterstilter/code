output "health_check_self_links" {
  description = "Map of health check names to their self links"
  value = {
    for name, hc in google_compute_health_check.default : name => hc.self_link
  }
}

output "backend_service_self_links" {
  description = "Map of backend service names to their self links"
  value = {
    for name, bs in google_compute_backend_service.default : name => bs.self_link
  }
}

output "backend_service_ids" {
  description = "Map of backend service names to their IDs"
  value = {
    for name, bs in google_compute_backend_service.default : name => bs.id
  }
}

output "backend_service_names" {
  description = "Map of logical names to actual backend service names"
  value = {
    for name, bs in google_compute_backend_service.default : name => bs.name
  }
}

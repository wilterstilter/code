output "health_checks" {
  description = "Global health check resources"
  value       = google_compute_health_check.default
}

output "region_health_checks" {
  description = "Regional health check resources (for TCP + INTERNAL_MANAGED)"
  value       = google_compute_region_health_check.default
}

output "backend_services" {
  description = "Backend service resources"
  value       = google_compute_region_backend_service.default
}

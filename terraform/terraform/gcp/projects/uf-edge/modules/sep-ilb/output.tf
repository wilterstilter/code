output "ip" {
  value       = google_compute_address.default.address
  description = "Load Balancer private IP address"
}

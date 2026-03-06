output "ip" {
  value       = google_compute_global_address.default.address
  description = "Load Balancer public IP address"
}

output "dns_authorization_cname" {
  description = "CNAME record needed for Certificate Manager DNS authorization for the primary domain"
  value       = google_certificate_manager_dns_authorization.main.dns_resource_record[0]
}

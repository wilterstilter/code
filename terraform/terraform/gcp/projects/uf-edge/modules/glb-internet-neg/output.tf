output "ip" {
  value       = google_compute_global_address.default.address
  description = "Load Balancer public IP address."
}

output "dns_authorization_cnames" {
  description = "A map of domain names to the CNAME records required to prove domain ownership for the Google-managed SSL certificate."
  value = {
    for auth in google_certificate_manager_dns_authorization.main : auth.domain => auth.dns_resource_record[0]
  }
}

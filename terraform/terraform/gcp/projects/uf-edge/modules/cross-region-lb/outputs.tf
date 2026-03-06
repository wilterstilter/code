#------------------------------------------------------------------------------
# Frontend IP Addresses
#------------------------------------------------------------------------------
output "frontend_ip_addresses_external" {
  description = "Map of frontend names to their external IP addresses"
  value = {
    for key, addr in google_compute_global_address.frontend_ips_external : key => addr.address
  }
}

output "frontend_ip_addresses_internal" {
  description = "Map of frontend-region to their internal IP addresses"
  value = {
    for key, addr in google_compute_address.frontend_ips_internal : key => addr.address
  }
}

output "frontend_ip_ids_external" {
  description = "Map of frontend names to their external IP resource IDs"
  value = {
    for key, addr in google_compute_global_address.frontend_ips_external : key => addr.id
  }
}

output "frontend_ip_ids_internal" {
  description = "Map of frontend-region to their internal IP resource IDs"
  value = {
    for key, addr in google_compute_address.frontend_ips_internal : key => addr.id
  }
}

#------------------------------------------------------------------------------
# Backend Services
#------------------------------------------------------------------------------
output "backend_service_ids" {
  description = "Map of backend names to their backend service IDs"
  value = {
    for key, backend in google_compute_backend_service.backends : key => backend.id
  }
}

output "backend_service_self_links" {
  description = "Map of backend names to their backend service self links"
  value = {
    for key, backend in google_compute_backend_service.backends : key => backend.self_link
  }
}

#------------------------------------------------------------------------------
# Health Checks
#------------------------------------------------------------------------------
output "health_check_ids" {
  description = "Map of health check names to their IDs"
  value = {
    for key, hc in google_compute_health_check.health_checks : key => hc.id
  }
}

output "health_check_self_links" {
  description = "Map of health check names to their self links"
  value = {
    for key, hc in google_compute_health_check.health_checks : key => hc.self_link
  }
}

#------------------------------------------------------------------------------
# URL Maps
#------------------------------------------------------------------------------
output "url_map_id" {
  description = "The ID of the main URL map"
  value       = length(google_compute_url_map.default) > 0 ? google_compute_url_map.default[0].id : null
}

output "url_map_self_link" {
  description = "The self link of the main URL map"
  value       = length(google_compute_url_map.default) > 0 ? google_compute_url_map.default[0].self_link : null
}

#------------------------------------------------------------------------------
# Target Proxies
#------------------------------------------------------------------------------
output "https_proxy_id" {
  description = "The ID of the HTTPS proxy"
  value       = length(google_compute_target_https_proxy.https_proxy) > 0 ? google_compute_target_https_proxy.https_proxy[0].id : null
}

output "http_proxy_id" {
  description = "The ID of the HTTP redirect proxy"
  value       = length(google_compute_target_http_proxy.http_proxy) > 0 ? google_compute_target_http_proxy.http_proxy[0].id : null
}

output "http_direct_proxy_id" {
  description = "The ID of the HTTP direct proxy"
  value       = length(google_compute_target_http_proxy.http_direct) > 0 ? google_compute_target_http_proxy.http_direct[0].id : null
}

#------------------------------------------------------------------------------
# Forwarding Rules
#------------------------------------------------------------------------------
output "https_forwarding_rule_ids_external" {
  description = "Map of frontend names to their HTTPS forwarding rule IDs (external)"
  value = {
    for key, rule in google_compute_global_forwarding_rule.https_external : key => rule.id
  }
}

output "https_forwarding_rule_ids_internal" {
  description = "Map of frontend-region to their HTTPS forwarding rule IDs (internal)"
  value = {
    for key, rule in google_compute_global_forwarding_rule.https_internal : key => rule.id
  }
}

output "http_forwarding_rule_ids_external" {
  description = "Map of frontend names to their HTTP forwarding rule IDs (external)"
  value = {
    for key, rule in google_compute_global_forwarding_rule.http_external : key => rule.id
  }
}

output "http_forwarding_rule_ids_internal" {
  description = "Map of frontend-region to their HTTP forwarding rule IDs (internal)"
  value = {
    for key, rule in google_compute_global_forwarding_rule.http_internal : key => rule.id
  }
}

#------------------------------------------------------------------------------
# SSL Certificate
#------------------------------------------------------------------------------
output "managed_ssl_certificate_id" {
  description = "The ID of the managed SSL certificate (if created)"
  value       = var.create_ssl_certificate && var.ssl_certificate_domains != null ? google_compute_managed_ssl_certificate.default[0].id : null
}

resource "google_certificate_manager_certificate" "default" {
  name        = var.name
  description = var.description
  location    = var.location
  scope       = var.scope
  self_managed {
    pem_certificate = var.cert_pem
    pem_private_key = var.key_pem
  }
}

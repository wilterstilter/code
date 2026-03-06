module "default" {
  source  = "terraform-google-modules/cloud-dns/google"
  version = "5.2.0"

  project_id  = var.project_id
  type        = "forwarding"
  name        = replace(var.domain, ".", "-")
  domain      = "${var.domain}."
  description = "DNS Forwrding Zone for ${var.domain}"

  private_visibility_config_networks = [var.network]
  target_name_server_addresses = [
    for ip in var.targets : {
      ipv4_address    = ip,
      forwarding_path = "private"
    }
  ]
}

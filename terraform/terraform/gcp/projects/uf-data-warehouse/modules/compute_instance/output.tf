output "instances" {
  description = "Instances and their key attributes"
  value = {
    for k, v in google_compute_instance.vm :
    k => {
      name        = v.name
      hostname    = try(v.hostname, null)
      zone        = v.zone
      self_link   = v.self_link
      internal_ip = try(v.network_interface[0].network_ip, null)
      public_ip   = try(v.network_interface[0].access_config[0].nat_ip, null)
      tags        = v.tags
      labels      = v.labels
    }
  }
}

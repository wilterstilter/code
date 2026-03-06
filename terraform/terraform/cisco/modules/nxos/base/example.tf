resource "nxos_loopback_interface" "example" {
  interface_id = "lo10"
  admin_state  = "up"
  description  = var.interface_description
}

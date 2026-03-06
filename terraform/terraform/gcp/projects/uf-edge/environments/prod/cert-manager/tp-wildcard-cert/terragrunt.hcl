include "gcp" {
    path = find_in_parent_folders()
    expose = true
}
 
terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-edge/modules/cert-manager"
}
 
 
inputs = {
  name              = "tp-self-managed-crt"
  description       = "TP Domain Regional cert"
  location          = "us-south1"
  cert_pem          = "${get_env("TP_CERT_PEM")}"
  key_pem           = "${get_env("TP_KEY_PEM")}"
}

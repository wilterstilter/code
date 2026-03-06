include "gcp" {
    path = find_in_parent_folders()
    expose = true
}
 
terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-edge/modules/cert-manager"
}
 
 
inputs = {
  name              = "uf-self-managed-crt"
  description       = "UF Domain Regional cert"
  location          = "us-south1"
  cert_pem          = "${get_env("UF_CERT_PEM_2025")}"
  key_pem           = "${get_env("UF_KEY_PEM_2025")}"
}

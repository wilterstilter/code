include "gcp" {
    path = find_in_parent_folders()
    expose = true
}
 
terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-edge/modules/cert-manager"
}
 
 
inputs = {
  name              = "uber-internal-managed-crt"
  description       = "Uber Internal Domain Regional cert"
  location          = "us-south1"
  cert_pem          = "${get_env("UBERINT_CERT_PEM")}"
  key_pem           = "${get_env("UBERINT_KEY_PEM")}"
}

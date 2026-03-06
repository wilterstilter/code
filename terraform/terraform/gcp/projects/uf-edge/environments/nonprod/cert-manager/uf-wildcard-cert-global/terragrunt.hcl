include "gcp" {
    path = find_in_parent_folders()
    expose = true
}
 
terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-edge/modules/cross-region-cert-manager"
}
 
 
inputs = {
  name              = "uf-wildcard-cert-global"
  description       = "UF Domain global cert"
  location          = "global"
  scope             = "ALL_REGIONS"
  cert_pem          = "${get_env("UF_CERT_PEM_2025")}"
  key_pem           = "${get_env("UF_KEY_PEM_2025")}"
}

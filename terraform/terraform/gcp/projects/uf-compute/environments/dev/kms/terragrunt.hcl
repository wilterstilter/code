include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-compute/modules/kms"
}


include "common" {
  path = find_in_parent_folders("common.hcl")
  expose = true
}

inputs = {
  project_id      = include.gcp.locals.project_id
  key_ring_name   = "nonprod-vault-k8s-unsealer-key"
  crypto_key_name = "nonprod-vault-k8s-unsealer-vault-key"
  location        = "us-south1"
}
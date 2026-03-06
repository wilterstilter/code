locals {
  subnet_components = split("/", var.subnetwork)
  region            = local.subnet_components[index(local.subnet_components, "regions") + 1]
  kc_env_list = [
    for key, value in var.kafka_connect_env : {
      name  = key
      value = value
    }
  ]
}

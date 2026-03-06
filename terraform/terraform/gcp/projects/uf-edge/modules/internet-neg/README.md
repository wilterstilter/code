# Google Cloud Global Internet NEG Module

This module creates a Google Cloud Global Internet Network Endpoint Group (NEG). Internet NEGs can be used as backends for external HTTP(S) load balancers, allowing you to point to endpoints that are outside of Google Cloud, such as on-premise servers or services running in other cloud providers.

This module supports both `INTERNET_IP_PORT` and `INTERNET_FQDN_PORT` NEG types.

## Usage

### IP-Based Internet NEG

```hcl
module "my_internet_neg_ip" {
  source                = "./modules/internet-neg"
  project_id            = "your-gcp-project-id"
  name                  = "my-internet-neg-ip"
  network_endpoint_type = "INTERNET_IP_PORT"
  port                  = 443
  ip_addresses = [
    "1.2.3.4",
    "5.6.7.8"
  ]
}
```

### FQDN-Based Internet NEG

```hcl
module "my_internet_neg_fqdn" {
  source                = "./modules/internet-neg"
  project_id            = "your-gcp-project-id"
  name                  = "my-internet-neg-fqdn"
  network_endpoint_type = "INTERNET_FQDN_PORT"
  port                  = 443
  fqdns = [
    "app1.example.com",
    "app2.example.com"
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| `project_id` | The project ID to deploy to. | `string` | n/a | yes |
| `name` | The name of the network endpoint group. | `string` | n/a | yes |
| `network_endpoint_type` | The type of network endpoint group. Must be either `INTERNET_IP_PORT` or `INTERNET_FQDN_PORT`. | `string` | `"INTERNET_IP_PORT"` | no |
| `port` | The port for the network endpoint. | `number` | `443` | no |
| `ip_addresses` | A list of IP addresses to add as endpoints. Required when `network_endpoint_type` is `INTERNET_IP_PORT`. | `list(string)` | `[]` | no |
| `fqdns` | A list of FQDNs to add as endpoints. Required when `network_endpoint_type` is `INTERNET_FQDN_PORT`. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| `name` | The name of the created network endpoint group. |
| `neg_self_link` | A map containing the self-link of the global network endpoint group. The key is 'global'. |
| `self_link` | The self-link of the global network endpoint group. | 

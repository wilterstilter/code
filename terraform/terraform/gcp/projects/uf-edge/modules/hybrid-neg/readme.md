# Google Cloud Hybrid Network Endpoint Group (NEG) Module

This Terraform module creates a Google Cloud Hybrid Network Endpoint Group (NEG) of type `NON_GCP_PRIVATE_IP_PORT`. This allows a Google Cloud load balancer to send traffic to endpoints that are outside of Google Cloud, such as on-premise servers or services running in other cloud providers.

## Architecture

This module creates the following resources:

- **Network Endpoint Group (NEG)**: A NEG is created for each zone specified in the `zones` variable. The NEG is configured with a `network_endpoint_type` of `NON_GCP_PRIVATE_IP_PORT`, which allows you to specify on-premise or other non-GCP IP addresses as backends.
- **Network Endpoints**: For each IP address in the `onpremise_ip_addresses` variable, a network endpoint is created in each of the specified zones. This allows the load balancer to send traffic to the same set of on-premise IPs from multiple zones, providing high availability.

## Usage

This example creates a hybrid NEG that forwards traffic to two on-premise IP addresses from two different zones.

```hcl
module "hybrid_neg" {
  source = "./path-to-this-module"

  name        = "my-hybrid-neg"
  network     = "projects/my-project/global/networks/my-network"
  zones       = ["us-central1-a", "us-central1-b"]
  onpremise_port = "443"
  onpremise_ip_addresses = [
    "10.0.1.10",
    "10.0.1.11"
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| `name` | The base name for the network endpoint group. The zone will be appended to this name. | `string` | n/a | yes |
| `network` | The self-link of the network to which the NEG belongs. | `string` | n/a | yes |
| `zones` | A list of zones where the network endpoint groups will be created. | `list(string)` | n/a | yes |
| `onpremise_port` | The port number of the on-premise endpoints. | `string` | n/a | yes |
| `onpremise_ip_addresses` | A list of on-premise IP addresses to be added as endpoints. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| `network_endpoint_groups` | A map of the created network endpoint groups, with the zone as the key. |
| `network_endpoints` | A map of the created network endpoints, with the zone and IP address as the key. | 
# Google Cloud Internal HTTP(S) Load Balancer Module

This Terraform module provisions a Google Cloud Internal HTTP(S) Load Balancer with a flexible and powerful set of features. It is designed to handle a wide range of use cases, from simple HTTP or HTTPS load balancing to complex setups with path-based routing and cross-project backends.

## Architecture

This module creates the following resources to build a fully functional internal load balancer:

- **Internal IP Address**: A reserved internal IP address that serves as a stable entry point for your internal traffic.
- **Backend Services**: The module creates regional backend services that manage how traffic is distributed to your backends. It supports both a default backend service and path-based backends, as well as cross-project backends.
- **Health Checks**: Health checks are configured to monitor the health of your backends, ensuring that traffic is only sent to healthy instances.
- **URL Map**: The URL map is the core of the load balancer's routing logic. It uses host and path rules to determine which backend service should handle a given request.
- **Target Proxies**:
    - An HTTPS target proxy is created if the load balancer is configured to handle HTTPS traffic on port 443. It uses a managed SSL certificate to encrypt traffic.
    - An HTTP target proxy is created if the load balancer is configured to handle HTTP traffic on port 80.
- **Forwarding Rules**: Forwarding rules connect the internal IP address to the target proxies, directing traffic to the appropriate proxy based on the port and protocol.

## Usage

### Simple HTTPS Load Balancer

This example creates a simple HTTPS load balancer that forwards all traffic to a single backend service.

```hcl
module "sep_ilb" {
  source = "./path-to-this-module"

  project_id      = "your-gcp-project-id"
  region          = "us-central1"
  network         = "projects/your-gcp-project-id/global/networks/your-network"
  subnetwork      = "projects/your-gcp-project-id/regions/us-central1/subnetworks/your-subnet"
  proxy_subnetwork = "projects/your-gcp-project-id/regions/us-central1/subnetworks/your-proxy-subnet"
  domain          = "example.com"
  address         = "10.0.0.12"
  port            = 443
  certificate_id  = "projects/your-gcp-project-id/locations/global/certificates/your-certificate"
  default_service = [
    "https://www.googleapis.com/compute/v1/projects/my-project/zones/us-central1-a/instanceGroups/default-group"
  ]
  default_hc_path = "/health"
  default_hc_port = 8080
  url_map = {}
}
```

### Load Balancer with Path-Based Routing

This example creates a load balancer that routes traffic to different backends based on the request path.

```hcl
module "sep_ilb" {
  source = "./path-to-this-module"

  project_id      = "your-gcp-project-id"
  region          = "us-central1"
  network         = "projects/your-gcp-project-id/global/networks/your-network"
  subnetwork      = "projects/your-gcp-project-id/regions/us-central1/subnetworks/your-subnet"
  proxy_subnetwork = "projects/your-gcp-project-id/regions/us-central1/subnetworks/your-proxy-subnet"
  domain          = "example.com"
  address         = "10.0.0.13"
  port            = 443
  certificate_id  = "projects/your-gcp-project-id/locations/global/certificates/your-certificate"
  default_service = [
    "https://www.googleapis.com/compute/v1/projects/my-project/zones/us-central1-a/instanceGroups/default-group"
  ]
  default_hc_path = "/health"
  default_hc_port = 8080

  url_map = {
    "/api/*" = {
      neg_links         = ["https://www.googleapis.com/compute/v1/projects/my-project/zones/us-central1-a/networkEndpointGroups/api-neg"]
      health_check_port = "8080"
      health_check_path = "/api/health"
    },
    "/static/*" = {
      neg_links         = ["https://www.googleapis.com/compute/v1/projects/my-project/zones/us-central1-a/networkEndpointGroups/static-neg"]
      health_check_port = "80"
      health_check_path = "/static/health"
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| `project_id` | The GCP project ID where the load balancer will be created. | `string` | n/a | yes |
| `region` | The region where the load balancer will be deployed. | `string` | n/a | yes |
| `network` | The network where the load balancer will be created. | `string` | n/a | yes |
| `subnetwork` | The subnetwork where the load balancer will be deployed. | `string` | n/a | yes |
| `proxy_subnetwork` | The proxy subnetwork where the load balancer will be created. | `string` | n/a | yes |
| `domain` | The domain name for the load balancer. | `string` | n/a | yes |
| `address` | The internal IP address for the load balancer. | `string` | n/a | yes |
| `port` | The port for the load balancer (e.g., 80 for HTTP, 443 for HTTPS). | `number` | `443` | no |
| `certificate_id` | The ID of the SSL/TLS certificate to use for HTTPS traffic. Required for HTTPS frontends. | `string` | `null` | no |
| `default_service` | A list of self-links to the instance groups or network endpoint groups for the default backend service. | `list(string)` | n/a | yes |
| `default_hc_path` | The health check path for the default backend service. | `string` | n/a | yes |
| `default_hc_port` | The health check port for the default backend service. | `string` | n/a | yes |
| `url_map` | A map where the keys are URL paths and the values are objects containing backend configuration. See the examples for more details. | `map(object({...}))` | n/a | yes |
| `enable_host_rewrite` | Whether to enable the host rewrite rule. | `bool` | `false` | no |
| `enable_https_redirects` | Whether to enable HTTPS redirects. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| `ip_address` | The internal IP address of the load balancer. |
| `name` | The name of the load balancer. | 
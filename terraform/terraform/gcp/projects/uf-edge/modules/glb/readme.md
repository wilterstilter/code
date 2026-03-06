# GCP Global External HTTPS Load Balancer

This Terraform module provisions a Google Cloud Global External HTTPS Load Balancer with a flexible and secure setup. It is designed to handle both simple and complex routing scenarios, including path-based routing to different backend services. It also includes features for automatic SSL certificate management, modern TLS enforcement, and health checking.

## Architecture

This module creates the following resources to build a fully functional HTTPS load balancer:

- **Global Static IP Address**: A reserved external IPv4 address that serves as the single entry point for all user traffic.
- **Google-Managed SSL Certificate**: An SSL certificate is automatically provisioned and managed by Google for the domain you provide. This ensures that communication between clients and the load balancer is encrypted.
- **SSL Policy**: Enforces a modern TLS profile, ensuring that only secure TLS versions and ciphers are used.
- **Forwarding Rule**: An HTTPS forwarding rule that directs traffic from the external IP address on port 443 to the HTTPS target proxy.
- **Target HTTPS Proxy**: The target proxy terminates SSL traffic and uses the URL map to route requests to the appropriate backend services.
- **URL Map**: The URL map is the core of the load balancer's routing logic. It uses host and path rules to determine which backend service should handle a given request. This module supports both a default backend service and path-based routing to different backends.
- **Backend Services**: The module creates a backend service for the default route and a separate backend service for each path-based route.
- **Health Check**: A single health check is created and used for all backend services.

## Usage

### Simple Load Balancer with Default Backend

This example creates a simple load balancer that forwards all traffic to a single backend service.

```hcl
module "glb" {
  source = "./path-to-this-module"

  domain          = "example.com"
  health_check_port = 80
  default_service = [
    "https://www.googleapis.com/compute/v1/projects/my-project/zones/us-central1-a/instanceGroups/default-group"
  ]
  security_policy_self_link = "projects/my-project/global/securityPolicies/my-policy"
  url_map = {}
}
```

### Load Balancer with Path-Based Routing

This example creates a load balancer that routes traffic to different backends based on the request path.

```hcl
module "glb" {
  source = "./path-to-this-module"

  domain          = "example.com"
  health_check_port = 80
  default_service = [
    "https://www.googleapis.com/compute/v1/projects/my-project/zones/us-central1-a/instanceGroups/default-group"
  ]
  security_policy_self_link = "projects/my-project/global/securityPolicies/my-policy"

  url_map = {
    "/api/*" = [
      "https://www.googleapis.com/compute/v1/projects/my-project/zones/us-central1-a/networkEndpointGroups/api-neg"
    ],
    "/static/*" = [
      "https://www.googleapis.com/compute/v1/projects/my-project/zones/us-central1-a/networkEndpointGroups/static-neg"
    ]
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| `domain` | The domain that will be added to the load balancer and SSL certificate. | `string` | n/a | yes |
| `health_check_port` | The port used for the HTTP health check. | `string` | n/a | yes |
| `default_service` | A list of self-links to the instance groups or network endpoint groups for the default backend service. | `list(string)` | n/a | yes |
| `url_map` | A map where the keys are URL paths and the values are lists of backend self-links. | `map(list(string))` | n/a | yes |
| `security_policy_self_link` | The self-link of the Cloud Armor security policy to apply to the backend services. | `string` | n/a | yes |
| `min_tls_version` | The minimum TLS version for the SSL policy. Allowed values: `TLS_1_2`, `TLS_1_3`. | `string` | `"TLS_1_2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| `ip_address` | The external IP address of the load balancer. |
| `name` | The name of the load balancer. | 
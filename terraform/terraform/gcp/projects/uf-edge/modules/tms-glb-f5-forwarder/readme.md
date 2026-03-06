# GCP Global HTTPS Load Balancer Module

This Terraform module provisions a Google Cloud Global External HTTPS Load Balancer with a flexible and secure setup. It is designed to handle both simple and complex routing scenarios, including path-based routing to different backend services. It also includes features for automatic SSL certificate management, modern TLS enforcement, and health checking.

## Architecture

This module creates the following resources to build a fully functional HTTPS load balancer:

- **Global Static IP Address**: A reserved external IPv4 address that serves as the single entry point for all user traffic.
- **Google-Managed SSL Certificate**: An SSL certificate is automatically provisioned and managed by Google for the domain you provide. This ensures that communication between clients and the load balancer is encrypted.
- **SSL Policy**: Enforces a modern TLS profile, ensuring that only secure TLS versions and ciphers are used.
- **Forwarding Rules**: Two forwarding rules are created:
    - An HTTPS forwarding rule that directs traffic from the external IP address on port 443 to the HTTPS target proxy.
    - An HTTP forwarding rule that redirects all incoming HTTP traffic on port 80 to HTTPS, ensuring that all communication is encrypted.
- **Target Proxies**:
    - An HTTPS target proxy that terminates SSL traffic and uses the URL map to route requests to the appropriate backend services.
    - An HTTP target proxy that handles the HTTP-to-HTTPS redirect.
- **URL Map**: The URL map is the core of the load balancer's routing logic. It uses host and path rules to determine which backend service should handle a given request. This module supports both a default backend service and path-based routing to different backends.
- **Backend Services**: Backend services define how the load balancer distributes traffic to the backends (instance groups or NEGs). This module allows you to configure a default backend service for all traffic, as well as multiple path-based backend services.
- **Health Checks**: Health checks are configured to monitor the health of your backends. This module creates a default health check for the default backend service and separate health checks for each path-based backend.

## Usage

### Simple Load Balancer

This example creates a simple load balancer that forwards all traffic to a single backend service.

```hcl
module "https_load_balancer" {
  source = "./path-to-this-module"

  domain          = "example.com"
  default_service = ["https://www.googleapis.com/compute/v1/projects/my-project/zones/us-central1-a/instanceGroups/example-group"]
}
```

### Load Balancer with Path-Based Routing

This example creates a load balancer that routes traffic to different backend services based on the request path.

```hcl
module "https_load_balancer" {
  source = "./path-to-this-module"

  domain          = "example.com"
  default_service = ["https://www.googleapis.com/compute/v1/projects/my-project/zones/us-central1-a/instanceGroups/default-group"]

  path_backends = {
    "/api/*" = {
      neg_links   = ["https://www.googleapis.com/compute/v1/projects/my-project/zones/us-central1-a/networkEndpointGroups/api-neg"]
      health_path = "/api/health"
      health_port = 8080
    },
    "/static/*" = {
      neg_links   = ["https://www.googleapis.com/compute/v1/projects/my-project/zones/us-central1-a/networkEndpointGroups/static-neg"]
      health_path = "/static/health"
      health_port = 80
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| `domain` | The domain that will be added to the load balancer and SSL certificate. | `string` | n/a | yes |
| `health_check_port` | Port used for health checks. | `string` | n/a | yes |
| `security_policy_self_link` | Link for the security policy | `string` | n/a | yes |
| `min_tls_version` | The minimum TLS version for the SSL policy. Allowed values: `TLS_1_2`, `TLS_1_3` | `string` | `"TLS_1_2"` | no |
| `default_service` | List of backend self-links for default (all traffic) routing | `list(string)` | `[]` | no |
| `path_backends` | A map of path rules to backend configurations. See the [Path-Based Routing](#load-balancer-with-path-based-routing) example for more details. | `map(object({...}))` | `{}` | no |
| `default_backend_timeout_sec` | Timeout (in seconds) for the default backend service. | `number` | `30` | no |
| `health_check_interval_sec` | Interval (seconds) between health checks. | `number` | `30` | no |
| `health_check_timeout_sec` | Timeout (seconds) for health check responses. | `number` | `30` | no |
| `health_check_healthy_threshold` | Number of consecutive successes for a backend to be considered healthy. | `number` | `2` | no |
| `health_check_unhealthy_threshold` | Number of consecutive failures for a backend to be considered unhealthy. | `number` | `2` | no |
| `default_max_rate_per_endpoint` | The maximum number of requests per second that can be sent to a single endpoint in the default backend service. | `number` | `80` | no |
| `default_backend_log_enabled` | Enable logging for the default backend service. | `bool` | `true` | no |
| `default_backend_log_sample_rate` | The fraction of requests to log for the default backend service. | `number` | `1.0` | no |

## Outputs

| Name | Description |
|------|-------------|
| `ip_address` | The external IP address of the load balancer. |
| `name` | The name of the load balancer. |

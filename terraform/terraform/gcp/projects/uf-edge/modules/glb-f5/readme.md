# GCP Global HTTPS Load Balancer for F5 Backends

This Terraform module provisions a Google Cloud Global External HTTPS Load Balancer specifically designed to work with F5 BIG-IP backends. It provides a secure and robust setup for exposing your F5-managed applications to the internet, with features like automatic SSL certificate management, modern TLS enforcement, and health checking.

## Architecture

This module creates the following resources to build a fully functional HTTPS load balancer:

- **Global Static IP Address**: A reserved external IPv4 address that serves as the single entry point for all user traffic.
- **Google-Managed SSL Certificate**: An SSL certificate is automatically provisioned and managed by Google for the domain you provide. This ensures that communication between clients and the load balancer is encrypted.
- **SSL Policy**: Enforces a modern TLS profile, ensuring that only secure TLS versions and ciphers are used.
- **Forwarding Rule**: An HTTPS forwarding rule that directs traffic from the external IP address on port 443 to the HTTPS target proxy.
- **Target HTTPS Proxy**: The target proxy terminates SSL traffic and uses the URL map to route requests to the backend service.
- **URL Map**: The URL map routes all incoming requests to a single backend service that is configured to work with your F5 backends.
- **Backend Service**: The backend service defines how the load balancer distributes traffic to your F5 backends. It is configured to use a TCP health check to monitor the health of the F5 instances.
- **Health Check**: A TCP health check is configured to monitor the health of your F5 backends on the specified port.

## Usage

This example creates a global external HTTPS load balancer that forwards all traffic to a set of F5 backends.

```hcl
module "glb_f5" {
  source = "./path-to-this-module"

  domain          = "f5.example.com"
  health_check_port = 443
  default_service = [
    "https://www.googleapis.com/compute/v1/projects/my-project/zones/us-central1-a/instanceGroups/f5-instance-group-1",
    "https://www.googleapis.com/compute/v1/projects/my-project/zones/us-central1-a/instanceGroups/f5-instance-group-2"
  ]
  security_policy_self_link = "projects/my-project/global/securityPolicies/my-f5-policy"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| `domain` | The domain that will be added to the load balancer and SSL certificate. | `string` | n/a | yes |
| `health_check_port` | The TCP port used for health checks. | `string` | n/a | yes |
| `default_service` | A list of self-links to the F5 instance groups or network endpoint groups. | `list(string)` | n/a | yes |
| `security_policy_self_link` | The self-link of the Cloud Armor security policy to apply to the backend service. | `string` | n/a | yes |
| `min_tls_version` | The minimum TLS version for the SSL policy. Allowed values: `TLS_1_2`, `TLS_1_3`. | `string` | `"TLS_1_2"` | no |
| `backend_timeout_sec` | The timeout (in seconds) for the backend service. | `number` | `120` | no |
| `max_rate_per_endpoint` | The maximum number of requests per second that can be sent to a single F5 endpoint. | `number` | `80` | no |

## Outputs

| Name | Description |
|------|-------------|
| `ip_address` | The external IP address of the load balancer. |
| `name` | The name of the load balancer. |
| `backend_service_name` | The name of the backend service. |

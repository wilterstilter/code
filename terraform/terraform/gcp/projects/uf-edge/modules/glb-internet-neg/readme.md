# GCP Global Load Balancer for Internet NEGs

This Terraform module provisions a Google Cloud Global External HTTPS Load Balancer designed to route traffic to **Internet Network Endpoint Groups (NEGs)**.

This module is ideal for scenarios where you need to use Google's global network and Cloud Armor security policies to protect backends that are hosted outside of GCP, such as services in Azure or on-premise data centers that are exposed via public IPs. It allows you to terminate SSL on GCP's edge and forward traffic to your external endpoints.

A key feature of this module is its ability to handle **multiple domain names**, which is useful for managing primary domains and redirect domains that all point to the same backend service.

## Architecture

This module creates the following resources:

- **Global Static IP Address**: A single, reserved external IPv4 address for the load balancer.
- **Google-Managed SSL Certificate**: A single SSL certificate that covers all domains provided in the `domains` variable.
- **DNS Authorizations**: A separate DNS authorization is created for each domain to enable Google to issue the certificate.
- **SSL Policy**: Enforces a modern TLS profile (defaults to `TLS_1_2` minimum).
- **Target HTTPS Proxy & URL Map**: Manages incoming requests and routes them to the backend service. The URL map is configured to accept traffic for all specified domains.
- **Backend Service**: A backend service configured to use an Internet NEG, which points to your external IP addresses. This module does **not** create health checks, as they are not supported for this backend type.

## Usage Example

This example creates a GLB for `app.example.com` and `redirect.example.com`, which both point to the same Internet NEG backend (e.g., an Azure public IP).

```hcl
module "glb_for_azure_app" {
  source = "./path-to-this-module"

  domains = [
    "app.example.com",
    "redirect.example.com"
  ]

  default_service = [
    "https://www.googleapis.com/compute/v1/projects/my-project/global/networkEndpointGroups/my-internet-neg"
  ]

  security_policy_self_link = "https://www.googleapis.com/compute/v1/projects/my-project/global/securityPolicies/my-web-policy"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| `domains` | A list of domain names for the load balancer and SSL certificate. The first domain will be used to generate resource names. | `list(string)` | n/a | yes |
| `default_service` | A list of self-links to the Internet Network Endpoint Groups. | `list(string)` | n/a | yes |
| `security_policy_self_link` | The self-link of the Cloud Armor security policy to apply to the backend service. | `string` | n/a | yes |
| `min_tls_version` | The minimum TLS version for the SSL policy. Allowed values: `TLS_1_2`, `TLS_1_3`. | `string` | `"TLS_1_2"` | no |
| `backend_timeout_sec` | The timeout (in seconds) for the backend service. | `number` | `120` | no |
| `max_rate_per_endpoint` | The maximum number of requests per second per backend endpoint. | `number` | `80` | no |

## Outputs

| Name | Description |
|------|-------------|
| `ip` | The external IP address of the load balancer. |
| `dns_authorization_cnames` | A map of domain names to the CNAME records required to prove domain ownership for the Google-managed SSL certificate. You must create these CNAME records in your DNS provider for each domain. | 

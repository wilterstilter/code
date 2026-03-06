# Google Cloud Internal Load Balancer (ILB) Terraform Module

This Terraform module creates a Google Cloud Internal HTTP(S) Load Balancer with a flexible and powerful set of features. It is designed to handle a wide range of use cases, from simple HTTP load balancing to complex setups with path-based routing, cross-project backends, and advanced traffic control features.

## Architecture

This module provisions the following resources to create a fully functional internal load balancer:

- **Internal IP Address**: A reserved internal IP address for each frontend, which serves as a stable entry point for your internal traffic.
- **Backend Services**: The module creates regional backend services that manage how traffic is distributed to your backends. It supports both local NEGs and cross-project backends.
- **Health Checks**: Health checks are configured to monitor the health of your backends, ensuring that traffic is only sent to healthy instances.
- **URL Map**: The URL map is the core of the load balancer's routing logic. It uses host and path rules to determine which backend service should handle a given request.
- **Target Proxies**:
    - An HTTPS target proxy is created for frontends configured to handle HTTPS traffic on port 443. It uses a managed SSL certificate to encrypt traffic.
    - An HTTP target proxy is created for frontends that handle HTTP traffic on port 80.
- **Forwarding Rules**: Forwarding rules connect the internal IP addresses to the target proxies, directing traffic to the appropriate proxy based on the port and protocol.
- **HTTP-to-HTTPS Redirect**: The module includes a separate set of resources to automatically redirect HTTP traffic to HTTPS, ensuring that all communication is encrypted.

## Usage

### Simple HTTP Load Balancer

This example creates a simple HTTP load balancer that forwards all traffic to a single backend service.

```hcl
module "ilb" {
  source = "./path-to-this-module"

  project_id = "your-gcp-project-id"
  region     = "us-central1"
  subnetwork = "projects/your-gcp-project-id/regions/us-central1/subnetworks/your-subnet"
  domain     = "example.com"

  frontends = {
    "app-http" = {
      ip_address      = "10.0.0.10"
      port            = 80
      default_backend = "app-backend"
    }
  }

  backends = {
    "app-backend" = {
      neg_links = [
        "projects/your-gcp-project-id/regions/us-central1/networkEndpointGroups/your-neg"
      ]
      health_check = "app-health-check"
    }
  }

  health_checks = {
    "app-health-check" = {
      path = "/health"
      port = 8080
    }
  }
}
```

### HTTPS Load Balancer with Path-Based Routing

This example creates an HTTPS load balancer that routes traffic to different backends based on the request path. It also includes an HTTP-to-HTTPS redirect.

```hcl
module "ilb" {
  source = "./path-to-this-module"

  project_id     = "your-gcp-project-id"
  region         = "us-central1"
  subnetwork     = "projects/your-gcp-project-id/regions/us-central1/subnetworks/your-subnet"
  domain         = "example.com"
  certificate_id = "projects/your-gcp-project-id/locations/global/certificates/your-certificate"

  frontends = {
    "app-https" = {
      ip_address             = "10.0.0.11"
      port                   = 443
      enable_https_redirects = true
      default_backend        = "default-backend"
      url_map = [
        {
          path    = "/api/*"
          backend = "api-backend"
        },
        {
          path    = "/static/*"
          backend = "static-backend"
        }
      ]
    }
  }

  backends = {
    "default-backend" = {
      neg_links    = ["projects/your-gcp-project-id/regions/us-central1/networkEndpointGroups/default-neg"]
      health_check = "default-health-check"
    },
    "api-backend" = {
      neg_links       = ["projects/your-gcp-project-id/regions/us-central1/networkEndpointGroups/api-neg"]
      health_check    = "api-health-check"
      security_policy = "projects/your-gcp-project-id/global/securityPolicies/your-policy"
    },
    "static-backend" = {
      neg_links    = ["projects/your-gcp-project-id/regions/us-central1/networkEndpointGroups/static-neg"]
      health_check = "static-health-check"
    }
  }

  health_checks = {
    "default-health-check" = {
      path = "/health"
      port = 8080
    },
    "api-health-check" = {
      path = "/api/health"
      port = 8080
    },
    "static-health-check" = {
      path = "/static/health"
      port = 80
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| `project_id` | The GCP project ID where the load balancer will be created. | `string` | n/a | yes |
| `region` | The region where the load balancer will be deployed. | `string` | n/a | yes |
| `subnetwork` | The subnetwork where the load balancer will be deployed. | `string` | n/a | yes |
| `domain` | The domain name for the load balancer. | `string` | n/a | yes |
| `certificate_id` | The ID of the SSL/TLS certificate to be used for HTTPS traffic. Required for HTTPS frontends. | `string` | n/a | no |
| `frontends` | A map of frontend configurations. See the examples for more details. | `map(object({...}))` | n/a | yes |
| `backends` | A map of backend service configurations. See the examples for more details. | `map(object({...}))` | n/a | yes |
| `health_checks` | A map of health check configurations. See the examples for more details. | `map(object({...}))` | n/a | yes |
| `http_redirect_lb_name` | The name for the HTTP to HTTPS redirect load balancer. | `string` | `"http-to-https-redirect-lb"` | no |

## Outputs

This module does not produce any outputs.
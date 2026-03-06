# Global NEG Backends Module

This module creates **global backend services** that can reference Network Endpoint Groups (NEGs) across **multiple regions**. This is designed for use with Global Load Balancers (GLB) that need to route traffic to GKE clusters in different regions.

## Features

- ✅ **Global Backend Services** - Works with external Global Load Balancers
- ✅ **Multi-Region NEGs** - Reference NEGs from any region
- ✅ **Global Health Checks** - HTTP, HTTPS, TCP, and gRPC support
- ✅ **Cloud Armor Integration** - Optional security policy attachment
- ✅ **CDN Support** - Optional Cloud CDN configuration
- ✅ **IAP Support** - Optional Identity-Aware Proxy
- ✅ **Logging** - Configurable access logging

## Architecture

```
                    Internet
                        │
                        ▼
              Global Load Balancer
              (uf-edge project)
                        │
                        ▼
              Global Backend Service  ← This module creates this
              (uf-compute project)
                        │
        ┌───────────────┼───────────────┐
        ▼               ▼               ▼
   NEG us-south1   NEG us-east4   NEG us-west1
        │               │               │
   GKE Cluster     GKE Cluster     GKE Cluster
```

## Usage

### Basic Example - Single Region

```hcl
module "global_backends" {
  source = "../modules/global-neg-backends"

  project_id  = "uf-compute-d"
  name_prefix = "parceltpapi"

  health_check_configs = {
    "default" = {
      protocol     = "HTTP"
      port         = 8080
      request_path = "/health"
    }
  }

  backend_service_configs = {
    "api" = {
      health_check_name = "default"
      port_name         = "http"
      
      backends = [
        {
          neg_self_link = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/zones/us-south1-a/networkEndpointGroups/parceltpapi-neg"
        }
      ]
    }
  }
}
```

### Multi-Region Example

```hcl
module "global_backends" {
  source = "../modules/global-neg-backends"

  project_id  = "uf-compute-d"
  name_prefix = "parceltpapi"

  health_check_configs = {
    "default" = {
      protocol     = "HTTP"
      port         = 8080
      request_path = "/health"
    }
  }

  backend_service_configs = {
    "api" = {
      health_check_name = "default"
      port_name         = "http"
      timeout_sec       = 60
      
      # NEGs from multiple regions
      backends = [
        {
          neg_self_link         = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/zones/us-south1-a/networkEndpointGroups/parceltpapi-neg"
          balancing_mode        = "RATE"
          max_rate_per_endpoint = 100
          capacity_scaler       = 1.0
        },
        {
          neg_self_link         = "https://www.googleapis.com/compute/v1/projects/uf-compute-d/zones/us-east4-a/networkEndpointGroups/parceltpapi-neg"
          balancing_mode        = "RATE"
          max_rate_per_endpoint = 100
          capacity_scaler       = 1.0
        }
      ]
    }
  }
}
```

### With Cloud Armor Security Policy

```hcl
module "global_backends" {
  source = "../modules/global-neg-backends"

  project_id  = "uf-compute-d"
  name_prefix = "parceltpapi"

  health_check_configs = {
    "default" = {
      protocol     = "HTTP"
      port         = 8080
      request_path = "/health"
    }
  }

  backend_service_configs = {
    "api" = {
      health_check_name = "default"
      security_policy   = "https://www.googleapis.com/compute/v1/projects/uf-edge-d/global/securityPolicies/web-policy"
      
      backends = [
        {
          neg_self_link = dependency.gke.outputs.neg_self_links["parceltpapi"]
        }
      ]
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `project_id` | GCP project ID | `string` | - | yes |
| `name_prefix` | Prefix for resource names | `string` | - | yes |
| `load_balancing_scheme` | Load balancing scheme | `string` | `"EXTERNAL_MANAGED"` | no |
| `health_check_configs` | Health check configurations | `map(object)` | `{}` | no |
| `backend_service_configs` | Backend service configurations | `map(object)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `health_check_self_links` | Map of health check names to self links |
| `backend_service_self_links` | Map of backend service names to self links |
| `backend_service_ids` | Map of backend service names to IDs |
| `backend_service_names` | Map of logical names to actual resource names |

## Integration with uf-edge GLB

Reference these backend services from your GLB in uf-edge:

```hcl
# In uf-edge GLB terragrunt.hcl
dependency "backends" {
  config_path = "../../../../uf-compute/environments/dev/global-neg-backends"
}

inputs = {
  default_cross_project_backend = dependency.backends.outputs.backend_service_self_links["api"]
}
```

## Difference from neg-backends Module

| Feature | neg-backends (Regional) | global-neg-backends (This Module) |
|---------|------------------------|-----------------------------------|
| Backend Type | `google_compute_region_backend_service` | `google_compute_backend_service` |
| Scope | Single region | Global (multi-region) |
| Load Balancer | Internal LB | External GLB |
| NEG Support | Same region only | Any region |
| Use Case | Internal services | Internet-facing APIs |

# Cross-Region Load Balancer Module

This Terraform module creates a **Global HTTPS Load Balancer** in Google Cloud Platform that can distribute traffic across regional Network Endpoint Groups (NEGs) in multiple regions (e.g., `us-south1`, `us-east4`).

## Features

- ✅ **Cross-Region Load Balancing**: Distributes traffic across NEGs in multiple regions
- ✅ **Global Health Checks**: Monitors backend health before routing traffic
- ✅ **Path-Based Routing**: Routes traffic based on URL paths
- ✅ **Session Affinity**: Maintains user sessions with cookie-based affinity
- ✅ **HTTPS Support**: With SSL certificate management via Certificate Manager or Google-managed certificates
- ✅ **HTTP to HTTPS Redirect**: Automatic redirect from HTTP to HTTPS
- ✅ **Security Policies**: Supports Cloud Armor security policies
- ✅ **CORS Support**: Optional CORS configuration
- ✅ **Logging**: Request logging with configurable sample rates

## Architecture

```
                          ┌─────────────────────┐
                          │   Global Frontend   │
                          │   (External IP)     │
                          └──────────┬──────────┘
                                     │
                          ┌──────────▼──────────┐
                          │   HTTPS Proxy       │
                          │   + SSL Certificate │
                          └──────────┬──────────┘
                                     │
                          ┌──────────▼──────────┐
                          │   URL Map           │
                          │   (Path Routing)    │
                          └──────────┬──────────┘
                                     │
                ┌────────────────────┼────────────────────┐
                │                    │                    │
         ┌──────▼──────┐      ┌──────▼──────┐    ┌──────▼──────┐
         │  Backend 1   │      │  Backend 2   │    │  Backend N   │
         │ (Global BS)  │      │ (Global BS)  │    │ (Global BS)  │
         └──────┬───────┘      └──────┬───────┘    └──────┬───────┘
                │                     │                    │
    ┌───────────┼─────────┐          │          ┌─────────┼──────────┐
    │           │         │          │          │         │          │
┌───▼───┐  ┌───▼───┐ ┌───▼───┐  ┌───▼───┐ ┌───▼───┐ ┌───▼───┐  ┌───▼───┐
│ NEG   │  │ NEG   │ │ NEG   │  │ NEG   │ │ NEG   │ │ NEG   │  │ NEG   │
│South1 │  │East4  │ │West1  │  │East4  │ │South1 │ │East1  │  │Europe │
└───────┘  └───────┘ └───────┘  └───────┘ └───────┘ └───────┘  └───────┘
   Region      Region    Region     Region    Region    Region    Region
```

## Key Differences from ILB Module

| Feature | ILB Module | Cross-Region LB Module |
|---------|-----------|----------------------|
| **Scope** | Regional | Global |
| **Load Balancer Type** | Internal (INTERNAL_MANAGED) | External (EXTERNAL_MANAGED) |
| **IP Address** | Regional internal IP | Global external IP |
| **Backend Service** | Regional backend service | Global backend service |
| **Health Check** | Regional health check | Global health check |
| **Cross-Region Support** | ❌ No (single region only) | ✅ Yes (multi-region) |
| **NEG Support** | Regional NEGs only | NEGs from any region |
| **Use Case** | Internal services within VPC | Public-facing services |

## Answer to Your Questions

### Should you use global backends or regional NEGs?

**Use Global Backend Services with Regional NEGs** - This is the correct approach:

1. **Global Backend Service** (`google_compute_backend_service`):
   - This is the "container" that manages traffic distribution
   - It has a global scope and can route to NEGs in any region
   - Similar to how GLB (Global Load Balancer) works

2. **Regional NEGs** (Network Endpoint Groups):
   - These are the actual endpoints in each region (us-south1, us-east4, etc.)
   - Each NEG is regional and contains the actual backends (Cloud Run, GKE pods, VMs, etc.)
   - The global backend service references these regional NEGs

**Example**:
```hcl
backends = {
  api-backend = {
    neg_links = [
      "projects/my-project/regions/us-south1/networkEndpointGroups/api-neg-south1",
      "projects/my-project/regions/us-east4/networkEndpointGroups/api-neg-east4"
    ]
    health_check = "api-health-check"
  }
}
```

The global backend service will:
- Send traffic to NEGs in both regions
- Use health checks to determine which endpoints are healthy
- Automatically route traffic away from unhealthy regions
- Distribute load across all healthy endpoints

## Usage Example

```hcl
module "cross_region_lb" {
  source = "./modules/cross-region-lb"

  project_id = "my-gcp-project"
  domain     = "example.com"

  # Frontend configuration
  frontends = {
    api = {
      port                 = 443
      default_backend      = "api-backend"
      enable_http_redirect = true
      enable_cors          = true
      url_map = [
        {
          path                = "/api/v1"
          backend             = "api-v1-backend"
          priority            = 1
          path_prefix_rewrite = false
        },
        {
          path                = "/api/v2"
          backend             = "api-v2-backend"
          priority            = 2
          path_prefix_rewrite = true
        }
      ]
      forbidden_uris = [
        {
          path_pattern = "/admin"
          priority     = 1
          status_code  = 403
          message      = "Forbidden"
        }
      ]
    }
  }

  # Backend configuration with cross-region NEGs
  backends = {
    api-v1-backend = {
      neg_links = [
        "projects/my-project/regions/us-south1/networkEndpointGroups/api-v1-south1",
        "projects/my-project/regions/us-east4/networkEndpointGroups/api-v1-east4"
      ]
      health_check          = "http-health-check"
      protocol              = "HTTP"
      port_name             = "http"
      timeout_sec           = 30
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 100
      capacity_scaler       = 1.0
      session_affinity      = "GENERATED_COOKIE"
      security_policy       = "my-cloud-armor-policy"
    }
    api-v2-backend = {
      neg_links = [
        "projects/my-project/regions/us-south1/networkEndpointGroups/api-v2-south1",
        "projects/my-project/regions/us-east4/networkEndpointGroups/api-v2-east4"
      ]
      health_check          = "http-health-check"
      protocol              = "HTTP"
      timeout_sec           = 45
    }
  }

  # Health check configuration
  health_checks = {
    http-health-check = {
      protocol            = "HTTP"
      path                = "/health"
      port                = 8080
      check_interval_sec  = 10
      timeout_sec         = 5
      healthy_threshold   = 2
      unhealthy_threshold = 2
    }
  }

  # SSL certificate configuration (using Certificate Manager)
  certificate_id = "projects/my-project/locations/global/certificates/my-cert"

  # Or use managed SSL certificate
  # create_ssl_certificate = true
  # ssl_certificate_domains = ["api.example.com"]
}
```

## Health Check Behavior

The module implements **active health checking**:

1. **Health Check Probe**: The load balancer sends periodic health check requests to each NEG endpoint
2. **Healthy Threshold**: Endpoint marked healthy after 2 consecutive successful checks (configurable)
3. **Unhealthy Threshold**: Endpoint marked unhealthy after 2 consecutive failed checks (configurable)
4. **Traffic Routing**: Traffic is only sent to healthy endpoints
5. **Regional Failover**: If all endpoints in one region become unhealthy, traffic automatically routes to healthy regions

Example health check configuration:
```hcl
health_checks = {
  my-health-check = {
    protocol            = "HTTP"    # or HTTPS, TCP
    path                = "/health" # Health check endpoint
    port                = 8080      # Port to check
    check_interval_sec  = 10        # Check every 10 seconds
    timeout_sec         = 5         # Wait 5 seconds for response
    healthy_threshold   = 2         # 2 successes = healthy
    unhealthy_threshold = 2         # 2 failures = unhealthy
  }
}
```

## Path-Based Routing

The module supports sophisticated path-based routing:

```hcl
url_map = [
  {
    path                = "/api/v1"
    backend             = "api-v1-backend"
    priority            = 1
    path_prefix_rewrite = false
  },
  {
    path                = "/api/v2"
    backend             = "api-v2-backend"
    priority            = 2
    path_prefix_rewrite = true  # Rewrites "/api/v2/users" to "/users"
  },
  {
    path         = "/legacy"
    backend      = "legacy-backend"
    priority     = 3
    host_rewrite = true  # Rewrites host header
  }
]
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `project_id` | GCP project ID | `string` | Yes |
| `domain` | Base domain name | `string` | Yes |
| `frontends` | Frontend configurations | `map(object)` | Yes |
| `backends` | Backend service configurations | `map(object)` | Yes |
| `health_checks` | Health check configurations | `map(object)` | Yes |
| `certificate_id` | Certificate Manager certificate ID | `string` | No |
| `ssl_certificate_ids` | List of SSL certificate IDs | `list(string)` | No |
| `create_ssl_certificate` | Create managed SSL certificate | `bool` | No |
| `ssl_certificate_domains` | Domains for managed certificate | `list(string)` | No |

## Outputs

| Name | Description |
|------|-------------|
| `frontend_ip_addresses` | Map of frontend IP addresses |
| `backend_service_ids` | Map of backend service IDs |
| `health_check_ids` | Map of health check IDs |
| `url_map_id` | URL map ID |

## Best Practices

1. **Use Multiple Regions**: Deploy NEGs in at least 2 regions for high availability
2. **Configure Health Checks**: Always configure health checks to ensure traffic only goes to healthy backends
3. **Set Appropriate Timeouts**: Configure `timeout_sec` based on your application's response time
4. **Enable Logging**: Keep logging enabled for debugging and monitoring
5. **Use Cloud Armor**: Apply security policies to protect against DDoS and common attacks
6. **Session Affinity**: Use `GENERATED_COOKIE` for stateful applications
7. **Capacity Planning**: Set `max_rate_per_endpoint` based on your backend capacity

## Monitoring

Monitor your cross-region load balancer using these Cloud Monitoring metrics:

- `loadbalancing.googleapis.com/https/request_count` - Total requests
- `loadbalancing.googleapis.com/https/backend_latencies` - Backend latency
- `loadbalancing.googleapis.com/https/backend_request_count` - Requests per backend
- `loadbalancing.googleapis.com/https/total_latencies` - Total latency including LB
- `compute.googleapis.com/instance/network/received_bytes_count` - Traffic volume

## Troubleshooting

### Traffic not distributing across regions
- Verify NEG links are correct and point to NEGs in different regions
- Check health check status in Cloud Console
- Ensure backends in both regions are healthy

### Health checks failing
- Verify the health check path exists and returns 200 OK
- Check firewall rules allow health check traffic from `35.191.0.0/16` and `130.211.0.0/22`
- Verify the health check port is correct

### SSL certificate errors
- If using Certificate Manager, verify the certificate is in ACTIVE state
- If using managed certificates, ensure DNS is properly configured
- Check that domains match the certificate SANs

## License

Apache 2.0

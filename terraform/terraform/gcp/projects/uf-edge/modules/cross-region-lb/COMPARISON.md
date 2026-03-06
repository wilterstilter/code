# Comparison: ILB vs Cross-Region LB vs Global NEG Backends

This document compares the three load balancing modules to help you choose the right one for your use case.

## Module Comparison Table

| Feature | ILB Module | Cross-Region LB Module | Global NEG Backends Module |
|---------|-----------|----------------------|----------------------------|
| **Purpose** | Regional internal load balancing | Global external cross-region load balancing | Backend service creation only |
| **Scope** | Regional | Global | Global |
| **Load Balancer Type** | INTERNAL_MANAGED | EXTERNAL_MANAGED | N/A (backends only) |
| **IP Address** | Regional internal IP | Global external IP | N/A |
| **Accessibility** | Internal VPC only | Internet-facing | N/A |
| **Creates Full LB** | ✅ Yes | ✅ Yes | ❌ No (backends only) |
| **Creates Frontend** | ✅ Yes | ✅ Yes | ❌ No |
| **Creates URL Map** | ✅ Yes | ✅ Yes | ❌ No |
| **Creates Backends** | ✅ Yes | ✅ Yes | ✅ Yes |
| **Cross-Region Support** | ❌ No | ✅ Yes | ✅ Yes |
| **Path-Based Routing** | ✅ Yes | ✅ Yes | N/A |
| **Health Checks** | ✅ Regional | ✅ Global | ✅ Global |
| **SSL Termination** | ✅ Yes | ✅ Yes | N/A |
| **HTTP to HTTPS Redirect** | ✅ Yes | ✅ Yes | N/A |

## Architecture Comparison

### ILB Module (Regional Internal)
```
VPC Network (Single Region: us-south1)
├── Internal IP: 10.0.0.10
├── Regional LB (INTERNAL_MANAGED)
│   ├── Regional Backend Service
│   │   ├── NEG in us-south1 (same region)
│   │   └── NEG in us-south1 (same region)
│   └── Regional Health Check
└── Internal Clients Only
```

### Cross-Region LB Module (Global External)
```
Internet (Global)
├── Global IP: 34.120.1.2
├── Global HTTPS LB (EXTERNAL_MANAGED)
│   ├── Global Backend Service
│   │   ├── NEG in us-south1 ✅
│   │   ├── NEG in us-east4 ✅
│   │   ├── NEG in europe-west1 ✅
│   │   └── NEG in asia-east1 ✅
│   ├── Global Health Check (checks all regions)
│   └── Global URL Map (path-based routing)
└── Public Internet Clients
```

### Global NEG Backends Module (Backend Services Only)
```
No Frontend (used by other LBs)
├── Global Backend Service #1
│   ├── NEG in us-south1
│   └── NEG in us-east4
├── Global Backend Service #2
│   ├── NEG in europe-west1
│   └── NEG in asia-east1
└── Global Health Checks
└── Used by: Cross-Region LB or other GLBs
```

## When to Use Each Module

### Use ILB Module When:
- ✅ Your service is **internal-only** (not exposed to internet)
- ✅ All backends are in **one region**
- ✅ You need load balancing within a VPC
- ✅ You want to use RFC 1918 private IPs
- ✅ Example: Internal API gateway, internal microservices

### Use Cross-Region LB Module When:
- ✅ Your service is **internet-facing** (public)
- ✅ Backends are in **multiple regions**
- ✅ You need **global availability** and **disaster recovery**
- ✅ You want automatic failover between regions
- ✅ You need path-based routing with cross-region backends
- ✅ Example: Public API, SaaS application, multi-region web app

### Use Global NEG Backends Module When:
- ✅ You only need to create **backend services** without a full LB
- ✅ You're using the backends with an **existing load balancer** (created elsewhere)
- ✅ You want to **share backends** across multiple load balancers
- ✅ You're building a complex multi-LB architecture
- ✅ Example: Shared backend pool, microservices with multiple entry points

## Traffic Flow Comparison

### ILB (Regional)
```
Client (in VPC)
  → Internal IP (10.0.0.10) in us-south1
  → Regional Backend Service in us-south1
  → NEG in us-south1
  → Backend Instance in us-south1
```

### Cross-Region LB (Global)
```
Client (Internet, e.g., from Europe)
  → Global IP (34.120.1.2)
  → Google's Global Frontend (nearest PoP to client)
  → Global Backend Service
  → Health Check determines healthy regions
  → Route to nearest healthy NEG:
      Option A: NEG in europe-west1 (closest)
      Option B: NEG in us-east4 (if europe unhealthy)
      Option C: NEG in us-south1 (fallback)
  → Backend Instance
```

## Health Check Behavior

### ILB
- **Scope**: Regional health check
- **Checks**: Only endpoints within the same region
- **Failover**: Within region only (to other NEGs in same region)

### Cross-Region LB
- **Scope**: Global health check
- **Checks**: All endpoints across all regions
- **Failover**: Automatic cross-region failover
- **Intelligent Routing**: Routes to nearest healthy region

### Global NEG Backends
- **Scope**: Global health check
- **Checks**: All endpoints across all regions
- **Used By**: The LB that consumes these backends

## Configuration Examples

### ILB Configuration
```hcl
module "ilb" {
  source = "./modules/ilb"
  
  region     = "us-south1"  # Single region
  subnetwork = "subnet-1"   # Regional subnet
  
  backends = {
    api = {
      neg_links = [
        # All NEGs must be in us-south1
        "projects/.../regions/us-south1/networkEndpointGroups/neg-1",
        "projects/.../regions/us-south1/networkEndpointGroups/neg-2"
      ]
    }
  }
}
```

### Cross-Region LB Configuration
```hcl
module "cross_region_lb" {
  source = "./modules/cross-region-lb"
  
  # No region specified - it's global!
  
  backends = {
    api = {
      neg_links = [
        # NEGs from multiple regions ✅
        "projects/.../regions/us-south1/networkEndpointGroups/neg-south1",
        "projects/.../regions/us-east4/networkEndpointGroups/neg-east4",
        "projects/.../regions/europe-west1/networkEndpointGroups/neg-europe"
      ]
    }
  }
}
```

### Global NEG Backends Configuration
```hcl
module "global_backends" {
  source = "./modules/global-neg-backends"
  
  backend_service_configs = {
    api-backend = {
      neg_names = [
        "projects/.../regions/us-south1/networkEndpointGroups/neg-south1",
        "projects/.../regions/us-east4/networkEndpointGroups/neg-east4"
      ]
      health_check_name = "http-check"
    }
  }
}

# Then use these backends in another LB
resource "google_compute_url_map" "my_lb" {
  default_service = module.global_backends.backend_service_self_links["api-backend"]
}
```

## Cost Considerations

### ILB
- **Cost**: Lower (regional only)
- **Egress**: Regional egress rates
- **Best for**: Cost-sensitive internal services

### Cross-Region LB
- **Cost**: Higher (global distribution + cross-region egress)
- **Egress**: Cross-region and internet egress rates
- **Best for**: Production services needing HA and global reach

### Global NEG Backends
- **Cost**: Only backend service costs (no frontend)
- **Egress**: Depends on actual traffic routing
- **Best for**: Shared backend scenarios

## Recommendations

### For Your Use Case (Cross-Region API Load Balancing):

**Use the Cross-Region LB Module** ✅

Because you need:
1. ✅ Traffic distribution between us-south1 and us-east4
2. ✅ Health checks to identify resource health
3. ✅ Path-based routing
4. ✅ Complete load balancer solution (frontend + backend)

**Not Global NEG Backends Module** because:
- ❌ It doesn't create the frontend (URL map, target proxy, forwarding rule)
- ❌ It's meant for creating backends only, to be consumed by other LBs

**Configuration Example for Your Case:**
```hcl
module "api_cross_region_lb" {
  source = "./modules/cross-region-lb"
  
  project_id = "my-project"
  domain     = "api.example.com"
  
  frontends = {
    api = {
      port            = 443
      default_backend = "api-backend"
      url_map = [
        {
          path     = "/api/v1"
          backend  = "api-backend"
          priority = 1
        }
      ]
    }
  }
  
  backends = {
    api-backend = {
      # ✅ NEGs from both us-south1 and us-east4
      neg_links = [
        "projects/my-project/regions/us-south1/networkEndpointGroups/api-neg-south1",
        "projects/my-project/regions/us-east4/networkEndpointGroups/api-neg-east4"
      ]
      health_check = "api-health-check"
    }
  }
  
  health_checks = {
    api-health-check = {
      protocol = "HTTP"
      path     = "/health"
      port     = 8080
    }
  }
  
  certificate_id = "projects/my-project/locations/global/certificates/api-cert"
}
```

This will:
- ✅ Create a global HTTPS load balancer
- ✅ Distribute traffic between us-south1 and us-east4
- ✅ Use health checks to ensure traffic goes only to healthy endpoints
- ✅ Support path-based routing
- ✅ Automatically failover if one region becomes unhealthy

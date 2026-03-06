# Quick Start Guide - Cross-Region Load Balancer

This guide will help you get started with the cross-region load balancer module in 5 minutes.

## Prerequisites

Before you begin, ensure you have:

- ✅ GCP project with billing enabled
- ✅ Terraform >= 1.0 installed
- ✅ GCP credentials configured (`gcloud auth application-default login`)
- ✅ **Network Endpoint Groups (NEGs)** already created in target regions
- ✅ SSL certificate (Certificate Manager or Google-managed cert)

## Step 1: Verify Your NEGs

First, verify your NEGs exist in the target regions:

```bash
# List NEGs in us-south1
gcloud compute network-endpoint-groups list \
  --filter="region:us-south1" \
  --project=YOUR_PROJECT_ID

# List NEGs in us-east4
gcloud compute network-endpoint-groups list \
  --filter="region:us-east4" \
  --project=YOUR_PROJECT_ID
```

Example output:
```
NAME                LOCATION     ENDPOINT_TYPE  SIZE
api-neg-south1      us-south1    SERVERLESS     3
api-neg-east4       us-east4     SERVERLESS     3
```

## Step 2: Get Your NEG Self-Links

Get the full self-link for each NEG:

```bash
# Get NEG self-link for us-south1
gcloud compute network-endpoint-groups describe api-neg-south1 \
  --region=us-south1 \
  --project=YOUR_PROJECT_ID \
  --format="value(selfLink)"

# Get NEG self-link for us-east4
gcloud compute network-endpoint-groups describe api-neg-east4 \
  --region=us-east4 \
  --project=YOUR_PROJECT_ID \
  --format="value(selfLink)"
```

Example output:
```
projects/my-project/regions/us-south1/networkEndpointGroups/api-neg-south1
projects/my-project/regions/us-east4/networkEndpointGroups/api-neg-east4
```

## Step 3: Create Your Configuration

Create a new directory and `main.tf`:

```bash
mkdir my-cross-region-lb
cd my-cross-region-lb
```

Create `main.tf`:

```hcl
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
  }
}

provider "google" {
  project = "YOUR_PROJECT_ID"
}

module "cross_region_lb" {
  source = "../path/to/modules/cross-region-lb"

  project_id = "YOUR_PROJECT_ID"
  domain     = "example.com"

  # Frontend configuration
  frontends = {
    api = {
      port                 = 443
      default_backend      = "api-backend"
      enable_http_redirect = true
      enable_cors          = false
      
      url_map = [
        {
          path     = "/"
          backend  = "api-backend"
          priority = 1
        }
      ]
      
      forbidden_uris = []
    }
  }

  # Backend with NEGs from multiple regions
  backends = {
    api-backend = {
      neg_links = [
        "projects/YOUR_PROJECT_ID/regions/us-south1/networkEndpointGroups/api-neg-south1",
        "projects/YOUR_PROJECT_ID/regions/us-east4/networkEndpointGroups/api-neg-east4"
      ]
      
      health_check          = "http-health-check"
      protocol              = "HTTP"
      port_name             = "http"
      timeout_sec           = 30
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 100
      capacity_scaler       = 1.0
      session_affinity      = "GENERATED_COOKIE"
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

  # SSL certificate (choose one option):
  
  # Option 1: Certificate Manager (recommended)
  certificate_id = "projects/YOUR_PROJECT_ID/locations/global/certificates/YOUR_CERT"
  
  # Option 2: Google-managed SSL certificate
  # create_ssl_certificate = true
  # ssl_certificate_domains = ["api.example.com"]
}

# Outputs
output "load_balancer_ip" {
  description = "The global IP address for your load balancer"
  value       = module.cross_region_lb.frontend_ip_addresses
}

output "backend_services" {
  description = "Backend service details"
  value       = module.cross_region_lb.backend_service_ids
}
```

**Important**: Replace the following placeholders:
- `YOUR_PROJECT_ID` - Your GCP project ID
- `example.com` - Your domain
- `api-neg-south1` and `api-neg-east4` - Your actual NEG names
- `YOUR_CERT` - Your certificate name

## Step 4: Initialize and Plan

```bash
# Initialize Terraform
terraform init

# Review the plan
terraform plan
```

Expected output:
```
Plan: 10 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + load_balancer_ip = {
      + api = "34.120.1.2"
    }
```

## Step 5: Apply the Configuration

```bash
terraform apply
```

Type `yes` when prompted.

Wait for the resources to be created (typically 3-5 minutes).

## Step 6: Get Your Load Balancer IP

```bash
terraform output load_balancer_ip
```

Example output:
```
{
  "api" = "34.120.1.2"
}
```

## Step 7: Configure DNS

Create an A record in your DNS provider:

```
Type: A
Name: api
Value: 34.120.1.2
TTL: 300
```

Result: `api.example.com` → `34.120.1.2`

## Step 8: Test Your Load Balancer

Wait a few minutes for DNS propagation and SSL certificate provisioning, then test:

```bash
# Test health check
curl -v https://api.example.com/health

# Test HTTP to HTTPS redirect
curl -I http://api.example.com

# Test with verbose output
curl -v https://api.example.com/
```

Expected output:
```
* Connected to api.example.com (34.120.1.2) port 443
* SSL certificate verify ok
> GET / HTTP/1.1
> Host: api.example.com
> 
< HTTP/1.1 200 OK
< date: Thu, 16 Jan 2026 10:30:00 GMT
< content-type: application/json
< set-cookie: GCLB=abcdef123456; path=/; HttpOnly; Secure
< strict-transport-security: max-age=31536000; includeSubDomains; preload
```

## Step 9: Verify Cross-Region Distribution

Check that traffic is being distributed across regions:

```bash
# View load balancer metrics in Cloud Console
gcloud compute backend-services describe gclb-example-com-api-backend \
  --global \
  --format="table(
    name,
    backends.group,
    backends.balancingMode,
    backends.capacityScaler
  )"
```

## Step 10: Monitor Health Checks

```bash
# Check health check status
gcloud compute backend-services get-health gclb-example-com-api-backend \
  --global
```

Expected output:
```
backend: projects/YOUR_PROJECT_ID/regions/us-south1/networkEndpointGroups/api-neg-south1
status:
  healthStatus:
  - instance: 10.1.1.1:8080
    healthState: HEALTHY
  - instance: 10.1.1.2:8080
    healthState: HEALTHY

backend: projects/YOUR_PROJECT_ID/regions/us-east4/networkEndpointGroups/api-neg-east4
status:
  healthStatus:
  - instance: 10.2.1.1:8080
    healthState: HEALTHY
  - instance: 10.2.1.2:8080
    healthState: HEALTHY
```

## Troubleshooting

### Issue: SSL certificate not provisioning

**Solution**: If using Google-managed certificates, ensure:
1. DNS is properly configured (A record points to LB IP)
2. Wait 15-30 minutes for certificate provisioning
3. Check certificate status:
   ```bash
   gcloud compute ssl-certificates list
   ```

### Issue: Health checks failing

**Solution**: Verify:
1. Your backend has a `/health` endpoint that returns `200 OK`
2. The health check port (8080) is correct
3. Firewall rules allow health check traffic from `35.191.0.0/16` and `130.211.0.0/22`

Example health check endpoint (Python Flask):
```python
@app.route('/health')
def health():
    return {'status': 'healthy'}, 200
```

### Issue: 502 Bad Gateway

**Solution**: This usually means backends are unhealthy:
1. Check health check status (Step 10)
2. Verify NEGs have active endpoints
3. Check backend logs for errors

### Issue: Traffic not distributing across regions

**Solution**:
1. Verify both regions' NEGs are healthy
2. Check `capacity_scaler` is set correctly (1.0 = 100%)
3. Verify `max_rate_per_endpoint` isn't too high

## Next Steps

Now that your basic load balancer is working:

1. **Add More Regions**: Add NEGs in additional regions for global coverage
2. **Configure Path-Based Routing**: Route different paths to different backends
3. **Enable Cloud Armor**: Add DDoS protection and WAF rules
4. **Set Up Monitoring**: Create Cloud Monitoring dashboards
5. **Configure Alerting**: Get notified when health checks fail
6. **Test Failover**: Simulate region failure and verify automatic failover

## Example: Adding Path-Based Routing

Update your `frontends` configuration:

```hcl
frontends = {
  api = {
    port                 = 443
    default_backend      = "api-default"
    enable_http_redirect = true
    
    url_map = [
      {
        path     = "/api/v1"
        backend  = "api-v1-backend"
        priority = 1
      },
      {
        path     = "/api/v2"
        backend  = "api-v2-backend"
        priority = 2
      },
      {
        path     = "/"
        backend  = "api-default"
        priority = 3
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
```

Then add corresponding backends:

```hcl
backends = {
  api-v1-backend = {
    neg_links = [
      "projects/YOUR_PROJECT_ID/regions/us-south1/networkEndpointGroups/api-v1-south1",
      "projects/YOUR_PROJECT_ID/regions/us-east4/networkEndpointGroups/api-v1-east4"
    ]
    health_check = "http-health-check"
  }
  
  api-v2-backend = {
    neg_links = [
      "projects/YOUR_PROJECT_ID/regions/us-south1/networkEndpointGroups/api-v2-south1",
      "projects/YOUR_PROJECT_ID/regions/us-east4/networkEndpointGroups/api-v2-east4"
    ]
    health_check = "http-health-check"
  }
  
  api-default = {
    neg_links = [
      "projects/YOUR_PROJECT_ID/regions/us-south1/networkEndpointGroups/api-default-south1",
      "projects/YOUR_PROJECT_ID/regions/us-east4/networkEndpointGroups/api-default-east4"
    ]
    health_check = "http-health-check"
  }
}
```

Apply the changes:

```bash
terraform apply
```

Test the routing:

```bash
curl https://api.example.com/api/v1/users    # Routes to api-v1-backend
curl https://api.example.com/api/v2/orders   # Routes to api-v2-backend
curl https://api.example.com/health          # Routes to api-default
curl https://api.example.com/admin           # Returns 403 Forbidden
```

## Clean Up

When you're done testing:

```bash
terraform destroy
```

Type `yes` when prompted to delete all resources.

## Getting Help

- 📖 Read the [full README](./README.md)
- 🏗️ Check [ARCHITECTURE.md](./ARCHITECTURE.md) for detailed architecture
- 🔄 See [COMPARISON.md](./COMPARISON.md) to compare with other modules
- 💡 Review [examples/complete](./examples/complete) for advanced usage
- 🐛 Check [Troubleshooting section](#troubleshooting) above

## Summary

You've successfully created a cross-region load balancer that:
- ✅ Distributes traffic across us-south1 and us-east4
- ✅ Monitors backend health with health checks
- ✅ Provides HTTPS with SSL termination
- ✅ Redirects HTTP to HTTPS
- ✅ Uses session affinity for stateful connections
- ✅ Automatically fails over to healthy regions

**Congratulations! 🎉** Your global load balancer is now ready for production traffic.

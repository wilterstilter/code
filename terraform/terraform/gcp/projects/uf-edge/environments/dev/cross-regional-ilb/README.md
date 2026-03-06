# Cross-Regional Internal Load Balancer

This configuration creates a cross-regional internal Application Load Balancer (ALB) in GCP that distributes traffic across Network Endpoint Groups (NEGs) in multiple regions.

## Architecture

- **Load Balancing Scheme**: INTERNAL_MANAGED (cross-regional internal ALB)
- **Regions**: us-south1, us-east4
- **Backend Service**: References existing global backend service in uf-compute project
- **SSL**: Currently disabled for HTTP-only testing

## Network Configuration

### Proxy-only Subnets (for Envoy proxies)

The following proxy-only subnets are **pre-existing** in the shared VPC (freight-network-host project) and are **not created, referenced, or managed by this module**. They must already exist at the VPC level for INTERNAL_MANAGED load balancers to function correctly and are documented here for informational/architectural context only:
- us-south1: 10.227.254.0/24
- us-east4: 10.225.254.0/24

### Load Balancer Subnets
- us-south1: 10.227.10.0/24 (Internal IP: 10.227.10.28)
- us-east4: 10.225.16.0/24 (Internal IP: 10.225.16.28)

## Dependencies

1. **Backend Service**: Must be created first in uf-compute project
2. **VPC Network**: freight-network-host project
3. **SSL Certificate**: uf-wildcard-cert-global

## Deployment

This should be deployed AFTER the backend service is created in uf-compute:

```bash
terragrunt plan
terragrunt apply
```

## Traffic Flow

1. Client requests to tmob.uberfreight.com
2. Internal DNS resolves to regional load balancer IPs
3. Global forwarding rules route to global target proxies
4. Global URL map routes based on path rules
5. Global backend service distributes to NEGs across regions
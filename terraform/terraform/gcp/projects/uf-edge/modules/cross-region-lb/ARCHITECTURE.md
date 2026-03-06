# Cross-Region Load Balancer Architecture

## Overview

This document explains the architecture and traffic flow of the cross-region load balancer module.

## High-Level Architecture

```
┌──────────────────────────────────────────────────────────────────────────┐
│                         Google Cloud Platform                             │
│                                                                           │
│  ┌─────────────────────────────────────────────────────────────────────┐ │
│  │                    Global External IP: 34.120.1.2                    │ │
│  └────────────────────────────┬────────────────────────────────────────┘ │
│                                │                                          │
│  ┌────────────────────────────▼────────────────────────────────────────┐ │
│  │               Global Forwarding Rule (HTTPS/HTTP)                    │ │
│  │                  Load Balancing Scheme: EXTERNAL_MANAGED             │ │
│  └────────────────────────────┬────────────────────────────────────────┘ │
│                                │                                          │
│  ┌────────────────────────────▼────────────────────────────────────────┐ │
│  │                   Target HTTPS/HTTP Proxy                            │ │
│  │                   + SSL Certificate                                  │ │
│  └────────────────────────────┬────────────────────────────────────────┘ │
│                                │                                          │
│  ┌────────────────────────────▼────────────────────────────────────────┐ │
│  │                         URL Map                                      │ │
│  │              (Host Rules + Path Matchers)                            │ │
│  │                                                                       │ │
│  │   Host Rules:                                                        │ │
│  │   - api.example.com → path_matcher: "api"                           │ │
│  │   - www.example.com → path_matcher: "www"                           │ │
│  │                                                                       │ │
│  │   Path Matchers:                                                     │ │
│  │   - /api/v1/* → api-v1-backend                                      │ │
│  │   - /api/v2/* → api-v2-backend                                      │ │
│  │   - /health   → api-default                                         │ │
│  └────────┬──────────────────┬──────────────────┬──────────────────────┘ │
│           │                  │                  │                        │
│  ┌────────▼────────┐  ┌──────▼────────┐  ┌─────▼──────────┐            │
│  │ Global Backend  │  │ Global Backend│  │ Global Backend │            │
│  │   Service #1    │  │  Service #2   │  │   Service #3   │            │
│  │  (api-v1-backend)│ │(api-v2-backend)│ │(api-default)   │            │
│  │                 │  │               │  │                │            │
│  │ Load Balancing: │  │               │  │                │            │
│  │ - Mode: RATE    │  │               │  │                │            │
│  │ - Max: 100 RPS  │  │               │  │                │            │
│  │ - Session       │  │               │  │                │            │
│  │   Affinity:     │  │               │  │                │            │
│  │   COOKIE        │  │               │  │                │            │
│  └────────┬────────┘  └───────┬───────┘  └────────┬───────┘            │
│           │                   │                    │                    │
│  ┌────────▼──────────────────┐│                    │                    │
│  │  Global Health Check      ││                    │                    │
│  │  - Protocol: HTTP         ││                    │                    │
│  │  - Path: /health          ││                    │                    │
│  │  - Port: 8080             ││                    │                    │
│  │  - Interval: 10s          ││                    │                    │
│  │  - Timeout: 5s            ││                    │                    │
│  │  - Healthy: 2 successes   ││                    │                    │
│  │  - Unhealthy: 2 failures  ││                    │                    │
│  └───────────────────────────┘│                    │                    │
│                                │                    │                    │
│  ┌────────────────────────────┴────────────────────┴─────────────────┐  │
│  │                    NEGs Across Multiple Regions                    │  │
│  │                                                                     │  │
│  │  Region: us-south1           Region: us-east4                      │  │
│  │  ┌─────────────────────┐     ┌─────────────────────┐              │  │
│  │  │ NEG: api-v1-south1  │     │ NEG: api-v1-east4   │              │  │
│  │  │ Endpoints:          │     │ Endpoints:          │              │  │
│  │  │ - 10.1.1.1:8080    │     │ - 10.2.1.1:8080    │              │  │
│  │  │ - 10.1.1.2:8080    │     │ - 10.2.1.2:8080    │              │  │
│  │  │ - 10.1.1.3:8080    │     │ - 10.2.1.3:8080    │              │  │
│  │  └─────────────────────┘     └─────────────────────┘              │  │
│  │                                                                     │  │
│  │  ┌─────────────────────┐     ┌─────────────────────┐              │  │
│  │  │ NEG: api-v2-south1  │     │ NEG: api-v2-east4   │              │  │
│  │  │ Endpoints:          │     │ Endpoints:          │              │  │
│  │  │ - 10.1.2.1:8080    │     │ - 10.2.2.1:8080    │              │  │
│  │  │ - 10.1.2.2:8080    │     │ - 10.2.2.2:8080    │              │  │
│  │  └─────────────────────┘     └─────────────────────┘              │  │
│  └─────────────────────────────────────────────────────────────────┘  │
└───────────────────────────────────────────────────────────────────────┘
```

## Traffic Flow

### Successful Request Flow

```
1. Client Request
   Client → https://api.example.com/api/v1/users
   
2. DNS Resolution
   api.example.com → 34.120.1.2 (Global IP)
   
3. Global Frontend (Google's Edge PoP)
   - Request hits nearest Google Point of Presence
   - SSL termination happens here
   - Certificate validation
   
4. Forwarding Rule
   - Port 443 traffic → HTTPS Target Proxy
   
5. Target HTTPS Proxy
   - Uses SSL certificate
   - Forwards to URL Map
   
6. URL Map Evaluation
   - Host match: "api.example.com" → path_matcher "api"
   - Path match: "/api/v1/users" → backend "api-v1-backend"
   
7. Global Backend Service Selection
   - Selected: api-v1-backend
   - Load balancing algorithm: RATE
   - Session affinity: Check for cookie
   
8. Health Check Evaluation
   - Check health status of all NEGs
   - Available NEGs:
     ✅ us-south1: api-v1-south1 (3 healthy endpoints)
     ✅ us-east4: api-v1-east4 (3 healthy endpoints)
   
9. Endpoint Selection
   - Choose endpoint based on:
     a) Health status (only healthy endpoints)
     b) Geographic proximity (if client is closer to us-south1)
     c) Current load (RATE balancing)
     d) Session affinity (if cookie present)
   
   Selected: 10.1.1.1:8080 in us-south1
   
10. Request Forwarding
    - Request sent to backend: 10.1.1.1:8080
    - Backend processes request
    
11. Response Path
    Backend (10.1.1.1:8080)
    → Global Backend Service
    → URL Map
    → HTTPS Proxy (adds security headers)
    → Forwarding Rule
    → Global Frontend
    → Client
    
12. Session Affinity Cookie
    - Response includes: Set-Cookie: GCLB=...
    - Next request from same client uses this cookie
    - Routes to same backend (if healthy)
```

### Failover Scenario

```
Scenario: All endpoints in us-south1 become unhealthy

1. Client Request
   Client → https://api.example.com/api/v1/users
   Cookie: GCLB=hash_pointing_to_us-south1
   
2. Health Check Status
   ❌ us-south1: api-v1-south1 (0 healthy, 3 unhealthy)
   ✅ us-east4: api-v1-east4 (3 healthy endpoints)
   
3. Backend Service Decision
   - Detects us-south1 is unhealthy
   - Ignores session affinity cookie
   - Routes to healthy region: us-east4
   
4. New Endpoint Selection
   Selected: 10.2.1.1:8080 in us-east4
   
5. Response with New Cookie
   - Response includes new cookie
   - Set-Cookie: GCLB=hash_pointing_to_us-east4
   - Future requests route to us-east4
   
6. Recovery
   - When us-south1 becomes healthy again
   - New sessions can use us-south1
   - Existing sessions continue to us-east4 (affinity)
```

## Health Check Details

### Health Check Process

```
┌──────────────────────────────────────────────────────────────┐
│              Global Health Check (every 10 seconds)          │
└────────────────┬─────────────────────────────────────────────┘
                 │
      ┌──────────┴──────────┐
      │                     │
      ▼                     ▼
┌─────────────────┐   ┌─────────────────┐
│  us-south1      │   │  us-east4       │
│  Health Probe   │   │  Health Probe   │
└────────┬────────┘   └────────┬────────┘
         │                     │
    ┌────┼────┬────┐      ┌────┼────┬────┐
    │    │    │    │      │    │    │    │
    ▼    ▼    ▼    ▼      ▼    ▼    ▼    ▼
  EP1  EP2  EP3  EP4    EP1  EP2  EP3  EP4
  ✅   ✅   ❌   ✅     ✅   ✅   ✅   ✅
  
  Health Status per Endpoint:
  - Check: HTTP GET /health on port 8080
  - Expected: 200 OK response within 5 seconds
  - Marking Healthy: 2 consecutive successes
  - Marking Unhealthy: 2 consecutive failures
  
Result:
- us-south1: 3/4 endpoints healthy (75% capacity)
- us-east4: 4/4 endpoints healthy (100% capacity)
- Traffic distributed proportionally
```

### Health Check Configuration

```hcl
health_checks = {
  http-health-check = {
    protocol            = "HTTP"
    path                = "/health"
    port                = 8080
    check_interval_sec  = 10   # Check every 10 seconds
    timeout_sec         = 5    # Wait up to 5 seconds for response
    healthy_threshold   = 2    # 2 successes = mark healthy
    unhealthy_threshold = 2    # 2 failures = mark unhealthy
  }
}
```

### Expected Health Check Endpoint Response

Your backend should implement a `/health` endpoint that returns:

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
  "status": "healthy",
  "timestamp": "2026-01-16T10:30:00Z"
}
```

## Path-Based Routing Details

### URL Map Configuration

```hcl
frontends = {
  api = {
    url_map = [
      {
        path     = "/api/v1"
        backend  = "api-v1-backend"
        priority = 1  # Evaluated first
      },
      {
        path     = "/api/v2"
        backend  = "api-v2-backend"
        priority = 2  # Evaluated second
      },
      {
        path     = "/"
        backend  = "api-default"
        priority = 3  # Catch-all, evaluated last
      }
    ]
  }
}
```

### Path Matching Examples

```
Request: https://api.example.com/api/v1/users
Match: /api/v1 (priority 1)
Backend: api-v1-backend
Result: Routes to api-v1 NEGs in us-south1 or us-east4

Request: https://api.example.com/api/v2/orders
Match: /api/v2 (priority 2)
Backend: api-v2-backend
Result: Routes to api-v2 NEGs in us-south1 or us-east4

Request: https://api.example.com/health
Match: / (priority 3, catch-all)
Backend: api-default
Result: Routes to default NEGs

Request: https://api.example.com/admin
Match: /admin (forbidden_uri rule)
Result: 403 Forbidden (no backend routing)
```

## Session Affinity

### Cookie-Based Affinity

```
Client's First Request:
  Request → https://api.example.com/api/v1/login
  No cookie present
  
Backend Selection:
  Selected: 10.1.1.1:8080 in us-south1
  
Response:
  Set-Cookie: GCLB=abcdef123456; Path=/; HttpOnly; Secure
  
Client's Subsequent Requests:
  Request → https://api.example.com/api/v1/profile
  Cookie: GCLB=abcdef123456
  
Backend Selection:
  Cookie hash → 10.1.1.1:8080 in us-south1
  If healthy: Route to same backend ✅
  If unhealthy: Route to different healthy backend ❌
```

### Affinity Configuration

```hcl
backends = {
  api-backend = {
    session_affinity        = "GENERATED_COOKIE"
    affinity_cookie_ttl_sec = 86400  # 1 day (24 hours)
  }
}
```

## Security Features

### Cloud Armor Integration

```hcl
backends = {
  api-backend = {
    security_policy = "projects/my-project/global/securityPolicies/my-policy"
  }
}
```

Cloud Armor provides:
- DDoS protection
- IP allowlisting/denylisting
- Rate limiting
- Custom WAF rules
- Bot management

### SSL/TLS Termination

```
Client ←→ [HTTPS] ←→ Google Frontend ←→ [HTTP/HTTPS] ←→ Backend

- SSL termination at Google Frontend
- Certificate managed by Certificate Manager or Google-managed certs
- Backend communication can be HTTP (internal) or HTTPS
```

### Security Headers

Automatically added to responses:

```http
Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
X-Forwarded-Proto: https
```

## Performance Optimization

### Global Edge Network

```
Client Location: Europe
├── DNS resolves to anycast IP: 34.120.1.2
├── Request hits: Google PoP in Frankfurt, Germany
├── SSL termination: At Frankfurt PoP
├── Routing decision: At Frankfurt PoP
└── Backend selection:
    Option 1: europe-west1 (if NEGs exist there) - ~10ms
    Option 2: us-east4 (if no Europe NEGs) - ~100ms
    Option 3: us-south1 (fallback) - ~120ms
```

### Load Distribution

```
With 3 endpoints in us-south1, 100 RPS max per endpoint:

Total capacity: 300 RPS per region
With 2 regions: 600 RPS total capacity

Current load: 400 RPS
├── us-south1: 200 RPS (66% utilization)
└── us-east4: 200 RPS (66% utilization)

If us-south1 fails:
├── us-south1: 0 RPS (unhealthy)
└── us-east4: 400 RPS (133% utilization - may degrade)

Recommendation: Add more regions or increase capacity
```

## Monitoring and Observability

### Key Metrics to Monitor

```
Load Balancer Metrics:
- loadbalancing.googleapis.com/https/request_count
- loadbalancing.googleapis.com/https/total_latencies
- loadbalancing.googleapis.com/https/backend_latencies
- loadbalancing.googleapis.com/https/backend_request_count

Health Check Metrics:
- compute.googleapis.com/instance_group/health_check_succeeded
- compute.googleapis.com/instance_group/health_check_failed

Backend Metrics:
- compute.googleapis.com/instance/cpu/utilization
- compute.googleapis.com/instance/network/received_bytes_count
- compute.googleapis.com/instance/network/sent_bytes_count
```

### Logging

```hcl
backends = {
  api-backend = {
    logging_enabled     = true
    logging_sample_rate = 1.0  # Log 100% of requests
  }
}
```

Log entries include:
- Request URL and method
- Response status code
- Latency breakdown
- Backend selected
- Client IP and location
- User agent

## Cost Considerations

### Pricing Components

```
1. Load Balancer Forwarding Rules:
   - $0.025 per hour per forwarding rule
   - 2 rules (HTTP + HTTPS) × $0.025 × 730 hours = ~$36.50/month

2. Load Balancer Data Processing:
   - $0.008 - $0.016 per GB (depending on region)
   - 1 TB/month × $0.010 average = ~$10/month

3. Global Backend Service:
   - Included in forwarding rule pricing

4. Health Checks:
   - Included (no separate charge)

5. Egress:
   - Internet egress: $0.12/GB (Americas)
   - Cross-region egress: $0.01/GB (within same continent)
   - 1 TB internet egress = ~$120/month

Total estimated cost for 1 TB/month: ~$166.50/month
```

## Best Practices Summary

1. **Deploy to Multiple Regions**: At least 2 regions for HA
2. **Configure Health Checks**: Always monitor backend health
3. **Use Session Affinity**: For stateful applications
4. **Enable Logging**: For debugging and analytics
5. **Apply Cloud Armor**: For security and DDoS protection
6. **Set Appropriate Timeouts**: Based on application response times
7. **Monitor Performance**: Use Cloud Monitoring dashboards
8. **Plan Capacity**: Set `max_rate_per_endpoint` appropriately
9. **Test Failover**: Regularly test regional failover scenarios
10. **Use CDN**: Consider Cloud CDN for cacheable content

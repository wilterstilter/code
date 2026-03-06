# NEG Backends Module

This module is designed to create **Network Endpoint Groups (NEGs)** and **regional backend services** in Google Cloud Platform (GCP). It dynamically configures health checks and backend services based on user-provided inputs.

## Features

1. **Health Checks**:
   - Dynamically creates HTTP health checks for backend services.
   - Configurable parameters such as `request_path`, `port`, `check_interval_sec`, and thresholds.

2. **Regional Backend Services**:
   - Creates backend services with NEGs as backends.
   - Supports dynamic configuration of backend properties like `balancing_mode`, `max_rate_per_endpoint`, and `capacity_scaler`.

3. **Dynamic Inputs**:
   - Accepts user-defined configurations for health checks and backend services.
   - Automatically links health checks to backend services.

---

## Inputs

### **Required Variables**

1. **`project_id`**:
   - The GCP project ID where the resources will be created.

2. **`region`**:
   - The region where the backend services will be deployed.

3. **`protocol`**:
   - The protocol used by the backend services (e.g., `HTTP`, `HTTPS`).

4. **`timeout_sec`**:
   - The timeout for backend services in seconds.

5. **`load_balancing_scheme`**:
   - The load balancing scheme (e.g., `INTERNAL`, `EXTERNAL`).

6. **`health_check_configs`**:
   - A map of health check configurations. Each key represents a unique health check name, and the value is an object with the following properties:
     - `request_path`: The HTTP request path for the health check.
     - `port`: The port to use for the health check.
     - `check_interval_sec`: The interval between health checks.
     - `timeout_sec`: The timeout for each health check.
     - `healthy_threshold`: The number of successful checks required to mark a backend as healthy.
     - `unhealthy_threshold`: The number of failed checks required to mark a backend as unhealthy.

7. **`backend_service_configs`**:
   - A map of backend service configurations. Each key represents a unique backend service name, and the value is an object with the following properties:
     - `health_check_name`: The name of the health check to associate with the backend service.
     - `neg_names`: A map of NEGs to attach to the backend service.
     - `balancing_mode`: The balancing mode for the backend (e.g., `RATE`, `UTILIZATION`).
     - `max_rate_per_endpoint`: The maximum requests per endpoint.
     - `capacity_scaler`: The capacity scaler for the backend.

---

## Outputs

1. **`health_check_links`**:
   - A map of health check names to their self-links.

2. **`backend_service_links`**:
   - A map of backend service names to their self-links.

---

## Example Configuration

Here’s an example of how to use this module to create health checks and backend services:

### **Input Variables**

```hcl
module "neg_backends" {
  source = "./modules/neg-backends"

  project_id = "my-gcp-project"
  region     = "us-central1"
  protocol   = "HTTP"
  timeout_sec = 30
  load_balancing_scheme = "INTERNAL"

  # Health check configurations
  health_check_configs = {
    "app-health-check" = {
      request_path       = "/healthz"
      port               = 8080
      check_interval_sec = 5
      timeout_sec        = 5
      healthy_threshold  = 2
      unhealthy_threshold = 2
    },
    "api-health-check" = {
      request_path       = "/api/health"
      port               = 9090
      check_interval_sec = 10
      timeout_sec        = 5
      healthy_threshold  = 3
      unhealthy_threshold = 3
    }
  }

  # Backend service configurations
  backend_service_configs = {
    "app-backend-service" = {
      health_check_name    = "app-health-check"
      neg_names            = {
        "app-neg" = "projects/my-gcp-project/regions/us-central1/networkEndpointGroups/app-neg"
      }
      balancing_mode        = "RATE"
      max_rate_per_endpoint = 100
      capacity_scaler       = 1.0
    },
    "api-backend-service" = {
      health_check_name    = "api-health-check"
      neg_names            = {
        "api-neg" = "projects/my-gcp-project/regions/us-central1/networkEndpointGroups/api-neg"
      }
      balancing_mode        = "UTILIZATION"
      max_rate_per_endpoint = 50
      capacity_scaler       = 0.8
    }
  }
}

# Private Service Access Module

This Terraform module sets up **Private Service Access (PSA)** for Google-managed services in a Shared VPC environment.

## What is Private Service Access?

Private Service Access allows Google-managed services to be allocated private IP addresses from your VPC network, providing:

- 🔒 **Private connectivity** - Services accessible only within your VPC (no public IPs)
- 🌐 **Automatic DNS management** - Google manages DNS records (e.g., Cloud SQL write endpoints)
- 🚀 **Better performance** - Direct VPC connectivity without NAT overhead
- 🛡️ **Enhanced security** - Traffic stays within Google's network

## Supported Services

This module enables Private Service Access for:

- **Cloud SQL** (MySQL, PostgreSQL, SQL Server)
- **Memorystore** (Redis, Memcached)
- **Data Fusion**
- **Filestore**
- Any other service that supports `servicenetworking.googleapis.com`

## Architecture

```
┌─────────────────────────────────────────┐
│  Your VPC (e.g., nonprod)               │
│                                         │
│  ┌─────────────────────────────────┐   │
│  │ Reserved PSA IP Range           │   │
│  │ (e.g., 172.27.24.0/22)          │   │
│  │                                 │   │
│  │  Google auto-allocates IPs      │   │
│  │  for managed services           │   │
│  └─────────────────────────────────┘   │
│           ↕ (VPC Peering)               │
│  ┌─────────────────────────────────┐   │
│  │ Google Service Producer VPC     │   │
│  │ (Cloud SQL, Memorystore, etc.)  │   │
│  └─────────────────────────────────┘   │
└─────────────────────────────────────────┘
```

## Usage

```hcl
module "psa" {
  source = "../../modules/private-service-access"

  project_id              = "freight-network-host-n"
  network_name            = "nonprod"
  psa_range_name          = "psa-nonprod"
  psa_range_address       = "172.27.24.0"
  psa_range_prefix_length = 22
  psa_range_description   = "IP range for Private Service Access"
}
```

## Inputs

| Name | Type | Description | Default |
|------|------|-------------|---------|
| `project_id` | string | The host project ID where the VPC resides | Required |
| `network_name` | string | The name of the VPC network | Required |
| `psa_range_name` | string | The name of the global address for PSA | Required |
| `psa_range_address` | string | The starting IP address for the PSA range | `null` (auto-allocated) |
| `psa_range_prefix_length` | number | The prefix length for the PSA range | `22` |
| `psa_range_description` | string | Description for the IP range | `"IP range reserved for Private Service Access"` |

## Outputs

| Name | Description |
|------|-------------|
| `psa_range_name` | The name of the allocated PSA IP range |
| `psa_range_address` | The starting IP address of the PSA range |
| `psa_range_cidr` | The CIDR notation of the PSA range |
| `service_networking_connection` | The service networking connection peering name |

## IP Range Planning

**Recommended prefix lengths:**

- `/16` - 65,536 IPs (very large deployments)
- `/20` - 4,096 IPs (large deployments)
- `/22` - 1,024 IPs (typical for most orgs) ✅
- `/24` - 256 IPs (small deployments)

**Example IP allocation:**

```
172.27.0.0/20   → Compute subnets (us-south1)
172.27.16.0/20  → Compute subnets (us-east4)
172.27.20.0/22  → PSA for prod (Data Fusion)
172.27.24.0/22  → PSA for nonprod (Cloud SQL, Memorystore)
```

## Important Notes

1. **One PSA connection per VPC** - You can only have one `google_service_networking_connection` per VPC, but it can include multiple IP ranges via `reserved_peering_ranges`.

2. **IP range is reserved** - The entire range is reserved for Google services, even if not all IPs are in use.

3. **Cannot be deleted easily** - Service networking connections cannot be easily removed once created. Plan your IP ranges carefully.

4. **DNS is automatic** - Google automatically manages DNS for PSA services (e.g., Cloud SQL write endpoints).

5. **Shared VPC compatibility** - This module is designed for Shared VPC host projects. Service projects will automatically inherit PSA connectivity.

## Cloud SQL Write Endpoints

When you create a Cloud SQL instance with PSA and cascadable replicas, Google automatically creates a **shared write endpoint**:

```
primary.abc123.hash.global.sql-psa.goog → Current Primary IP
```

This DNS name:
- ✅ Points to the current primary instance
- ✅ Automatically updates during failover/promotion
- ✅ Allows zero-downtime disaster recovery
- ✅ Works for MySQL, PostgreSQL, and SQL Server

## Example: Complete Cloud SQL Setup

```hcl
# 1. Set up PSA in network host project
module "psa" {
  source = "../../modules/private-service-access"
  
  project_id    = "freight-network-host-n"
  network_name  = "nonprod"
  psa_range_name = "psa-nonprod"
  psa_range_address = "172.27.24.0"
  psa_range_prefix_length = 22
}

# 2. Create Cloud SQL in service project
module "cloudsql" {
  source = "../../modules/cloudsql-psa-advanced-dr"
  
  project_id = "uf-database-n"
  network    = "projects/freight-network-host-n/global/networks/nonprod"
  
  # PSA will automatically allocate private IPs from 172.27.24.0/22
  # Write endpoint DNS is automatically created
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >=1.5 |
| google | ~> 5.23.0 |

## Resources Created

- `google_compute_global_address` - Reserved IP range for PSA
- `google_service_networking_connection` - VPC peering to Google service producer network

## References

- [Private Service Access Overview](https://cloud.google.com/vpc/docs/private-services-access)
- [Cloud SQL Private IP](https://cloud.google.com/sql/docs/mysql/configure-private-ip)
- [Service Networking API](https://cloud.google.com/service-infrastructure/docs/service-networking/getting-started)

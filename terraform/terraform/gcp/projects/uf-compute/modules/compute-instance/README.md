# GCP Compute Instance Module - Multi-VM with High Availability

This Terraform module creates one or more Google Compute Engine instances with support for high availability features including multi-zone deployment and unmanaged instance groups for load balancer backends.

## Features

### High Availability & Multi-VM
- ✅ Multi-VM deployment (deploy 1 to N VMs with single module invocation)
- ✅ Multi-zone deployment (each VM can be in different zone)
- ✅ Multi-region deployment (VMs can span multiple regions)
- ✅ Unmanaged instance groups (optional, per zone for load balancer backends)
- ✅ Named ports support (for load balancer health checks)
- ✅ Per-instance configuration overrides (machine type, network, tags, labels)
- ✅ 99.99% SLA support (via multi-zone instance groups)

### Compute Instance
- ✅ Windows Server 2025 Datacenter (latest image via image_family)
- ✅ RHEL 10 support (Red Hat Enterprise Linux 10)
- ✅ Intel processors only (N2 series) for compatibility
- ✅ Private IPs only (security enforced)
- ✅ Shielded VM support (vTPM, Secure Boot, Integrity Monitoring)
- ✅ Customer-managed encryption (CMEK) support
- ✅ Confidential computing support
- ✅ Flexible scheduling (standard, preemptible, SPOT instances)
- ✅ Service account integration
- ✅ Multiple network interfaces support
- ✅ Resource policies (backup schedules)
- ✅ Advanced machine features (nested virtualization for Hyper-V)

### Service Account & IAM Management
- ✅ **User-managed service account creation** (dedicated SA per deployment)
- ✅ **Bucket-specific IAM bindings** (principle of least privilege)
- ✅ **Full cloud-platform VM scopes** (IAM-controlled access)
- ✅ **Project-level role assignments** (logging, monitoring, custom roles)
- ✅ **Cloud Storage integration** (ready for rclone/WinFsp mounting)
- ✅ **Flexible configuration** (use existing SA or create new)

### Data Disk Management
- ✅ Integrated data disk creation (0 to many disks per VM)
- ✅ Automatic disk attachment to all VMs
- ✅ Flexible disk types (pd-standard, pd-balanced, pd-ssd, hyperdisk-balanced)
- ✅ Per-disk encryption (CMEK or CSEK)
- ✅ Automatic naming and device assignment
- ✅ Sequential drive letter assignment (D:, E:, F:, etc.)
- ✅ Disk lifecycle tied to VM (simplified management)

---

## Table of Contents

- [Security Policy](#security-policy)
- [Requirements](#requirements)
- [Basic Usage](#basic-usage)
- [Service Account & Storage Access](#service-account--storage-access)
- [Instance Groups for High Availability](#instance-groups-for-high-availability)
- [Variables](#variables)
- [Outputs](#outputs)
- [High Availability Architecture](#high-availability-architecture)
- [Per-Instance Overrides](#per-instance-overrides)
- [Data Disks](#data-disks)
- [Network Configuration](#network-configuration)
- [Outbound Internet Access](#outbound-internet-access)
- [Security Features](#security-features)
- [Best Practices](#best-practices)
- [Terragrunt Integration](#terragrunt-integration)

---

## Security Policy

### 🔒 Private IPs Only

**This module enforces a security policy that prohibits public IP addresses on VMs.**

- ✅ All VMs receive **private IP addresses only**
- ❌ No `access_config` blocks (external IPv4) allowed
- ❌ No `ipv6_access_config` blocks (external IPv6) allowed
- ✅ Internet access via **Cloud NAT** for outbound traffic
- ✅ Remote access via **Identity-Aware Proxy (IAP)**, VPN, or Cloud Interconnect

### Why Private IPs Only?

1. **Reduced Attack Surface**: No direct internet exposure eliminates most network-based attacks
2. **Compliance**: Meets security requirements for PCI-DSS, HIPAA, and other frameworks
3. **Defense in Depth**: Forces all access through controlled entry points (IAP, VPN)
4. **Audit Trail**: IAP provides detailed access logs and integrates with Cloud IAM
5. **Zero Trust**: Aligns with zero-trust security principles

---

## Requirements

- Terraform >= 1.5
- Google Provider >= 7.1, < 8.0
- Terragrunt (for .hcl examples)

## Machine Types and OS Support

### Supported Operating Systems

- **Windows Server 2025 Datacenter** (default via `os_type = "windows2025"`)
- **Red Hat Enterprise Linux 10** (via `os_type = "rhel10"` or `"linux"`)

The module automatically selects the latest image from the appropriate image family.

### Machine Types (Intel Only)

This module uses **N2 series** machine types to guarantee Intel processors:

```hcl
machine_type = "n2-standard-2"   # 2 vCPU, 8GB RAM (minimum for Windows)
machine_type = "n2-standard-4"   # 4 vCPU, 16GB RAM (recommended for production)
machine_type = "n2-standard-8"   # 8 vCPU, 32GB RAM (database workloads)
machine_type = "n2-highmem-4"    # 4 vCPU, 32GB RAM (memory-intensive)
```

**Why Intel?** Windows Server applications may have compatibility requirements that necessitate Intel processors. The N2 series provides consistent Intel performance.

## Basic Usage

### Single VM Deployment

```hcl
module "compute_instance" {
  source = "./modules/compute-instance"

  project_id   = "my-project"
  os_type      = "windows2025"
  machine_type = "n2-standard-2"

  instances = [
    {
      name = "vm-app-01"
      zone = "us-central1-a"
      network_interfaces = [
        {
          subnetwork = "projects/my-project/regions/us-central1/subnetworks/my-subnet"
        }
      ]
    }
  ]

  data_disks = [
    {
      size = 100
      type = "hyperdisk-balanced"
    }
  ]
}
```

### Multi-VM Deployment with High Availability

```hcl
module "compute_instance_ha" {
  source = "./modules/compute-instance"

  project_id   = "my-project"
  os_type      = "windows2025"
  machine_type = "n2-standard-2"

  # Deploy 3 VMs across different zones for high availability
  instances = [
    {
      name = "vm-app-01"
      zone = "us-central1-a"
      network_interfaces = [
        {
          subnetwork = "projects/my-project/regions/us-central1/subnetworks/my-subnet"
        }
      ]
    },
    {
      name = "vm-app-02"
      zone = "us-central1-b"
      network_interfaces = [
        {
          subnetwork = "projects/my-project/regions/us-central1/subnetworks/my-subnet"
        }
      ]
    },
    {
      name = "vm-app-03"
      zone = "us-central1-c"
      network_interfaces = [
        {
          subnetwork = "projects/my-project/regions/us-central1/subnetworks/my-subnet"
        }
      ]
    }
  ]

  # Enable instance groups for load balancer backends
  create_instance_groups = true
  instance_group_name_prefix = "ig-app"

  # Named ports for load balancer health checks
  instance_group_named_ports = [
    {
      name = "http"
      port = 80
    },
    {
      name = "https"
      port = 443
    }
  ]

  data_disks = [
    {
      size = 100
      type = "hyperdisk-balanced"
    }
  ]

  tags = ["web", "app", "prod"]
}
```

### Multi-Region Deployment

```hcl
module "compute_instance_multi_region" {
  source = "./modules/compute-instance"

  project_id   = "my-project"
  os_type      = "windows2025"
  machine_type = "n2-standard-4"

  # Deploy VMs in different regions for disaster recovery
  instances = [
    {
      name = "vm-us-east-01"
      zone = "us-east1-b"
      network_interfaces = [
        {
          subnetwork = "projects/my-project/regions/us-east1/subnetworks/subnet-east"
        }
      ]
    },
    {
      name = "vm-us-west-01"
      zone = "us-west1-a"
      network_interfaces = [
        {
          subnetwork = "projects/my-project/regions/us-west1/subnetworks/subnet-west"
        }
      ]
    }
  ]

  create_instance_groups = true
}
```

## Service Account & Storage Access

### Overview

The module provides comprehensive service account and IAM management for scenarios like:
- ✅ **Cloud Storage access** (mounting buckets via rclone/WinFsp)
- ✅ **Application authentication** (using Application Default Credentials)
- ✅ **Service-to-service communication** (GCP API access)
- ✅ **Least privilege access** (bucket-specific permissions)

### Creating a User-Managed Service Account

```hcl
module "compute_with_storage_access" {
  source = "./modules/compute-instance"

  project_id   = "my-project"
  os_type      = "windows2025"
  machine_type = "n2-standard-4"

  instances = [
    {
      name = "vm-app-01"
      zone = "us-central1-a"
      network_interfaces = [{ subnetwork = var.subnet }]
    }
  ]

  # Create a dedicated service account
  create_service_account = true
  
  service_account_config = {
    account_id   = "vm-storage-access-sa"
    display_name = "VM Storage Access Service Account"
    description  = "Service account for VMs to access Cloud Storage"
    
    # Project-level roles (for logging, monitoring, etc.)
    project_roles = [
      "roles/logging.logWriter",
      "roles/monitoring.metricWriter"
    ]
  }
  
  # Grant access to specific storage bucket
  storage_bucket_name = "my-app-data-bucket"
  storage_bucket_role = "roles/storage.objectAdmin"  # Full read/write
}
```

### Using an Existing Service Account

```hcl
module "compute_with_existing_sa" {
  source = "./modules/compute-instance"

  project_id   = "my-project"
  os_type      = "windows2025"
  machine_type = "n2-standard-4"

  instances = [
    {
      name = "vm-app-01"
      zone = "us-central1-a"
      network_interfaces = [{ subnetwork = var.subnet }]
    }
  ]

  # Use existing service account
  service_account = {
    email  = "existing-sa@my-project.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  
  # Still grant bucket access
  storage_bucket_name = "my-app-data-bucket"
  storage_bucket_role = "roles/storage.objectAdmin"
}
```

### Storage Access Roles

Common roles for Cloud Storage access:

| Role | Permissions | Use Case |
|------|-------------|----------|
| `roles/storage.objectViewer` | Read-only | Download files, list objects |
| `roles/storage.objectUser` | Read + conditional write | Read and write own objects |
| `roles/storage.objectAdmin` | Full read/write/delete | **Recommended for rclone** - complete access |
| `roles/storage.admin` | Full bucket + object control | Bucket management (usually too broad) |

**For rclone/WinFsp mounting**, use `roles/storage.objectAdmin` as it provides:
- ✅ `storage.objects.get` (read objects)
- ✅ `storage.objects.list` (list objects)
- ✅ `storage.objects.create` (write/upload)
- ✅ `storage.objects.delete` (delete objects)
- ✅ `storage.buckets.get` (required for rclone initialization)

### How It Works: The VM Access Scope "Bridge"

**Critical Concept**: Even with perfect IAM permissions, VMs have a metadata-level OAuth access scope restriction.

```
User's IAM Permissions
        ↓
  [VM Access Scopes] ← THE BRIDGE
        ↓
  Actual GCP APIs
```

**The module automatically handles this** when `create_service_account = true`:
- Sets VM scope to `cloud-platform` (full access)
- Makes **IAM the only limiter** (as Google recommends)
- Prevents "access denied" despite correct IAM permissions

### rclone Configuration Example

After VMs are deployed with storage access, configure rclone on Windows:

```powershell
# 1. Install rclone and WinFsp
choco install rclone winfsp -y

# 2. Configure rclone (uses VM's service account automatically)
mkdir $env:APPDATA\rclone
@"
[gcs]
type = google cloud storage
project_number = my-project
bucket_policy_only = true
"@ | Out-File $env:APPDATA\rclone\rclone.conf -Encoding utf8

# 3. Mount bucket as Z: drive
rclone mount gcs:my-bucket-name Z: --daemon

# 4. Access files
dir Z:\
```

### Multi-Region Storage Access Example

```hcl
module "multi_region_storage_access" {
  source = "./modules/compute-instance"

  project_id   = "my-project"
  os_type      = "windows2025"
  machine_type = "n2-standard-4"

  # 4 VMs across 2 regions - all share same storage bucket
  instances = [
    # Region 1: us-south1
    { name = "vm-south-01", zone = "us-south1-a", network_interfaces = [{ subnetwork = var.subnet_south }] },
    { name = "vm-south-02", zone = "us-south1-b", network_interfaces = [{ subnetwork = var.subnet_south }] },
    # Region 2: us-east4
    { name = "vm-east-01",  zone = "us-east4-a",  network_interfaces = [{ subnetwork = var.subnet_east }] },
    { name = "vm-east-02",  zone = "us-east4-b",  network_interfaces = [{ subnetwork = var.subnet_east }] }
  ]

  # Single service account for all VMs
  create_service_account = true
  service_account_config = {
    account_id   = "multi-region-storage-sa"
    display_name = "Multi-Region VM Storage Access"
    description  = "Service account for VMs in all regions to access shared storage"
  }
  
  # Single bucket accessible from all VMs
  storage_bucket_name = "shared-data-bucket"
  storage_bucket_role = "roles/storage.objectAdmin"

  tags = ["storage-access", "multi-region"]
}
```

## Instance Groups for High Availability

When `create_instance_groups = true`, the module creates unmanaged instance groups automatically:

- **One instance group per zone**: All VMs in the same zone are grouped together
- **Load balancer backends**: Instance groups can be directly used as backend targets
- **Health checking**: Named ports enable load balancer health checks
- **99.99% SLA**: Multiple zones provide redundancy for high availability requirements

### Why Unmanaged Instance Groups?

Unmanaged instance groups are ideal when:
- You need to use existing VMs as load balancer backends
- You want manual control over VM lifecycle
- You need to meet strict SLA requirements (99.99%)
- You're not using auto-scaling (managed instance groups are for auto-scaling)

## Variables

### Required Variables

| Variable | Type | Description |
|----------|------|-------------|
| `instances` | list(object) | List of VM instances to create with their configurations |
| `os_type` | string | Operating system: `windows2025`, `windows`, `rhel10`, `el10`, or `linux` |
| `machine_type` | string | Default machine type (e.g., `n2-standard-4`) |

### Service Account Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `create_service_account` | bool | `false` | Create a new user-managed service account |
| `service_account_config` | object | `null` | Configuration for new service account (account_id, display_name, description, project_roles) |
| `service_account` | object | `null` | Existing service account to use (email, scopes) |
| `storage_bucket_name` | string | `null` | Cloud Storage bucket name to grant access to |
| `storage_bucket_role` | string | `"roles/storage.objectAdmin"` | IAM role to grant on the bucket |

### Other Important Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `data_disks` | list(object) | `[]` | Data disks to create and attach |
| `boot_disk` | object | `null` | Boot disk configuration (auto-configured by OS type if omitted) |
| `network_interfaces` | list(object) | `[]` | Default network interfaces (can be overridden per instance) |
| `create_instance_groups` | bool | `false` | Create unmanaged instance groups |
| `instance_group_name_prefix` | string | `"ig"` | Prefix for instance group names |
| `shielded_instance_config` | object | See docs | Shielded VM configuration |
| `deletion_protection` | bool | `false` | Enable deletion protection |
| `tags` | list(string) | `[]` | Network tags for firewall rules |
| `labels` | map(string) | `{}` | Resource labels for organization |

For complete variable documentation, see [variables.tf](./variables.tf).

## Outputs

### Service Account Outputs

| Output | Description |
|--------|-------------|
| `service_account_email` | Email of the service account (created or provided) |
| `service_account_created` | Whether a service account was created by the module |
| `service_account_name` | Full resource name of created service account |
| `service_account_unique_id` | Unique ID of created service account |

### Instance Outputs

| Output | Description |
|--------|-------------|
| `instances` | Map of all instances with comprehensive details |
| `instance_ids` | List of server-assigned instance IDs |
| `instance_names` | List of instance names |
| `instance_internal_ips` | Map of instance names to private IPs |
| `instance_zones` | Map of instance names to zones |

### Other Outputs

| Output | Description |
|--------|-------------|
| `instance_groups` | Map of instance groups by zone (if created) |
| `data_disks` | Map of all data disks created |
| `os_type` | Operating system deployed |

For complete output documentation, see [outputs.tf](./outputs.tf).

## High Availability Architecture

### Single Zone (Basic)
```
Region: us-central1
  Zone: us-central1-a
    └─ VM-01
```
- ❌ No zone redundancy
- ⚠️ Zone failure = downtime
- ✅ Use for: dev/test environments

### Multi-Zone (Recommended for Production)
```
Region: us-central1
  Zone: us-central1-a
    └─ VM-01 ──┐
  Zone: us-central1-b    │
    └─ VM-02 ──┼─→ Instance Group → Load Balancer
  Zone: us-central1-c    │
    └─ VM-03 ──┘
```
- ✅ Zone failure protection
- ✅ 99.99% SLA achievable
- ✅ Use for: production workloads

### Multi-Region (Maximum Availability)
```
Region: us-east1
  Zone: us-east1-a → VM-01 ──┐
  Zone: us-east1-b → VM-02 ──┼─→ Regional Instance Group
  Zone: us-east1-c → VM-03 ──┘

Region: us-west1
  Zone: us-west1-a → VM-04 ──┐
  Zone: us-west1-b → VM-05 ──┼─→ Regional Instance Group
  Zone: us-west1-c → VM-06 ──┘
          ↓
    Global Load Balancer
```
- ✅ Zone + Region failure protection
- ✅ Disaster recovery
- ✅ Use for: critical global services

## Per-Instance Overrides

Each instance can override module-level defaults:

```hcl
instances = [
  {
    name         = "vm-web-01"
    zone         = "us-central1-a"
    machine_type = "n2-standard-2"  # Override
    tags         = ["web", "public"]  # Override
    labels       = { tier = "web" }  # Override
    network_interfaces = [{ subnetwork = var.subnet_public }]  # Override
  },
  {
    name         = "vm-app-01"
    zone         = "us-central1-b"
    machine_type = "n2-standard-4"  # Different type
    tags         = ["app", "private"]  # Different tags
    labels       = { tier = "app" }
    network_interfaces = [{ subnetwork = var.subnet_private }]
  }
]

# Module-level defaults (used if not overridden)
machine_type = "n2-standard-2"
tags         = ["default"]
```

## Data Disks

### Single Data Disk
```hcl
data_disks = [
  {
    size = 500
    type = "hyperdisk-balanced"
  }
]
```

Each VM gets a 500GB disk at `D:` (Windows) or `/data` (Linux).

### Multiple Data Disks
```hcl
data_disks = [
  {
    name = "app-data"
    size = 500
    type = "pd-ssd"
    labels = { purpose = "application" }
  },
  {
    name = "logs"
    size = 200
    type = "pd-balanced"
    labels = { purpose = "logs" }
  }
]
```

Each VM gets:
- `{vm-name}-datadisk-0` (500GB SSD) at `D:`
- `{vm-name}-datadisk-1` (200GB Balanced) at `E:`

## Network Configuration

### Best Practice: Subnet-Mode VPCs

For modern VPCs, **specify only `subnetwork`** (network is inferred):

```hcl
network_interfaces = [{
  subnetwork = "projects/PROJECT/regions/REGION/subnetworks/SUBNET"
  # network parameter omitted for subnet-mode VPCs
}]
```

### DHCP vs Static IP

**DHCP (Recommended for dev/test):**
```hcl
network_interfaces = [{
  subnetwork = dependency.vpc.outputs.subnet_self_link
  # network_ip omitted = IP assigned via DHCP
}]
```

**Static IP (For production databases, domain controllers):**
```hcl
network_interfaces = [{
  subnetwork = dependency.vpc.outputs.subnet_self_link
  network_ip = "10.0.1.50"  # Static private IP
}]
```

### Multi-Region Networking

When deploying VMs across multiple regions, ensure each region has appropriate subnets:

```hcl
instances = [
  {
    name = "vm-us-south-01"
    zone = "us-south1-a"
    network_interfaces = [
      {
        subnetwork = dependency.vpc.outputs.subnets["us-south1"].self_link
      }
    ]
  },
  {
    name = "vm-us-east-01"
    zone = "us-east1-b"
    network_interfaces = [
      {
        subnetwork = dependency.vpc.outputs.subnets["us-east1"].self_link
      }
    ]
  }
]
```

## Outbound Internet Access

VMs need internet access for Windows Updates, software downloads, etc. Use **Cloud NAT**:

```terraform
resource "google_compute_router" "nat_router" {
  name    = "nat-router"
  region  = "us-central1"
  network = google_compute_network.vpc.id
}

resource "google_compute_router_nat" "nat_config" {
  name                               = "nat-config"
  router                             = google_compute_router.nat_router.name
  region                             = google_compute_router.nat_router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
```

**Multi-Region Deployments**: Deploy Cloud NAT in each region where you have VMs for optimal performance and regional redundancy.

## Security Features

- **Private IPs Only**: No public IP addresses (security policy enforced)
- **Shielded VMs**: vTPM and integrity monitoring enabled by default
- **Encryption**: Support for customer-managed encryption keys (CMEK)
- **Service Accounts**: Attach custom service accounts with limited scopes
- **Bucket-Specific IAM**: Principle of least privilege for storage access
- **Deletion Protection**: Optional protection against accidental deletion
- **Network Segmentation**: Deploy VMs in dedicated subnets with proper firewall rules
- **Least Privilege**: Use minimal IAM permissions and service account scopes

### Security Best Practices

1. **No Public IPs**: This module intentionally does not support public IPs
2. **IAP Access**: Use Identity-Aware Proxy for secure, audited access
3. **User-Managed Service Accounts**: Create dedicated SAs instead of using default compute SA
4. **Bucket-Specific Permissions**: Use `storage_bucket_name` parameter for targeted access
5. **CMEK Encryption**: Enable customer-managed encryption keys for data-at-rest encryption
6. **Network Isolation**: Deploy VMs in dedicated subnets with strict firewall rules
7. **Service Account Scopes**: Module automatically uses `cloud-platform` scope when creating SAs

## Best Practices

### 1. Use User-Managed Service Accounts
Create dedicated service accounts instead of using default compute SA:

```terraform
create_service_account = true
service_account_config = {
  account_id   = "vm-app-sa"
  display_name = "Application VM Service Account"
  project_roles = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter"
  ]
}

# Grant bucket access if needed
storage_bucket_name = "app-data-bucket"
storage_bucket_role = "roles/storage.objectAdmin"
```

### 2. Enable Shielded VM
Use Shielded VM features for enhanced security:

```terraform
shielded_instance_config = {
  enable_secure_boot          = true
  enable_vtpm                 = true
  enable_integrity_monitoring = true
}
```

### 3. Use Resource Labels
Label resources for cost tracking and organization:

```terraform
labels = {
  environment = "production"
  application = "web-server"
  cost-center = "engineering"
  region      = "primary"
}
```

### 4. Enable Deletion Protection
Protect production VMs from accidental deletion:

```terraform
deletion_protection = true
```

### 5. Implement Backup Policies
Use snapshot schedules for disaster recovery:

```terraform
resource_policies = [google_compute_resource_policy.daily_backup.self_link]
```

### 6. Multi-Zone Deployment for High Availability
Deploy at least 3 VMs across different zones for 99.99% SLA:

```terraform
instances = [
  { name = "vm-01", zone = "us-central1-a", ... },
  { name = "vm-02", zone = "us-central1-b", ... },
  { name = "vm-03", zone = "us-central1-c", ... }
]

create_instance_groups = true
```

### 7. Machine Type Selection
Use appropriate machine types for your workload:

- **Development**: `n2-standard-2` (2 vCPU, 8GB RAM)
- **Production Web**: `n2-standard-4` (4 vCPU, 16GB RAM)
- **Database**: `n2-standard-8` or `n2-highmem-8` (8 vCPU, 32-64GB RAM)

### 8. Disk Type Selection

- **Boot Disk**: `hyperdisk-balanced` (default, good performance/cost ratio)
- **Application Data**: `pd-ssd` (high performance)
- **Backups/Archives**: `pd-standard` (cost-effective)

### 9. Storage Access Pattern
For Cloud Storage access:

- Create dedicated service account per application/environment
- Use bucket-specific IAM bindings (not project-wide roles)
- Use `roles/storage.objectAdmin` for rclone (provides all needed permissions)
- Let module handle VM scopes automatically (sets `cloud-platform`)

## Terragrunt Integration

See the included example configurations:
- `terragrunt-usage-examples.hcl` - Comprehensive examples including service account and storage access patterns
- `terragrunt-2vms.hcl` - Simple 2-VM deployment
- `terragrunt-3vms.hcl` - 3-VM high availability setup with instance groups
- `terragrunt-6vms-multiregion.hcl` - Multi-region deployment across 2 regions

For detailed multi-region deployment guidance, see `MULTI_REGION_GUIDE.md`.

## Troubleshooting

### Cannot Connect to VM

**Issue**: Unable to access VM remotely

**Solution**: 
1. Verify VMs have private IPs only (as designed)
2. Use Identity-Aware Proxy (IAP) for RDP/SSH access
3. Check IAP firewall rule allows `35.235.240.0/20` to appropriate ports
4. Verify IAM permissions include `roles/iap.tunnelResourceAccessor`
5. Alternative: Use VPN or Cloud Interconnect for private network access

### VM Cannot Access Internet

**Issue**: Windows Updates fail, cannot download software

**Solution**: 
1. Verify Cloud NAT is configured in the VM's region
2. Check NAT router is attached to correct VPC
3. Ensure NAT is configured for the subnet where VMs reside
4. Review NAT logs: `gcloud compute routers get-nat-mapping-info`
5. For multi-region: Ensure Cloud NAT exists in each region

### Storage Access Denied

**Issue**: VM cannot access Cloud Storage bucket despite service account having permissions

**Solution**:
1. Verify service account is attached: `gcloud compute instances describe VM_NAME --format="value(serviceAccounts[0].email)"`
2. Check VM scopes include cloud-platform: `gcloud compute instances describe VM_NAME --format="value(serviceAccounts[0].scopes)"`
3. Verify bucket IAM binding: `gsutil iam get gs://BUCKET_NAME`
4. Test from VM: `gcloud auth list` should show the service account
5. If using existing SA, ensure you passed `scopes = ["cloud-platform"]`

### rclone Mount Fails

**Issue**: Cannot mount bucket with rclone/WinFsp

**Solution**:
1. Verify WinFsp is installed: `Get-Package -Name "WinFsp"`
2. Verify rclone can list bucket: `rclone ls gcs:BUCKET_NAME`
3. Check rclone configuration: `rclone config show`
4. Verify service account permissions: `gsutil iam get gs://BUCKET_NAME`
5. Check rclone logs: `rclone mount gcs:BUCKET --log-file=C:\rclone.log --log-level DEBUG`

### Startup Script Not Running

**Issue**: PowerShell/bash script in metadata doesn't execute

**Solution**:
1. Check serial console: `gcloud compute instances get-serial-port-output`
2. For Windows: Verify script uses `startup_script` variable (automatically sets correct metadata key)
3. For Linux: Verify script uses bash syntax
4. Scripts run once on first boot by default
5. Check for syntax errors in the script

### Instance Group Empty

**Issue**: Instance group shows 0 instances

**Solution**:
1. Verify `create_instance_groups = true` is set
2. Check that VMs have been created successfully
3. Instance groups are created after VMs - check dependency timing
4. Review Terraform state: `terraform state list | grep instance_group`

### Disk Not Attached

**Issue**: Data disk not visible in OS

**Solution**:
1. For Windows: Run startup script to initialize and format disks
2. Check disk is attached: `gcloud compute instances describe VM_NAME`
3. Verify data_disks configuration is correct
4. Check for disk naming conflicts
5. Review instance creation logs for errors

### Multi-Region Subnet Issues

**Issue**: VMs in different regions can't use same subnet

**Solution**:
1. Subnets are regional - each region needs its own subnet
2. Ensure VPC has subnets in all required regions
3. Verify `network_interfaces` specify correct regional subnet
4. Check dependency outputs provide correct subnet references

## License

This module is maintained by Uber Freight SE Team
# Multi-Region Deployment Guide

This guide explains how to deploy VMs across multiple regions for disaster recovery and high availability.

## Overview

Yes, the module **fully supports** deploying VMs across multiple regions. You can deploy any number of VMs in any combination of zones and regions. For example:

- **Primary Region**: 3 VMs in us-south1 (zones a, b, c)
- **Secondary Region**: 3 VMs in us-east1 (zones b, c, d)

The module will automatically:
1. Create VMs in their specified zones/regions
2. Create one unmanaged instance group per unique zone (6 instance groups total in this example)
3. Attach appropriate subnets for each region

## Architecture Diagram

```
Primary Region: us-south1
├── Zone: us-south1-a
│   ├── VM: vmgwptmsfdxd01
│   └── Instance Group: ig-ptms-dev-us-south1-a
├── Zone: us-south1-b
│   ├── VM: vmgwptmsfdxd02
│   └── Instance Group: ig-ptms-dev-us-south1-b
└── Zone: us-south1-c
    ├── VM: vmgwptmsfdxd03
    └── Instance Group: ig-ptms-dev-us-south1-c

Secondary Region: us-east1
├── Zone: us-east1-b
│   ├── VM: vmgwptmsfdxe01
│   └── Instance Group: ig-ptms-dev-us-east1-b
├── Zone: us-east1-c
│   ├── VM: vmgwptmsfdxe02
│   └── Instance Group: ig-ptms-dev-us-east1-c
└── Zone: us-east1-d
    ├── VM: vmgwptmsfdxe03
    └── Instance Group: ig-ptms-dev-us-east1-d

Global Load Balancer
├── Backend Service (Primary)
│   ├── ig-ptms-dev-us-south1-a
│   ├── ig-ptms-dev-us-south1-b
│   └── ig-ptms-dev-us-south1-c
└── Backend Service (Secondary/Failover)
    ├── ig-ptms-dev-us-east1-b
    ├── ig-ptms-dev-us-east1-c
    └── ig-ptms-dev-us-east1-d
```

## Key Considerations

### 1. Network Configuration

Each region needs its own subnet. Your dependency block should provide subnets for both regions:

```hcl
dependency "vpc" {
  config_path = "../../../../freight-network-host/environments/dev/vpc"
}

# Usage in network_interfaces:
# Primary Region
subnetwork = dependency.vpc.outputs.tmobile-ptms-compute-dev["us-south1"].self_link

# Secondary Region  
subnetwork = dependency.vpc.outputs.tmobile-ptms-compute-dev["us-east1"].self_link
```

### 2. Instance Groups Per Zone

The module creates **one instance group per unique zone**, not per region. This is intentional because:

- Load balancers require zone-level instance groups
- This provides maximum flexibility for traffic distribution
- You can group instance groups by region in your load balancer configuration

For the 6-VM example:
- **6 zones** → **6 instance groups**
- Primary region zones: 3 instance groups
- Secondary region zones: 3 instance groups

### 3. Load Balancer Configuration

After deploying VMs with instance groups, you would configure a global load balancer:

```hcl
# Example load balancer backend configuration (separate module)
resource "google_compute_backend_service" "primary" {
  name = "backend-primary-us-south1"
  
  backend {
    group = module.compute.instance_groups_by_zone["us-south1-a"]
  }
  backend {
    group = module.compute.instance_groups_by_zone["us-south1-b"]
  }
  backend {
    group = module.compute.instance_groups_by_zone["us-south1-c"]
  }
  
  health_checks = [google_compute_health_check.http.self_link]
}

resource "google_compute_backend_service" "secondary" {
  name = "backend-secondary-us-east1"
  
  backend {
    group = module.compute.instance_groups_by_zone["us-east1-b"]
  }
  backend {
    group = module.compute.instance_groups_by_zone["us-east1-c"]
  }
  backend {
    group = module.compute.instance_groups_by_zone["us-east1-d"]
  }
  
  health_checks = [google_compute_health_check.http.self_link]
}
```

### 4. Data Replication

For true disaster recovery, you'll need to handle data replication between regions:

- **Option 1**: Application-level replication
- **Option 2**: Database replication (Cloud SQL, Spanner)
- **Option 3**: File-level replication (custom scripts, third-party tools)
- **Option 4**: Persistent disk snapshots and cross-region restoration

### 5. Naming Conventions

Use clear naming conventions to distinguish regions:

```hcl
# Primary Region: us-south1
name = "vmgwptmsfdxd01"  # 'd' for us-south (dallas)

# Secondary Region: us-east1  
name = "vmgwptmsfdxe01"  # 'e' for us-east
```

## Example Configurations

### Scenario 1: Active-Active Multi-Region (6 VMs)

See `terragrunt-6vms-multiregion.hcl` for a complete example with:
- 3 VMs in us-south1 (primary)
- 3 VMs in us-east1 (secondary)
- Instance groups enabled
- Per-region labels for organization

### Scenario 2: Active-Passive Multi-Region

```hcl
instances = [
  # Active Region: us-south1 (3 VMs)
  { name = "vm-primary-01", zone = "us-south1-a", ... },
  { name = "vm-primary-02", zone = "us-south1-b", ... },
  { name = "vm-primary-03", zone = "us-south1-c", ... },
  
  # Passive Region: us-east1 (1 standby VM)
  { 
    name = "vm-standby-01", 
    zone = "us-east1-b",
    tags = ["standby", "disaster-recovery"],
    ...
  }
]
```

### Scenario 3: Multi-Region with Different Machine Types

```hcl
machine_type = "n2-standard-2"  # Default for primary region

instances = [
  # Primary Region: Standard instances
  { name = "vm-primary-01", zone = "us-south1-a" },
  { name = "vm-primary-02", zone = "us-south1-b" },
  { name = "vm-primary-03", zone = "us-south1-c" },
  
  # Secondary Region: Smaller instances (cost optimization)
  { 
    name = "vm-secondary-01", 
    zone = "us-east1-b",
    machine_type = "e2-medium"  # Override for cost savings
  },
  { 
    name = "vm-secondary-02", 
    zone = "us-east1-c",
    machine_type = "e2-medium"
  },
  { 
    name = "vm-secondary-03", 
    zone = "us-east1-d",
    machine_type = "e2-medium"
  }
]
```

## Output Usage for Multi-Region

```hcl
# Get all instance groups by zone
output "all_instance_groups" {
  value = module.compute.instance_groups_by_zone
}
# Returns:
# {
#   "us-south1-a" = "projects/.../instanceGroups/ig-ptms-dev-us-south1-a"
#   "us-south1-b" = "projects/.../instanceGroups/ig-ptms-dev-us-south1-b"
#   "us-south1-c" = "projects/.../instanceGroups/ig-ptms-dev-us-south1-c"
#   "us-east1-b"  = "projects/.../instanceGroups/ig-ptms-dev-us-east1-b"
#   "us-east1-c"  = "projects/.../instanceGroups/ig-ptms-dev-us-east1-c"
#   "us-east1-d"  = "projects/.../instanceGroups/ig-ptms-dev-us-east1-d"
# }

# Filter instance groups by region using local processing
locals {
  primary_region_igs = {
    for zone, ig in module.compute.instance_groups_by_zone :
    zone => ig if startswith(zone, "us-south1")
  }
  
  secondary_region_igs = {
    for zone, ig in module.compute.instance_groups_by_zone :
    zone => ig if startswith(zone, "us-east1")
  }
}

# Get instances by region
output "primary_region_vms" {
  value = {
    for name, vm in module.compute.instances :
    name => vm if startswith(vm.zone, "us-south1")
  }
}
```

## Best Practices

1. **Network Connectivity**: Ensure VPC subnets exist in all target regions
2. **Latency Awareness**: Place VMs close to your users and data sources
3. **Cost Optimization**: Consider region-specific pricing differences
4. **Disaster Recovery Planning**: Document failover procedures
5. **Testing**: Regularly test failover between regions
6. **Monitoring**: Set up region-specific monitoring and alerting
7. **Backup Strategy**: Implement cross-region backup and recovery

## Cost Considerations

- **Egress costs**: Data transfer between regions incurs charges
- **Region pricing**: Some regions are more expensive than others
- **Storage replication**: Cross-region replication costs
- **Load balancer costs**: Global load balancers have higher costs than regional

## Limitations and Gotchas

1. **No automatic data replication**: The module creates VMs but doesn't replicate data
2. **Subnet management**: You must have subnets pre-configured in all regions
3. **Single module state**: All VMs are in one Terraform state (consider splitting for very large deployments)
4. **Instance group naming**: Automatic naming by zone (no region grouping)

## FAQ

**Q: Can I deploy VMs in different projects across regions?**
A: No, the module uses a single `project_id`. For multi-project deployments, call the module multiple times.

**Q: Can I have different data disks per region?**
A: Currently, all VMs get the same data disks. To have different configurations, use separate module calls.

**Q: How do I update VMs in one region without affecting the other?**
A: Use Terraform targeting: `terragrunt apply -target=module.compute.google_compute_instance.vms[\"vm-primary-01\"]`

**Q: Can I use this with Google Cloud Armor?**
A: Yes, instance groups work with Cloud Armor through load balancers.

## See Also

- `terragrunt-6vms-multiregion.hcl` - Complete 6-VM multi-region example
- `README.md` - Full module documentation
- `MIGRATION.md` - Migration guide from single-VM module
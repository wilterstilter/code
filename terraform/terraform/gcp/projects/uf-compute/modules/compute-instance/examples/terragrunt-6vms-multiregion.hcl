include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-compute/modules/compute-instance"
}

include "common" {
    path = find_in_parent_folders("common.hcl")
    expose = true
}

dependency "vpc" {
  config_path = "../../../../freight-network-host/environments/dev/vpc"
}

inputs = {
  project_id   = "uf-compute-d"
  machine_type = "n2-standard-2"  # Default machine type for all VMs (2 vCPU, 8GB RAM)

  # Set OS type - automatically configures 100GB pd-balanced boot disk
  os_type = "windows2025"

  # Deploy 6 VMs across 2 regions for disaster recovery and high availability
  # Primary Region: us-south1 (3 VMs in 3 zones)
  # Secondary Region: us-east1 (3 VMs in 3 zones)
  instances = [
    # Primary Region: us-south1
    {
      name = "vmgwptmsfdxd01"
      zone = "us-south1-a"
      network_interfaces = [
        {
          subnetwork = dependency.vpc.outputs.tmobile-ptms-compute-dev["us-south1"].self_link
        }
      ]
      labels = {
        region = "primary"
        region_name = "us-south1"
      }
    },
    {
      name = "vmgwptmsfdxd02"
      zone = "us-south1-b"
      network_interfaces = [
        {
          subnetwork = dependency.vpc.outputs.tmobile-ptms-compute-dev["us-south1"].self_link
        }
      ]
      labels = {
        region = "primary"
        region_name = "us-south1"
      }
    },
    {
      name = "vmgwptmsfdxd03"
      zone = "us-south1-c"
      network_interfaces = [
        {
          subnetwork = dependency.vpc.outputs.tmobile-ptms-compute-dev["us-south1"].self_link
        }
      ]
      labels = {
        region = "primary"
        region_name = "us-south1"
      }
    },
    # Secondary Region: us-east1
    {
      name = "vmgwptmsfdxe01"
      zone = "us-east1-b"
      network_interfaces = [
        {
          subnetwork = dependency.vpc.outputs.tmobile-ptms-compute-dev["us-east1"].self_link
        }
      ]
      labels = {
        region = "secondary"
        region_name = "us-east1"
      }
    },
    {
      name = "vmgwptmsfdxe02"
      zone = "us-east1-c"
      network_interfaces = [
        {
          subnetwork = dependency.vpc.outputs.tmobile-ptms-compute-dev["us-east1"].self_link
        }
      ]
      labels = {
        region = "secondary"
        region_name = "us-east1"
      }
    },
    {
      name = "vmgwptmsfdxe03"
      zone = "us-east1-d"
      network_interfaces = [
        {
          subnetwork = dependency.vpc.outputs.tmobile-ptms-compute-dev["us-east1"].self_link
        }
      ]
      labels = {
        region = "secondary"
        region_name = "us-east1"
      }
    }
  ]

  # Enable unmanaged instance groups for load balancer backends
  # This will create 6 instance groups total:
  # - ig-ptms-dev-us-south1-a (contains vmgwptmsfdxd01)
  # - ig-ptms-dev-us-south1-b (contains vmgwptmsfdxd02)
  # - ig-ptms-dev-us-south1-c (contains vmgwptmsfdxd03)
  # - ig-ptms-dev-us-east1-b (contains vmgwptmsfdxe01)
  # - ig-ptms-dev-us-east1-c (contains vmgwptmsfdxe02)
  # - ig-ptms-dev-us-east1-d (contains vmgwptmsfdxe03)
  create_instance_groups = true
  instance_group_name_prefix = "ig-ptms-dev"
  
  # Configure named ports for load balancer health checks
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

  # Data disk (D:) - 100GB, created and attached automatically to each VM
  data_disks = [
    {
      size = 100
      type = "pd-balanced"
      labels = {
        disk-purpose = "data"
        environment  = "dev"
      }
    }
  ]

  # Default tags applied to all VMs
  tags = ["windows", "dev", "ha-enabled", "multi-region"]

  # Shielded VM configuration - Safe for testing with Secure Boot OFF
  shielded_instance_config = {
    enable_secure_boot          = false
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  # Format and mount the D: drive on first boot
  startup_script = <<-EOT
    Write-Host "=== Windows Server 2025 First Boot Configuration ==="
    Write-Host "VM: $env:computername"
    Write-Host "Disk Layout: C: (100GB OS) + D: (100GB Data)"
    Write-Host ""
    Write-Host "Checking for uninitialized disks..."
    
    $rawDisks = Get-Disk | Where-Object PartitionStyle -eq 'RAW'
    
    if ($rawDisks) {
      foreach ($disk in $rawDisks) {
        Write-Host "Found uninitialized disk: Number $($disk.Number), Size $([math]::Round($disk.Size/1GB, 2)) GB"
        
        # Initialize disk with GPT
        Write-Host "Initializing disk $($disk.Number) with GPT partition style..."
        Initialize-Disk -Number $disk.Number -PartitionStyle GPT -PassThru | Out-Null
        
        # Create partition with D: drive letter
        Write-Host "Creating partition and assigning drive letter D:..."
        New-Partition -DiskNumber $disk.Number -UseMaximumSize -DriveLetter D | Out-Null
        
        # Format with NTFS - 64KB allocation for performance
        Write-Host "Formatting D: with NTFS (64KB allocation unit)..."
        Format-Volume -DriveLetter D -FileSystem NTFS `
          -NewFileSystemLabel "Data" -AllocationUnitSize 64KB `
          -Confirm:$false | Out-Null
        
        Write-Host "SUCCESS: Data disk D: is ready (100GB)"
        Write-Host "  Drive Letter: D:"
        Write-Host "  File System: NTFS"
        Write-Host "  Allocation Unit: 64KB"
        Write-Host ""
        
        # Create standard directory structure
        Write-Host "Creating standard directory structure on D:..."
        New-Item -Path "D:\Data" -ItemType Directory -Force | Out-Null
        New-Item -Path "D:\Logs" -ItemType Directory -Force | Out-Null
        New-Item -Path "D:\Temp" -ItemType Directory -Force | Out-Null
        
        Write-Host "Directory structure created:"
        Write-Host "  D:\Data  - Application data"
        Write-Host "  D:\Logs  - Log files"
        Write-Host "  D:\Temp  - Temporary files"
      }
    } else {
      Write-Host "No uninitialized disks found."
      
      # Verify D: drive exists
      if (Test-Path "D:\") {
        Write-Host "D: drive already available and mounted."
        
        # Show disk info
        $dDisk = Get-Volume -DriveLetter D
        Write-Host "D: Drive Status:"
        Write-Host "  Size: $([math]::Round($dDisk.Size/1GB, 2)) GB"
        Write-Host "  Free Space: $([math]::Round($dDisk.SizeRemaining/1GB, 2)) GB"
        Write-Host "  File System: $($dDisk.FileSystem)"
      } else {
        Write-Host "WARNING: No D: drive found. Check disk attachment."
      }
    }
    
    Write-Host ""
    Write-Host "=== Configuration Complete ==="
    Write-Host "System is ready for use."
    Write-Host "This VM is part of a multi-region high-availability cluster."
  EOT

  labels = {
    environment = "dev"
    managed-by  = "terragrunt"
    ha-enabled  = "true"
    multi-region = "true"
    tier        = "frontend"
  }
}

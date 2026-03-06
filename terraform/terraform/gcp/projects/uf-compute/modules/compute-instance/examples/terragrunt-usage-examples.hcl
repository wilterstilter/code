# =============================================================================
# Terragrunt Usage Examples - GCP VM Module (Windows 2025 & RHEL 10)
# =============================================================================
# Updated for multi-VM module with high availability and service account support
# Shows various configurations: single VM, multi-VM, multi-zone, storage access, with/without instance groups
# =============================================================================

# =============================================================================
# SINGLE VM EXAMPLES
# =============================================================================

# =============================================================================
# Example 1: Basic Windows Server 2025 VM - Single 200GB Data Disk
# =============================================================================
# File: environments/dev/windows-vm-basic/terragrunt.hcl
# Disk Layout: C: (100GB OS) + D: (200GB data)
# Deployment: Single VM in one zone

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
  machine_type = "n4-standard-4"  # 4 vCPU, 16GB RAM
  
  os_type = "windows2025"

  # Single VM deployment
  instances = [
    {
      name = "vmwinsvr01"
      zone = "us-south1-a"
      network_interfaces = [
        {
          subnetwork = dependency.vpc.outputs.iaas_vms_subnet["us-south1"].self_link
        }
      ]
    }
  ]

  # Single data disk (D:) - 200GB
  data_disks = [
    {
      size = 200
      type = "hyperdisk-balanced"
      labels = {
        disk-purpose = "data"
        environment  = "dev"
      }
    }
  ]

  tags = ["windows", "dev"]

  # Format and mount D: drive
  startup_script = <<-EOT
    Write-Host "=== Windows Server 2025 Configuration ==="
    Write-Host "Disk Layout: C: (OS 100GB) + D: (Data 200GB)"
    
    $rawDisks = Get-Disk | Where-Object PartitionStyle -eq 'RAW'
    
    if ($rawDisks) {
      foreach ($disk in $rawDisks) {
        Write-Host "Initializing disk $($disk.Number)..."
        Initialize-Disk -Number $disk.Number -PartitionStyle GPT -PassThru | Out-Null
        New-Partition -DiskNumber $disk.Number -UseMaximumSize -DriveLetter D | Out-Null
        Format-Volume -DriveLetter D -FileSystem NTFS `
          -NewFileSystemLabel "Data" -AllocationUnitSize 64KB `
          -Confirm:$false | Out-Null
        Write-Host "SUCCESS: D: drive ready (200GB)"
      }
      
      # Create directory structure
      New-Item -Path "D:\Data" -ItemType Directory -Force | Out-Null
      New-Item -Path "D:\Logs" -ItemType Directory -Force | Out-Null
      Write-Host "Directory structure created on D:"
    }
    
    Write-Host "=== Configuration Complete ==="
  EOT

  labels = {
    environment = "dev"
    managed-by  = "terragrunt"
  }
}


# =============================================================================
# Example 2: Windows Server 2025 with Cloud Storage Access (rclone)
# =============================================================================
# File: environments/dev/windows-vm-storage/terragrunt.hcl
# Purpose: VM with access to Cloud Storage bucket for file storage
# Use Case: Shared file storage, backup destination, data processing
# Configuration: Creates dedicated service account with bucket-specific permissions

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
  machine_type = "n2-standard-4"
  
  os_type = "windows2025"

  # Single VM with storage access
  instances = [
    {
      name = "vmstorageapp01"
      zone = "us-south1-a"
      network_interfaces = [
        {
          subnetwork = dependency.vpc.outputs.iaas_vms_subnet["us-south1"].self_link
        }
      ]
    }
  ]

  # =============================================================================
  # SERVICE ACCOUNT CONFIGURATION - Cloud Storage Access
  # =============================================================================
  # Create a dedicated user-managed service account for storage access
  create_service_account = true
  
  service_account_config = {
    account_id   = "vm-storage-access-sa"  # 6-30 chars, lowercase, digits, hyphens
    display_name = "VM Storage Access Service Account"
    description  = "Service account for VM to access Cloud Storage via rclone"
    
    # Project-level roles (for logging and monitoring - NOT for storage access)
    project_roles = [
      "roles/logging.logWriter",      # Write logs to Cloud Logging
      "roles/monitoring.metricWriter" # Write metrics to Cloud Monitoring
    ]
  }
  
  # =============================================================================
  # STORAGE BUCKET ACCESS
  # =============================================================================
  # Grant the service account access to a specific Cloud Storage bucket
  # This uses bucket-specific IAM binding (principle of least privilege)
  storage_bucket_name = "my-app-data-bucket"  # ← UPDATE to your bucket name
  
  # roles/storage.objectAdmin provides:
  # - storage.objects.get (read)
  # - storage.objects.list (list)
  # - storage.objects.create (write/upload)
  # - storage.objects.delete (delete)
  # - storage.buckets.get (required for rclone initialization)
  storage_bucket_role = "roles/storage.objectAdmin"
  
  # NOTE: VM scopes are automatically set to 'cloud-platform' when 
  # create_service_account = true. This ensures IAM is the only limiter.

  # Data disk for local data processing
  data_disks = [
    {
      size = 500
      type = "hyperdisk-balanced"
      labels = {
        disk-purpose = "data"
        environment  = "dev"
      }
    }
  ]

  tags = ["windows", "dev", "storage-access"]

  # Startup script: Initialize disk only (rclone setup handled by Ansible)
  startup_script = <<-EOT
    Write-Host "=== Windows Server 2025 with Cloud Storage Access ==="
    Write-Host "Service Account: VM will use attached SA for storage access"
    
    # Initialize data disk as D:
    $rawDisks = Get-Disk | Where-Object PartitionStyle -eq 'RAW'
    if ($rawDisks) {
      foreach ($disk in $rawDisks) {
        Write-Host "Initializing disk $($disk.Number)..."
        Initialize-Disk -Number $disk.Number -PartitionStyle GPT -PassThru | Out-Null
        New-Partition -DiskNumber $disk.Number -UseMaximumSize -DriveLetter D | Out-Null
        Format-Volume -DriveLetter D -FileSystem NTFS `
          -NewFileSystemLabel "Data" -AllocationUnitSize 64KB `
          -Confirm:$false | Out-Null
        Write-Host "SUCCESS: D: drive ready"
      }
    }
    
    # Create directories for rclone mount point
    New-Item -Path "D:\CloudStorage" -ItemType Directory -Force | Out-Null
    Write-Host "Cloud storage mount point created at D:\CloudStorage"
    
    # Verify service account (for troubleshooting)
    Write-Host "`nVerifying service account configuration..."
    $metadata = Invoke-RestMethod -Headers @{"Metadata-Flavor"="Google"} `
      -Uri "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/email"
    Write-Host "Attached Service Account: $metadata"
    
    Write-Host "`n=== Next Steps ==="
    Write-Host "1. Install rclone and WinFsp via Ansible or manually"
    Write-Host "2. Configure rclone (uses VM's service account automatically)"
    Write-Host "3. Mount bucket: rclone mount gcs:my-app-data-bucket Z: --daemon"
    Write-Host "=== Configuration Complete ==="
  EOT

  labels = {
    environment = "dev"
    app-type    = "storage-access"
    managed-by  = "terragrunt"
  }
}


# =============================================================================
# Example 3: Windows Server 2025 with IIS - Two Data Disks
# =============================================================================
# File: environments/dev/windows-web-server/terragrunt.hcl
# Disk Layout: C: (100GB OS) + D: (200GB web content) + E: (100GB logs)
# Deployment: Single VM with static IP

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
  machine_type = "n2-standard-2"
  
  os_type = "windows2025"

  # Single VM with static IP
  instances = [
    {
      name = "vmwebiis01"
      zone = "us-south1-a"
      network_interfaces = [
        {
          subnetwork = dependency.vpc.outputs.iaas_vms_subnet["us-south1"].self_link
          network_ip = "10.0.1.10"  # Static IP for web server
        }
      ]
    }
  ]

  # Two data disks - D: for web content, E: for logs
  data_disks = [
    {
      name = "web-content"
      size = 200
      type = "pd-ssd"
      labels = {
        disk-purpose = "web-content"
        environment  = "dev"
      }
    },
    {
      name = "logs"
      size = 100
      type = "pd-balanced"
      labels = {
        disk-purpose = "logs"
        environment  = "dev"
      }
    }
  ]

  tags = ["windows", "web-server", "dev"]

  # Install IIS and configure disks
  startup_script = <<-EOT
    Write-Host "=== Windows Web Server Configuration ==="
    Write-Host "Disk Layout: C: (OS 100GB) + D: (Web 200GB) + E: (Logs 100GB)"
    
    $rawDisks = Get-Disk | Where-Object PartitionStyle -eq 'RAW'
    $driveLetters = @('D', 'E')
    $labels = @('WebContent', 'Logs')
    
    if ($rawDisks) {
      $index = 0
      foreach ($disk in $rawDisks) {
        $letter = $driveLetters[$index]
        $label = $labels[$index]
        
        Write-Host "Initializing disk $($disk.Number) as ${letter}:..."
        Initialize-Disk -Number $disk.Number -PartitionStyle GPT -PassThru | Out-Null
        New-Partition -DiskNumber $disk.Number -UseMaximumSize -DriveLetter $letter | Out-Null
        Format-Volume -DriveLetter $letter -FileSystem NTFS `
          -NewFileSystemLabel $label -AllocationUnitSize 64KB `
          -Confirm:$false | Out-Null
        Write-Host "SUCCESS: ${letter}: drive ready"
        $index++
      }
    }
    
    Write-Host "Installing IIS..."
    Install-WindowsFeature -Name Web-Server -IncludeManagementTools | Out-Null
    Install-WindowsFeature -Name Web-Asp-Net45 | Out-Null
    
    # Create directories on D: and E:
    New-Item -Path "D:\WebSites" -ItemType Directory -Force | Out-Null
    New-Item -Path "E:\IISLogs" -ItemType Directory -Force | Out-Null
    New-Item -Path "E:\AppLogs" -ItemType Directory -Force | Out-Null
    
    # Configure IIS to use D: drive
    Import-Module WebAdministration
    Set-ItemProperty "IIS:\Sites\Default Web Site" -Name physicalPath -Value "D:\WebSites"
    
    # Configure IIS logging to E: drive
    Set-ItemProperty "IIS:\Sites\Default Web Site" -Name logFile.directory -Value "E:\IISLogs"
    
    # Create welcome page
    @"
<!DOCTYPE html>
<html>
<head><title>Windows Server 2025 - IIS</title></head>
<body>
  <h1>Windows Server 2025 with IIS</h1>
  <p>Web Root: D:\WebSites</p>
  <p>Logs: E:\IISLogs</p>
</body>
</html>
"@ | Out-File "D:\WebSites\index.html"
    
    Write-Host "SUCCESS: IIS configured"
    Write-Host "  D:\WebSites - Web content"
    Write-Host "  E:\IISLogs  - IIS logs"
    Write-Host "  E:\AppLogs  - Application logs"
    Write-Host "=== Configuration Complete ==="
  EOT

  labels = {
    environment = "dev"
    role        = "web-server"
    managed-by  = "terragrunt"
  }

  shielded_instance_config = {
    enable_secure_boot          = false
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
}


# =============================================================================
# MULTI-VM EXAMPLES - SAME REGION & MULTI-REGION
# =============================================================================

# =============================================================================
# Example 4: Multi-Region Windows VMs with Shared Cloud Storage
# =============================================================================
# File: environments/prod/windows-multi-region-storage/terragrunt.hcl
# Purpose: 4 VMs across 2 regions sharing a single Cloud Storage bucket
# Use Case: Distributed application with centralized file storage
# Architecture: VMs in us-south1 and us-east4, all accessing shared bucket

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
  config_path = "../../../../freight-network-host/environments/prod/vpc"
}

inputs = {
  project_id   = "uf-compute-p"
  machine_type = "n2-standard-4"  # 4 vCPU, 16GB RAM
  
  os_type = "windows2025"

  # =============================================================================
  # 4 VMs ACROSS 2 REGIONS - All share same service account and bucket access
  # =============================================================================
  instances = [
    # Region 1: us-south1
    {
      name = "vmsouth01"
      zone = "us-south1-a"
      network_interfaces = [
        {
          subnetwork = dependency.vpc.outputs.compute_subnet["us-south1"].self_link
        }
      ]
    },
    {
      name = "vmsouth02"
      zone = "us-south1-b"
      network_interfaces = [
        {
          subnetwork = dependency.vpc.outputs.compute_subnet["us-south1"].self_link
        }
      ]
    },
    # Region 2: us-east4
    {
      name = "vmeast01"
      zone = "us-east4-a"
      network_interfaces = [
        {
          subnetwork = dependency.vpc.outputs.compute_subnet["us-east4"].self_link
        }
      ]
    },
    {
      name = "vmeast02"
      zone = "us-east4-b"
      network_interfaces = [
        {
          subnetwork = dependency.vpc.outputs.compute_subnet["us-east4"].self_link
        }
      ]
    }
  ]

  # =============================================================================
  # SHARED SERVICE ACCOUNT - All VMs use same SA for storage access
  # =============================================================================
  create_service_account = true
  
  service_account_config = {
    account_id   = "multi-region-storage-sa"
    display_name = "Multi-Region VM Storage Access"
    description  = "Shared service account for VMs in all regions to access centralized storage"
    
    project_roles = [
      "roles/logging.logWriter",
      "roles/monitoring.metricWriter"
    ]
  }
  
  # =============================================================================
  # SHARED CLOUD STORAGE BUCKET - Accessible from all VMs
  # =============================================================================
  storage_bucket_name = "shared-app-data-bucket"
  storage_bucket_role = "roles/storage.objectAdmin"

  # Data disks - each VM gets its own local storage
  data_disks = [
    {
      size = 500
      type = "hyperdisk-balanced"
      labels = {
        disk-purpose = "local-data"
        environment  = "prod"
      }
    }
  ]

  # Enable instance groups for high availability
  create_instance_groups = true
  instance_group_name_prefix = "ig-multiregion"

  tags = ["windows", "prod", "multi-region", "storage-access"]

  startup_script = <<-EOT
    Write-Host "=== Multi-Region VM with Shared Storage ==="
    Write-Host "VM: $env:COMPUTERNAME"
    
    # Initialize local data disk
    $rawDisks = Get-Disk | Where-Object PartitionStyle -eq 'RAW'
    if ($rawDisks) {
      foreach ($disk in $rawDisks) {
        Initialize-Disk -Number $disk.Number -PartitionStyle GPT -PassThru | Out-Null
        New-Partition -DiskNumber $disk.Number -UseMaximumSize -DriveLetter D | Out-Null
        Format-Volume -DriveLetter D -FileSystem NTFS `
          -NewFileSystemLabel "LocalData" -AllocationUnitSize 64KB `
          -Confirm:$false | Out-Null
        Write-Host "SUCCESS: D: drive ready (local storage)"
      }
    }
    
    # Create directory structure
    New-Item -Path "D:\LocalData" -ItemType Directory -Force | Out-Null
    New-Item -Path "D:\CloudMount" -ItemType Directory -Force | Out-Null
    
    Write-Host "`nStorage Configuration:"
    Write-Host "  D:\LocalData  - Local VM storage"
    Write-Host "  Z:\           - Cloud Storage (to be mounted via rclone)"
    Write-Host "`nAll VMs will mount the same shared bucket to Z: drive"
    Write-Host "=== Configuration Complete ==="
  EOT

  labels = {
    environment   = "prod"
    deployment    = "multi-region"
    storage-type  = "shared"
    managed-by    = "terragrunt"
  }

  shielded_instance_config = {
    enable_secure_boot          = false
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
}


# =============================================================================
# Example 5: Windows VMs with Existing Service Account and Storage Access
# =============================================================================
# File: environments/prod/windows-existing-sa/terragrunt.hcl
# Purpose: Use pre-existing service account instead of creating new one
# Use Case: Service account created by separate security/IAM team

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
  config_path = "../../../../freight-network-host/environments/prod/vpc"
}

inputs = {
  project_id   = "uf-compute-p"
  machine_type = "n2-standard-4"
  
  os_type = "windows2025"

  instances = [
    {
      name = "vmapp01"
      zone = "us-central1-a"
      network_interfaces = [
        {
          subnetwork = dependency.vpc.outputs.compute_subnet["us-central1"].self_link
        }
      ]
    }
  ]

  # =============================================================================
  # USE EXISTING SERVICE ACCOUNT (created externally)
  # =============================================================================
  # Note: create_service_account = false (default)
  
  service_account = {
    email = "existing-vm-sa@uf-compute-p.iam.gserviceaccount.com"
    # CRITICAL: Must include cloud-platform scope for full IAM control
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
  
  # =============================================================================
  # STORAGE BUCKET ACCESS (works with existing SA too)
  # =============================================================================
  # Module will still create the IAM binding on the bucket
  storage_bucket_name = "app-data-bucket"
  storage_bucket_role = "roles/storage.objectAdmin"

  data_disks = [
    {
      size = 500
      type = "pd-ssd"
    }
  ]

  tags = ["windows", "prod", "existing-sa"]

  labels = {
    environment = "prod"
    managed-by  = "terragrunt"
  }
}


# =============================================================================
# Example 6: Read-Only Storage Access for Backup/Archive VMs
# =============================================================================
# File: environments/prod/windows-backup-vm/terragrunt.hcl
# Purpose: VM with read-only access to backup storage bucket
# Use Case: Backup validation, archive access, data recovery

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
  config_path = "../../../../freight-network-host/environments/prod/vpc"
}

inputs = {
  project_id   = "uf-compute-p"
  machine_type = "n2-standard-2"
  
  os_type = "windows2025"

  instances = [
    {
      name = "vmbackup01"
      zone = "us-central1-a"
      network_interfaces = [
        {
          subnetwork = dependency.vpc.outputs.compute_subnet["us-central1"].self_link
        }
      ]
    }
  ]

  # Create service account for read-only access
  create_service_account = true
  
  service_account_config = {
    account_id   = "vm-backup-readonly-sa"
    display_name = "Backup VM Read-Only Service Account"
    description  = "Read-only access to backup storage bucket"
    
    project_roles = [
      "roles/logging.logWriter"
    ]
  }
  
  # =============================================================================
  # READ-ONLY STORAGE ACCESS
  # =============================================================================
  storage_bucket_name = "backup-archive-bucket"
  # roles/storage.objectViewer provides:
  # - storage.objects.get (read objects)
  # - storage.objects.list (list objects)
  # - storage.buckets.get (get bucket metadata)
  # NO write or delete permissions
  storage_bucket_role = "roles/storage.objectViewer"

  data_disks = [
    {
      size = 1000  # Large disk for temporary backup copies
      type = "pd-standard"  # Cost-effective for backups
    }
  ]

  tags = ["windows", "prod", "backup", "read-only"]

  labels = {
    environment = "prod"
    role        = "backup-access"
    managed-by  = "terragrunt"
  }
}


# =============================================================================
# Example 7: SQL Server VM with Separate Buckets for Data and Backups
# =============================================================================
# File: environments/prod/windows-sql-server/terragrunt.hcl
# Disk Layout: C: (100GB OS) + D: (500GB data) + E: (200GB logs) + F: (300GB temp)
# Storage: Separate buckets for database backups and application data
# Use Case: SQL Server with cloud-based backup storage

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
  config_path = "../../../../freight-network-host/environments/prod/vpc"
}

inputs = {
  project_id   = "uf-compute-p"
  machine_type = "n2-highmem-8"  # 8 vCPU, 64GB RAM for SQL Server
  
  os_type = "windows2025"

  instances = [
    {
      name = "vmsql01"
      zone = "us-central1-a"
      network_interfaces = [
        {
          subnetwork = dependency.vpc.outputs.database_subnet["us-central1"].self_link
          network_ip = "10.0.2.10"  # Static IP for SQL Server
        }
      ]
    }
  ]

  # Three data disks for SQL Server
  data_disks = [
    {
      name = "sql-data"
      size = 500
      type = "pd-ssd"
      labels = {
        disk-purpose = "sql-data"
        environment  = "prod"
      }
    },
    {
      name = "sql-logs"
      size = 200
      type = "pd-ssd"
      labels = {
        disk-purpose = "sql-logs"
        environment  = "prod"
      }
    },
    {
      name = "sql-tempdb"
      size = 300
      type = "pd-ssd"
      labels = {
        disk-purpose = "sql-tempdb"
        environment  = "prod"
      }
    }
  ]

  # Create service account for SQL Server
  create_service_account = true
  
  service_account_config = {
    account_id   = "sql-server-sa"
    display_name = "SQL Server Service Account"
    description  = "Service account for SQL Server VM with backup storage access"
    
    project_roles = [
      "roles/logging.logWriter",
      "roles/monitoring.metricWriter"
    ]
  }
  
  # =============================================================================
  # STORAGE FOR SQL SERVER BACKUPS
  # =============================================================================
  # NOTE: Module currently supports single bucket binding
  # For multiple buckets, use additional google_storage_bucket_iam_member resources
  # or create separate bindings in the calling terragrunt configuration
  storage_bucket_name = "sql-backup-bucket"
  storage_bucket_role = "roles/storage.objectAdmin"

  tags = ["windows", "database", "sql-server", "prod"]

  startup_script = <<-EOT
    Write-Host "=== SQL Server 2025 Configuration ==="
    Write-Host "Disk Layout: C: (OS) + D: (Data) + E: (Logs) + F: (TempDB)"
    
    $rawDisks = Get-Disk | Where-Object PartitionStyle -eq 'RAW'
    $driveLetters = @('D', 'E', 'F')
    $labels = @('SQLData', 'SQLLogs', 'SQLTemp')
    
    if ($rawDisks) {
      $index = 0
      foreach ($disk in $rawDisks) {
        $letter = $driveLetters[$index]
        $label = $labels[$index]
        
        Write-Host "Initializing disk $($disk.Number) as ${letter}:..."
        Initialize-Disk -Number $disk.Number -PartitionStyle GPT -PassThru | Out-Null
        New-Partition -DiskNumber $disk.Number -UseMaximumSize -DriveLetter $letter | Out-Null
        
        # 64KB allocation for SQL Server best practice
        Format-Volume -DriveLetter $letter -FileSystem NTFS `
          -NewFileSystemLabel $label -AllocationUnitSize 64KB `
          -Confirm:$false | Out-Null
        Write-Host "SUCCESS: ${letter}: drive ready ($label)"
        $index++
      }
    }
    
    # Create SQL Server directory structure
    New-Item -Path "D:\MSSQL\Data" -ItemType Directory -Force | Out-Null
    New-Item -Path "E:\MSSQL\Logs" -ItemType Directory -Force | Out-Null
    New-Item -Path "F:\MSSQL\TempDB" -ItemType Directory -Force | Out-Null
    New-Item -Path "D:\MSSQL\Backup" -ItemType Directory -Force | Out-Null
    
    Write-Host "`nSQL Server Directories Created:"
    Write-Host "  D:\MSSQL\Data   - Database files (.mdf)"
    Write-Host "  E:\MSSQL\Logs   - Log files (.ldf)"
    Write-Host "  F:\MSSQL\TempDB - TempDB files"
    Write-Host "  D:\MSSQL\Backup - Local backup staging"
    
    Write-Host "`nCloud Storage:"
    Write-Host "  Backups will be copied to Cloud Storage bucket via rclone"
    Write-Host "  Local backups staged at D:\MSSQL\Backup"
    Write-Host "=== Configuration Complete ==="
  EOT

  labels = {
    environment = "prod"
    role        = "database"
    db-engine   = "sql-server"
    managed-by  = "terragrunt"
  }

  shielded_instance_config = {
    enable_secure_boot          = false
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }

  deletion_protection = true  # Protect production database
}


# =============================================================================
# LINUX EXAMPLES WITH STORAGE ACCESS
# =============================================================================

# =============================================================================
# Example 8: RHEL 10 VM with Cloud Storage Access
# =============================================================================
# File: environments/prod/linux-storage/terragrunt.hcl
# Purpose: Linux VM with Cloud Storage access for data processing
# Use Case: Data analytics, batch processing, file processing pipelines

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
  config_path = "../../../../freight-network-host/environments/prod/vpc"
}

inputs = {
  project_id   = "uf-compute-p"
  machine_type = "n2-standard-4"
  
  os_type = "rhel10"

  instances = [
    {
      name = "vmlinux01"
      zone = "us-central1-a"
      network_interfaces = [
        {
          subnetwork = dependency.vpc.outputs.compute_subnet["us-central1"].self_link
        }
      ]
    }
  ]

  # Create service account for storage access
  create_service_account = true
  
  service_account_config = {
    account_id   = "linux-data-processing-sa"
    display_name = "Linux Data Processing Service Account"
    description  = "Service account for Linux VM data processing with Cloud Storage"
    
    project_roles = [
      "roles/logging.logWriter",
      "roles/monitoring.metricWriter"
    ]
  }
  
  # Storage bucket for data processing
  storage_bucket_name = "data-processing-bucket"
  storage_bucket_role = "roles/storage.objectAdmin"

  data_disks = [
    {
      size = 500
      type = "pd-ssd"
      labels = {
        disk-purpose = "processing"
        environment  = "prod"
      }
    }
  ]

  tags = ["linux", "data-processing", "storage-access", "prod"]

  startup_script = <<-EOT
    #!/bin/bash
    echo "=== RHEL 10 Data Processing VM ==="
    echo "Hostname: $(hostname)"
    
    # Format and mount data disk
    sleep 5
    DISK_DEVICE=$(lsblk -d -n -o NAME,TYPE | awk '$2=="disk" && $1!="sda" {print $1; exit}')
    
    if [ -n "$DISK_DEVICE" ]; then
      parted -s /dev/$DISK_DEVICE mklabel gpt
      parted -s /dev/$DISK_DEVICE mkpart primary ext4 0% 100%
      mkfs.ext4 -F /dev/${DISK_DEVICE}1
      
      mkdir -p /data
      mount /dev/${DISK_DEVICE}1 /data
      
      DISK_UUID=$(blkid -s UUID -o value /dev/${DISK_DEVICE}1)
      echo "UUID=$DISK_UUID /data ext4 defaults,nofail 0 2" >> /etc/fstab
      
      echo "SUCCESS: /data mounted"
    fi
    
    # Create directory structure
    mkdir -p /data/processing
    mkdir -p /data/output
    mkdir -p /mnt/cloud-storage  # For rclone mount
    
    echo "Directory structure created:"
    echo "  /data/processing      - Local processing workspace"
    echo "  /data/output          - Processing output"
    echo "  /mnt/cloud-storage    - Cloud Storage mount point (via rclone)"
    
    # Verify service account
    echo ""
    echo "Verifying service account..."
    SA_EMAIL=$(curl -s -H "Metadata-Flavor: Google" \
      http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/email)
    echo "Attached Service Account: $SA_EMAIL"
    
    echo ""
    echo "=== Next Steps ==="
    echo "1. Install rclone: dnf install -y rclone"
    echo "2. Configure rclone (uses VM's service account automatically)"
    echo "3. Mount bucket: rclone mount gcs:data-processing-bucket /mnt/cloud-storage --daemon"
    echo "=== Configuration Complete ==="
  EOT

  labels = {
    environment = "prod"
    workload    = "data-processing"
    managed-by  = "terragrunt"
  }

  shielded_instance_config = {
    enable_secure_boot          = false
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
}


# =============================================================================
# Summary: Deployment Patterns
# =============================================================================

# Single VM Patterns:
# -------------------
# Example 1: Basic Windows VM - General purpose server
# Example 2: Windows with Cloud Storage - rclone/WinFsp integration
# Example 3: Windows IIS - Web server with separate disks
# Example 6: Read-only Storage - Backup/archive access
# Example 7: SQL Server - Database with cloud backups
# Example 8: RHEL with Storage - Linux data processing

# Multi-VM Patterns:
# ------------------
# Example 4: Multi-region with shared storage - 4 VMs, 2 regions, 1 bucket
# Example 5: Existing service account - Use pre-created SA

# Service Account Patterns:
# ------------------------
# New SA:      create_service_account = true + service_account_config
# Existing SA: service_account = { email, scopes }
# Read-Only:   storage_bucket_role = "roles/storage.objectViewer"
# Read/Write:  storage_bucket_role = "roles/storage.objectAdmin" (default)


# =============================================================================
# Service Account & Storage Access Decision Tree
# =============================================================================

# Use create_service_account = true when:
#   ✅ Need dedicated SA per application/environment
#   ✅ Want module to manage SA lifecycle
#   ✅ Need bucket-specific permissions (storage_bucket_name provided)
#   ✅ Fresh deployment without existing SA
#   Examples: 2, 4, 6, 7, 8

# Use service_account = {...} when:
#   ✅ SA created by separate security/IAM team
#   ✅ SA shared across multiple deployments
#   ✅ Need to reference existing SA
#   ✅ Organization policy requires pre-approved SAs
#   Example: 5

# Storage Bucket Roles:
# --------------------
# roles/storage.objectViewer  - Read-only (get, list) - Example: 6
# roles/storage.objectUser    - Read + conditional write
# roles/storage.objectAdmin   - Full read/write/delete (DEFAULT) - Examples: 2, 4, 5, 7, 8
# roles/storage.admin         - Bucket + object admin (usually too broad)


# =============================================================================
# VM Access Scopes - Critical Information
# =============================================================================

# The module automatically sets proper scopes:
#
# When create_service_account = true:
#   ✅ Scope = "cloud-platform" (full access, IAM controls permissions)
#   ✅ This is the "bridge" that prevents access denied issues
#   ✅ IAM becomes the only limiter (as recommended by Google)
#
# When using existing SA (service_account = {...}):
#   ⚠️  You MUST specify: scopes = ["https://www.googleapis.com/auth/cloud-platform"]
#   ⚠️  Otherwise VM scope will block access despite IAM permissions
#
# Common Gotcha:
#   Service Account has storage.objectAdmin role ✅
#   BUT VM scope is "storage-ro" (read-only) ❌
#   Result: Access Denied (VM scope blocks before IAM check)
#   Solution: Use cloud-platform scope (module handles this automatically)


# =============================================================================
# rclone Configuration Examples
# =============================================================================

# Windows (PowerShell):
# --------------------
# 1. Install: choco install rclone winfsp -y
# 2. Configure: (automatic using VM's service account)
#    mkdir $env:APPDATA\rclone
#    @"
#    [gcs]
#    type = google cloud storage
#    project_number = PROJECT_ID
#    "@ | Out-File $env:APPDATA\rclone\rclone.conf -Encoding utf8
# 3. Mount: rclone mount gcs:BUCKET_NAME Z: --daemon
# 4. Access: dir Z:\

# Linux (Bash):
# ------------
# 1. Install: dnf install -y rclone  (or apt-get install rclone)
# 2. Configure: (automatic using VM's service account)
#    mkdir -p ~/.config/rclone
#    cat > ~/.config/rclone/rclone.conf <<EOF
#    [gcs]
#    type = google cloud storage
#    project_number = PROJECT_ID
#    EOF
# 3. Mount: rclone mount gcs:BUCKET_NAME /mnt/cloud-storage --daemon
# 4. Access: ls /mnt/cloud-storage


# =============================================================================
# Best Practices Summary
# =============================================================================

# 1. Service Accounts:
#    - Create dedicated SA per application/environment
#    - Use bucket-specific IAM (not project-wide roles)
#    - Let module handle VM scopes (cloud-platform)
#    - Use descriptive account_id and display_name

# 2. Storage Access:
#    - Use roles/storage.objectAdmin for rclone (provides all needed perms)
#    - Use roles/storage.objectViewer for read-only access
#    - Avoid roles/storage.admin (too broad)
#    - One bucket per storage_bucket_name (for multiple, use additional resources)

# 3. Multi-Region:
#    - Single SA can serve VMs in all regions
#    - Bucket access works from any region
#    - Consider bucket location for performance (multi-region vs regional)
#    - Use create_instance_groups for HA

# 4. Security:
#    - Enable shielded VM for production
#    - Use deletion_protection for critical VMs
#    - Private IPs only (enforced by module)
#    - Minimal project_roles (logging/monitoring only)

# 5. Monitoring:
#    - Use labels for cost tracking
#    - Include storage-access tag
#    - Monitor bucket access via Cloud Logging
#    - Track storage costs separately

# =============================================================================
# Cost Optimization for Storage Access
# =============================================================================

# 1. Bucket Location:
#    - Regional: Lower cost, single region
#    - Multi-region: Higher cost, better performance across regions
#    - Choose based on VM distribution

# 2. Storage Class:
#    - Standard: Frequently accessed data
#    - Nearline: Monthly access (30 days)
#    - Coldline: Quarterly access (90 days)
#    - Archive: Annual access (365 days)

# 3. Network Egress:
#    - Same region: Free egress
#    - Cross-region: Charged egress
#    - Use regional buckets when possible

# 4. API Requests:
#    - Minimize list operations
#    - Use lifecycle policies for auto-deletion
#    - Batch operations when possible

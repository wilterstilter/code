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

dependency "storage_bucket_fsms" {
  config_path = "../../../../uf-compute/environments/dev/storage-bucket-fsms"
}

dependency "vpc" {
  config_path = "../../../../freight-network-host/environments/dev/vpc"
}

locals {
  domain_join_user         = "sa-tasksched@transplace.com"
  domain_join_password     = "${get_env("TF_DOMAIN_JOIN")}"
  win_local_admin_password = "${get_env("TF_WIN_LOCAL_ADMIN")}"
}

inputs = {
  project_id   = "uf-compute-d"
  machine_type = "n4-standard-4"  # 4 vCPU, 16GB RAM - 5th Gen Intel Xeon Scalable (Emerald Rapids).

  os_type = "windows2025"

  boot_disk = {
    auto_delete = true
    initialize_params = {
      type = "hyperdisk-balanced"  # N4 requires hyperdisk, not pd-balanced
      size = 100                   # 100GB for Windows Server 2025
    }
  }

  # SERVICE ACCOUNT CONFIGURATION FOR STORAGE ACCESS
  # Create a dedicated user-managed service account for the VMs
  create_service_account = true
  
  service_account_config = {
    account_id   = "vm-storage-access-sa"  # Must be 6-30 chars, lowercase, digits, hyphens
    display_name = "VM Storage Access Service Account"
    description  = "Service account for VM instances to access Cloud Storage via rclone"
    
    # Project-level roles - these are for logging and monitoring
    # Storage bucket access is handled separately via storage_bucket_* variables
    project_roles = [
      "roles/logging.logWriter",      # Write logs to Cloud Logging
      "roles/monitoring.metricWriter" # Write metrics to Cloud Monitoring
    ]
  }
  
  # STORAGE BUCKET IAM CONFIGURATION
  # Grant the service account access to the specific storage bucket
  storage_bucket_name = dependency.storage_bucket_fsms.outputs.bucket_name

  # roles/storage.objectAdmin provides:
  # - storage.objects.get (read objects)
  # - storage.objects.list (list objects)
  # - storage.objects.create (write/upload objects)
  # - storage.objects.delete (delete objects)
  # - storage.buckets.get (required for rclone to get bucket metadata)
  storage_bucket_role = "roles/storage.objectAdmin"
  
  # VM INSTANCES - 4 VMs across 2 regions for high availability
  # Deploy 4 VMs: 2 in us-south1, 2 in us-east4
  instances = [
    # Region 1: us-south1
    {
      name = "gs1wptmbfdxd01"
      zone = "us-south1-a"
      network_interfaces = [
        {
          subnetwork = dependency.vpc.outputs.tmobile-ptms-compute-dev["us-south1"].self_link
          # network_ip omitted = DHCP assigned IP
        }
      ]
    },
    {
      name = "gs1wptmbfdxd02"
      zone = "us-south1-b"
      network_interfaces = [
        {
          subnetwork = dependency.vpc.outputs.tmobile-ptms-compute-dev["us-south1"].self_link
        }
      ]
    },
    # Region 2: us-east4
    {
      name = "ge4wptmbfdxd01"
      zone = "us-east4-a"
      network_interfaces = [
        {
          subnetwork = dependency.vpc.outputs.tmobile-ptms-compute-dev["us-east4"].self_link
        }
      ]
    },
    {
      name = "ge4wptmbfdxd02"
      zone = "us-east4-b"
      network_interfaces = [
        {
          subnetwork = dependency.vpc.outputs.tmobile-ptms-compute-dev["us-east4"].self_link
        }
      ]
    }
  ]

  # Code below assumes module-level, identical data disks (applies to ALL VMs unless overridden)
  # This creates identical sized disks for each VM
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

  # Default tags applied to all VMs
  tags = ["windows", "dev", "terraform-managed"]

  # Enable unmanaged instance groups for load balancer backends and high availability
  # Set to false if you don't need load balancing or just want simple redundancy
  create_instance_groups = true
  instance_group_name_prefix = "ig-ptms-dev"
  
  # Named ports for load balancer health checks, use any valid port(s) for these
  instance_group_named_ports = [
    {
      name = "tcp-network-fsms"
      port = 2000
    }
  ]

  # Secure Boot needs to be off, but this provides greater security than default
  shielded_instance_config = {
    enable_secure_boot          = false
    enable_vtpm                 = true
    enable_integrity_monitoring = true
  }
  # Sysprep script to enable local admin so that server can be logged into if domain join fails
  metadata = {
    sysprep-specialize-script-ps1 = <<-PS1
      # ===REGION DETECTION===
      $metadataUrl = "http://metadata.google.internal/computeMetadata/v1"
      $headers = @{"Metadata-Flavor" = "Google"}
      $zone = (Invoke-RestMethod -Uri "$metadataUrl/instance/zone" -Headers $headers) -replace '.*/zones/', ''
      $region = $zone -replace '-[a-z]$', ''
      
      Write-Host "=== Instance Information ==="
      Write-Host "Zone: $zone"
      Write-Host "Region: $region"
      Write-Host "Hostname: $env:COMPUTERNAME"
      
      # =============================================================================
      # DNS CONFIGURATION (CONDITIONAL BY REGION)
      # =============================================================================
      # Only set DNS for us-south1, skip for us-east4
      #if ($region -eq "us-south1") {
      #  Write-Host "=== Setting DNS for us-south1 region ==="
        # 1. SET ON-PREM DNS FIRST (Critical for Domain Join)
        # Replace these IPs with your actual on-prem Domain Controller IPs
      #  $DNSServers = ("10.1.70.20", "10.2.70.20") 
      #  $Interface = Get-NetAdapter | Where-Object { $_.Status -eq 'Up' }
      #  Set-DnsClientServerAddress -InterfaceIndex $Interface.ifIndex -ServerAddresses $DNSServers
      #  Write-Host "DNS servers set to $DNSServers"
      #} else {
      #  Write-Host "=== Skipping DNS configuration for region: $region ==="
      #  Write-Host "DNS servers will remain at default settings"
      #}
      # ===LOCAL ADMIN CONFIGURATION (ALL REGIONS)===
      # 2. Disable GCE Agent account interference
      # $regPath = "HKLM:\SOFTWARE\Google\ComputeEngine"
      # if (!(Test-Path $regPath)) { New-Item $regPath -Force }
      # Set-ItemProperty $regPath -Name "DisableUserManagement" -Value 1
      # 3. Allow local admin RDP tokens
      # Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LocalAccountTokenFilterPolicy" -Value 1 -Type DWord
      # 2. Create gcp admin break glass User
      $Username = "glocaladmin"
      $Pass = '${local.win_local_admin_password}'
      $SecPass = $Pass | ConvertTo-SecureString -AsPlainText -Force
      New-LocalUser -Name $Username -Password $SecPass
      Add-LocalGroupMember -Group "Administrators" -Member $Username
      Add-LocalGroupMember -Group "Remote Desktop Users" -Member $Username
      net user $Username /active:yes
      # Set local administrator password here
      # Set-LocalUser -Name "Administrator" -Password $SecPass
      # Using net user here to force the password change on the protected object
      # net user Administrator /active:yes
      Write-Host "Local accounts have been configured."
      # Write-Host "Local accounts 'admin' and 'Administrator' have been configured."
    PS1
  }

  # Bootstrap script to initialize data disks and join domain
  startup_script = <<-EOT
    # Start transcript to capture all output
    $tsTimestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    $transcriptPath = "C:\Logs\Bootstrap-Transcript-$tsTimestamp.txt"
    if (!(Test-Path "C:\Logs")) { New-Item -Path "C:\Logs" -ItemType Directory -Force | Out-Null }
    Start-Transcript -Path $transcriptPath -Append
    Write-Host "======================================================================="
    Write-Host "BOOTSTRAP START: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    Write-Host "Transcript: $transcriptPath"
    Write-Host "======================================================================="
    # ===REGION DETECTION===
    $metadataUrl = "http://metadata.google.internal/computeMetadata/v1"
    $headers = @{"Metadata-Flavor" = "Google"}
    try {
      $zone = (Invoke-RestMethod -Uri "$metadataUrl/instance/zone" -Headers $headers) -replace '.*/zones/', ''
      $region = $zone -replace '-[a-z]$', ''
      Write-Host "Detected Region: $region"
      Write-Host "Detected Zone: $zone"
    } catch {
      Write-Host "WARNING: Could not detect region from metadata, assuming us-south1"
      $region = "us-south1"
    }
    # =============================================================================
    # PART 1: Disk Initialization
    # =============================================================================
    Write-Host "=== Windows Server 2025 First Boot Configuration ==="
    Write-Host "VM: $env:computername"
    Write-Host "Disk Layout: C: (100GB OS) + D: (500GB Data)"
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
        
        Write-Host "SUCCESS: Data disk D: is ready (500GB)"
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
    Write-Host "=== Disk Configuration Complete ==="
    Write-Host ""
    # =============================================================================
    # PART 2: Domain Join
    # =============================================================================
    Write-Host "=== Starting Domain Join Checks or Attempts Portion ==="
    # --- Domain Configuration ---
    $DomainName = "transplace.com"
    # --- DNS and Port Connectivity Check ---
    Write-Host "Checking DNS resolution and DC connectivity..."
    try {
      Write-Host "Attempting DNS SRV lookup for $DomainName..."
      Resolve-DnsName -Name $DomainName -Type SRV -ErrorAction Stop | Out-Null
      $DC_Name = (Resolve-DnsName -Name $DomainName -Type SRV).PrimaryServer
      Write-Host "Resolved Domain Controller: $DC_Name"
      $Ports = @(53, 88, 135, 389, 445, 3268)
      $allPortsOpen = $true
      foreach ($Port in $Ports) {
        $Check = Test-NetConnection -ComputerName $DC_Name -Port $Port -InformationLevel Quiet
        if ($Check) {
          Write-Host "✅ Port $Port is OPEN on $DC_Name" -ForegroundColor Green
        } else {
          Write-Host "❌ Port $Port is CLOSED on $DC_Name" -ForegroundColor Red
          $allPortsOpen = $false
        }
      }
      if (-not $allPortsOpen) {
        Write-Host "ERROR: Not all required ports are open. Domain join will likely fail." -ForegroundColor Red
        throw "Port connectivity check failed"
      }
    }
    catch {
      Write-Host "ERROR: DNS resolution or connectivity check failed: $($_.Exception.Message)" -ForegroundColor Red
      Write-Host "Skipping domain join." -ForegroundColor Yellow
      Stop-Transcript
      exit 0
    }
    # --- Check if already domain joined ---
    Write-Host "Checking current domain state..."
    $alreadyDomainJoined = (Get-CimInstance Win32_ComputerSystem).PartOfDomain
    if ($alreadyDomainJoined) {
      Write-Host "Computer is already domain-joined. Running gpupdate /force..." -ForegroundColor Yellow
      $gp = Start-Process -FilePath "$env:SystemRoot\System32\gpupdate.exe" -ArgumentList '/force' -NoNewWindow -PassThru -Wait
      Write-Host "gpupdate completed with exit code: $($gp.ExitCode)"
    } else {
      # --- Prepare Credentials ---
      Write-Host "Host is not domain-joined. Preparing to join domain..."
      $fixedUser = '${local.domain_join_user}'
      $strRawPassword = '${local.domain_join_password}'
      $securePassword = $strRawPassword | ConvertTo-SecureString -AsPlainText -Force
      $cred = New-Object System.Management.Automation.PSCredential($fixedUser, $securePassword)
      # --- Join Domain ---
      Write-Host "Joining domain '$DomainName' in OU '$OUPath'..."
      try {
        Add-Computer -DomainName $DomainName -Credential $cred -ErrorAction Stop -Verbose
        Write-Host "SUCCESS: Domain join completed" -ForegroundColor Green
        # --- Enable PowerShell Remoting ---
        Write-Host "Enabling PowerShell Remoting (WinRM)..."
        Enable-PSRemoting -Force -SkipNetworkProfileCheck -ErrorAction SilentlyContinue
        # --- Schedule gpupdate to run after reboot ---
        Write-Host "Scheduling gpupdate /force to run after reboot..."
        $postGPScript = @"
Start-Transcript -Path 'C:\Logs\Bootstrap-PostReboot-GPUpdate-$tsTimestamp.txt' -Append
Write-Host "Running post-reboot gpupdate /force..."
`$gp = Start-Process -FilePath "`$env:SystemRoot\System32\gpupdate.exe" -ArgumentList '/force' -NoNewWindow -PassThru -Wait
Write-Host "gpupdate completed with exit code: `$(`$gp.ExitCode)"
Stop-Transcript
Unregister-ScheduledTask -TaskName 'Bootstrap-PostReboot-GPUpdate' -Confirm:`$false
"@
        $postScriptPath = "C:\ProgramData\Bootstrap-PostReboot-GPUpdate.ps1"
        Set-Content -Path $postScriptPath -Value $postGPScript -Encoding UTF8
        $action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$postScriptPath`""
        $trigger = New-ScheduledTaskTrigger -AtStartup
        $principal = New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest
        Register-ScheduledTask -TaskName 'Bootstrap-PostReboot-GPUpdate' -Action $action -Trigger $trigger -Principal $principal -Force | Out-Null
        Write-Host "Scheduled task registered to run gpupdate after reboot"
        # --- Reboot to complete domain join ---
        Write-Host "Rebooting to complete domain join..." -ForegroundColor Yellow
        Stop-Transcript
        Restart-Computer -Force
        return
      }
      catch {
        Write-Host "ERROR: Domain join failed: $($_.Exception.Message)" -ForegroundColor Red
        Write-Host "System will remain workgroup-joined." -ForegroundColor Yellow
      }
    }
    Stop-Transcript
    Write-Host ""
    Write-Host "=== Bootstrap Complete ==="
    Write-Host "Check transcript at: $transcriptPath"
  EOT

  labels = {
    environment = "dev"
    managed-by  = "digger"
  }
}
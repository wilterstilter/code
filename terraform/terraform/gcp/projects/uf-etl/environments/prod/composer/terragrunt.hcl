# Include GCP configuration
include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

# Terraform configuration source
terraform {
  source = "../../../modules/composer"
}

# Inputs for the Cloud Composer environment
inputs = {
  project_id = include.gcp.locals.project_id
  location   = "us-south1"

  composer_env_name          = "composer-prod"
  environment_size           = "ENVIRONMENT_SIZE_LARGE" # Environment size (options: ENVIRONMENT_SIZE_SMALL, MEDIUM, LARGE)
  grant_sa_agent_permission  = true                     # Grant service account permission to the agent"
  service_account            = "cloud-composer-sa-p@uf-etl-p.iam.gserviceaccount.com"
  network_project_id         = "freight-network-host-p"                                                                   # Network project id
  network                    = "projects/freight-network-host-p/global/networks/prod"                                     # Network for the Composer environment 
  subnetwork                 = "projects/freight-network-host-p/regions/us-south1/subnetworks/us-south1-composer-network" # Subnetwork for the Composer environment
  enable_private_environment = true                                                                                       # If true, a private Composer environment will be created.
  enable_private_builds_only = false                                                                                      # If true, builds performed during operations that install Python packages have only private connectivity to Google services. If false, the builds also have access to the internet.

  labels = {
    cost_center  = "cc14512",
    team_name    = "freight-data",
    environment  = "prod"
  }

  image_version = "composer-3-airflow-2.10.2-build.12"

  airflow_config_overrides = {
    "celery-worker_concurrency" = "12"
    "database-sql_alchemy_engine_args" = "{\"echo\": true}"
    "email-email_backend" = "airflow.utils.email.send_email_smtp"
    "smtp-smtp_host" = "10.67.200.184"
    "smtp-smtp_port" = "25"
  }

  pypi_packages = {
    "simple-salesforce" = "==1.12.9"
  }

  # Configuration is set with default values for a small environment size
  scheduler = {
    cpu        = 1  # CPU cores allocated to each Scheduler instance
    memory_gb  = 4  # Memory allocated to each Scheduler instance (in GB)
    storage_gb = 10 # Storage allocated to each Scheduler instance (in GB)
    count      = 2  # Number of Scheduler instances

  }
  web_server = {
    cpu        = 2   # CPU cores allocated to the Web Server instance
    memory_gb  = 7.5 # Memory allocated to the Web Server instance (in GB)
    storage_gb = 10  # Storage allocated to the Web Server instance (in GB)
  }

  worker = {
    cpu        = 4  # CPU cores allocated to each Worker instance
    memory_gb  = 15 # Memory allocated to each Worker instance (in GB)
    storage_gb = 50 # Storage allocated to each Worker instance (in GB)
    min_count  = 3  # Minimum number of Worker instances
    max_count  = 12 # Maximum number of Worker instances
  }

  triggerer = {
    cpu       = 0.5 # CPU cores allocated to the Triggerer instance
    memory_gb = 1   # Memory allocated to the Triggerer instance (in GB)
    count     = 1   # Number of Triggerer instances
  }

  dag_processor = {
    cpu        = 4  # CPU cores allocated to the dag_processor instance
    memory_gb  = 15 # Memory allocated to the dag_processor instance (in GB)
    storage_gb = 10 # Storage allocated to each dag_processor instance (in GB)
    count      = 2  # Number of dag_processor instance
  }

  maintenance_start_time = "2024-01-01T03:00:00Z"       # Start time of maintenance window (UTC)
  maintenance_end_time   = "2024-01-01T07:00:00Z"       # End time of maintenance window (UTC)
  maintenance_recurrence = "FREQ=WEEKLY;BYDAY=TU,TH,SU" # Recurrence pattern for maintenance window
  storage_bucket         = "uf-etl-prod-composer"       # Storage bucket for the Composer environment
}

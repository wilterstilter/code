resource "google_composer_environment" "composer_env" {

  project = var.project_id
  name    = var.composer_env_name
  region  = var.region
  labels  = var.labels


  dynamic "storage_config" {
    for_each = var.storage_bucket != null ? ["storage_config"] : []
    content {
      bucket = var.storage_bucket
    }
  }

  config {

    environment_size           = var.environment_size
    enable_private_environment = var.enable_private_environment
    enable_private_builds_only = var.enable_private_builds_only

    node_config {
      service_account                   = var.service_account
      network                           = var.network
      subnetwork                        = var.subnetwork
      composer_network_attachment       = var.composer_network_attachment
      composer_internal_ipv4_cidr_block = var.composer_internal_ipv4_cidr_block
    }

    dynamic "software_config" {
      for_each = [
        {
          airflow_config_overrides = var.airflow_config_overrides
          pypi_packages            = var.pypi_packages
          env_variables            = var.env_variables
          image_version            = var.image_version
          web_server_plugins_mode  = var.web_server_plugins_mode
      }]
      content {
        airflow_config_overrides = software_config.value["airflow_config_overrides"]
        pypi_packages            = software_config.value["pypi_packages"]
        env_variables            = software_config.value["env_variables"]
        image_version            = software_config.value["image_version"]
        web_server_plugins_mode  = software_config.value["web_server_plugins_mode"]
      }
    }

    dynamic "maintenance_window" {
      for_each = (var.maintenance_end_time != null && var.maintenance_recurrence != null) ? [
        {
          start_time = var.maintenance_start_time
          end_time   = var.maintenance_end_time
          recurrence = var.maintenance_recurrence
      }] : []
      content {
        start_time = maintenance_window.value["start_time"]
        end_time   = maintenance_window.value["end_time"]
        recurrence = maintenance_window.value["recurrence"]
      }
    }

    workloads_config {

      dynamic "scheduler" {
        for_each = var.scheduler != null ? [var.scheduler] : []
        content {
          cpu        = scheduler.value["cpu"]
          memory_gb  = scheduler.value["memory_gb"]
          storage_gb = scheduler.value["storage_gb"]
          count      = scheduler.value["count"]
        }
      }

      dynamic "web_server" {
        for_each = var.web_server != null ? [var.web_server] : []
        content {
          cpu        = web_server.value["cpu"]
          memory_gb  = web_server.value["memory_gb"]
          storage_gb = web_server.value["storage_gb"]
        }
      }

      dynamic "worker" {
        for_each = var.worker != null ? [var.worker] : []
        content {
          cpu        = worker.value["cpu"]
          memory_gb  = worker.value["memory_gb"]
          storage_gb = worker.value["storage_gb"]
          min_count  = worker.value["min_count"]
          max_count  = worker.value["max_count"]
        }
      }

      dynamic "triggerer" {
        for_each = var.triggerer != null ? [var.triggerer] : []
        content {
          cpu       = triggerer.value["cpu"]
          memory_gb = triggerer.value["memory_gb"]
          count     = triggerer.value["count"]
        }
      }

      dynamic "dag_processor" {
        for_each = var.dag_processor != null ? [var.dag_processor] : []
        content {
          cpu        = dag_processor.value["cpu"]
          memory_gb  = dag_processor.value["memory_gb"]
          storage_gb = dag_processor.value["storage_gb"]
          count      = dag_processor.value["count"]
        }
      }

    }
  }
}

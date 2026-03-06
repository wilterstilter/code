resource "google_gke_backup_backup_plan" "gke_backup_plan" {
  name    = "${var.name}-daily-backup-plan"
  cluster = google_container_cluster.gke.id

  location = var.region
  retention_policy {
    backup_delete_lock_days = 30
    backup_retain_days      = 60
  }
  backup_schedule {
    cron_schedule = "15 21 * * *"
  }
  backup_config {
    include_volume_data = true
    include_secrets     = true
    all_namespaces      = true
  }
  lifecycle {
    ignore_changes = all
  }
}
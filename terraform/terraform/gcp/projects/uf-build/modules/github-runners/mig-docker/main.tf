locals {
  dindVolumeMounts = var.dind ? [{
    mountPath = "/var/run/docker.sock"
    name      = "dockersock"
    readOnly  = false
  }] : []

  dindVolumes = var.dind ? [
    {
      name = "dockersock"
      hostPath = {
        path = "/var/run/docker.sock"
      }
  }] : []
}

resource "google_service_account" "runner" {
  project      = var.project_id
  account_id   = "ghr-${var.name}"
  display_name = "Github Runner GCE Service Account for pool ${var.name}"
}

resource "google_project_iam_member" "log_writter" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.runner.email}"
}

resource "google_project_iam_member" "metric_writter" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.runner.email}"
}

module "gce-container" {
  source           = "terraform-google-modules/container-vm/google"
  version          = "3.1.1"
  cos_image_name   = var.cos_source_image
  cos_image_family = "stable"
  cos_project      = "cos-cloud"
  container = {
    image = var.image
    command = [
      "/bin/bash",
      "-c",
      "sudo groupmod -g 412 docker && sudo usermod -a -G docker runner && sudo apt update && sudo apt install -y git-all jq curl openjdk-17-jdk && ls /home/runner/.runner &> /dev/null || /home/runner/config.sh  --token $(curl -L -X POST -H \"Accept: application/vnd.github+json\" -H \"Authorization: Bearer $GH_PAT\" -H \"X-GitHub-Api-Version: 2022-11-28\" https://api.github.com/orgs/uber-freight-internal/actions/runners/registration-token | jq -r .token) && sudo -u runner /home/runner/run.sh"
    ]
    env = [
      {
        name  = "ACTIONS_RUNNER_INPUT_URL"
        value = var.gh_url
      },
      {
        name  = "GH_PAT"
        value = var.gh_token
      },
      {
        name  = "ACTIONS_RUNNER_INPUT_RUNNERGROUP"
        value = var.gh_pool
      },
      {
        name  = "ACTIONS_RUNNER_INPUT_UNATTENDED"
        value = "true"
      },
      {
        name  = "ACTIONS_RUNNER_INPUT_EPHEMERAL"
        value = "true"
      },
      {
        name  = "ACTIONS_RUNNER_INPUT_REPLACE"
        value = "true"
      },
    ]

    # Declare volumes to be mounted
    # This is similar to how Docker volumes are mounted
    volumeMounts = concat([
      {
        mountPath = "/cache"
        name      = "tempfs-0"
        readOnly  = false
      }
    ], local.dindVolumeMounts)
  }

  # Declare the volumes
  volumes = concat([
    {
      name = "tempfs-0"
      emptyDir = {
        medium = "Memory"
      }
    }
  ], local.dindVolumes)

  restart_policy = var.restart_policy
}


module "mig_template" {
  source       = "terraform-google-modules/vm/google//modules/instance_template"
  version      = "11.1.0"
  project_id   = var.project_id
  region       = var.region
  network      = var.network
  subnetwork   = var.subnetwork
  machine_type = var.machine_type
  service_account = {
    email = google_service_account.runner.email
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
  disk_size_gb         = 100
  disk_type            = "pd-ssd"
  auto_delete          = true
  name_prefix          = "ghr-${var.name}"
  source_image_project = "cos-cloud"
  source_image         = var.cos_source_image
  metadata = merge(var.additional_metadata, {
    "gce-container-declaration" = module.gce-container.metadata_value
    "google-logging-enabled"    = "true"
  })
  tags = [
    "gh-runner-vm",
    "ghr-${var.name}"
  ]
  labels = {
    container-vm = module.gce-container.vm_container_label
  }
}

module "mig" {
  source            = "terraform-google-modules/vm/google//modules/mig"
  version           = "11.1.0"
  project_id        = var.project_id
  hostname          = "ghr-${var.name}"
  region            = var.region
  instance_template = module.mig_template.self_link
  min_replicas      = var.min_replicas
  max_replicas      = var.max_replicas

  /* autoscaler */
  autoscaling_enabled = true
  cooldown_period     = var.cooldown_period

  autoscaling_cpu = [
    {
      target            = 0.15
      predictive_method = "NONE"
    }
  ]
}

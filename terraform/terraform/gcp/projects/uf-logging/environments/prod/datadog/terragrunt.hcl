include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-logging/modules/datadog"
}

include "common" {
    path = find_in_parent_folders("common.hcl")
    expose = true
}

dependency "vpc" {
  config_path = "../../../../freight-network-host/environments/prod/vpc"
}

inputs = {
    project_id                    = include.gcp.locals.project_id
    network                       = dependency.vpc.outputs.network_id
    subnetwork                    = dependency.vpc.outputs.dataflow-subnet["us-south1"].self_link
    region                        = "us-south1"
    folder_id                     = "538907269383"
    network_project_id            = "freight-network-host-p"
    service_account               = "dataflow-worker"
    controller_service_account    = "service-190953545630@dataflow-service-producer-prod.iam.gserviceaccount.com"
    dataflow_job_name             = "logging"
    dataflow_temp_bucket_name     = "temp-files"
    topic_name                    = "export"
    subscription_name             = "export"
    deadlettertopic               = "output-deadletter"
    deadlettersub                 = "output-deadletter"
    datadog_api_key               = "${get_env("DATADOG_GCP_KEY")}"
    datadog_site_url              = "https://http-intake.logs.us5.datadoghq.com"
    
    # Dataflow template version - explicitly set to ensure we're using patched version
    # Update this periodically: https://cloud.google.com/dataflow/docs/release-notes/release-notes-templates
    dataflow_template_version     = "2026-01-27-00_RC00"
    
    sinks = [
      {
        name   = "folder-level-logs"
        filter = "severity >= DEBUG"
      }
    ]
}

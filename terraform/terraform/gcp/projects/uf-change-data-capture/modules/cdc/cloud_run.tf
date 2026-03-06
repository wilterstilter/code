### CONTAINER DEPLOYMENT
## Debezium Server
# TODO: spin up artifact registry to add mirror and use only internal
# this allows caching too avoiding dependency in dockerhub too
## SETUP NEXT
# resource "google_cloud_run_v2_service" "default" {
#   name = "debezium-server"

#   location     = var.region
#   launch_stage = "BETA"

#   template {
#     execution_environment = "EXECUTION_ENVIRONMENT_GEN2"

#     volumes {
#       name = "bucket"
#       gcs {
#         bucket    = google_storage_bucket.configs.name
#         read_only = false
#       }
#     }

#     containers {
#       image = "quay.io/debezium/server:latest"
#       volume_mounts {
#         name       = "bucket"
#         mount_path = "/conf"
#       }

#       env {
#         name = "GOOGLE_APPLICATION_CREDENTIALS"
#         value = "/conf/pubsub_sa.json"
#       }
#     }

#     labels = merge(var.debezium_resource_labels, var.base_labels)

#     scaling {
#       min_instance_count = 1
#       max_instance_count = 1
#     }

#     vpc_access {
#       network_interfaces {
#         network =
#         subnetwork =
#         tags = []
#       }
#     }
#   }
# }

### SETUP FOR CONTAINER
## Random bucket index for global uniqueness
resource "random_string" "bucket_index" {
  length  = 5
  special = false
  upper   = false
  numeric = true
  lower   = true
}

## Configuration Storage Bucket for Debezium
# bucket cannot end with numeric - so moved env to the end
resource "google_storage_bucket" "configs" {
  name                        = "uf-debezium-config-${random_string.bucket_index.result}-${substr(lower(var.env), 0, 1)}"
  location                    = var.bucket_location
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true
  labels                      = merge(var.debezium_resource_labels, { is_configmap = true, cdc_map = "all" }, var.base_labels)
}

# Save the private key to a GCS bucket
resource "google_storage_bucket_object" "pubsub_key_object" {
  name   = "pubsub_sa.json"
  bucket = google_storage_bucket.configs.name

  # module.service_accounts.key
  content = google_secret_manager_secret_version.pubsub_sa_version.secret_data

  # keys are in a json format
  content_type = "application/json"
  depends_on   = [google_storage_bucket.configs]
}

# Adding configuration file
## SETUP NEXT
# resource "google_storage_bucket_object" "conf_object" {
#   name    = "pubsub_sa.json"
#   bucket  = google_storage_bucket.configs.name
#   content = <<-EOF
#     debezium.sink.type=pubsub
#     debezium.sink.pubsub.project.id=${data.google_project.current.project_id}
#     debezium.source.connector.class=io.debezium.connector.oracle.OracleConnector
#     debezium.source.database.server.id=223344
#     debezium.source.database.hostname=${jsondecode(data.google_secret_manager_secret_version.database_configs.secret_data)["host"]}
#     debezium.source.database.port=${jsondecode(data.google_secret_manager_secret_version.database_configs.secret_data)["port"]}
#     # debezium.source.database.url=""jdbc:oracle:thin:@(DESCRIPTION=(ADDRESS_LIST=(LOAD_BALANCE=OFF)(FAILOVER=ON)(ADDRESS=(PROTOCOL=TCP)(HOST=<oracle ip 1>)(PORT=1521))(ADDRESS=(PROTOCOL=TCP)(HOST=<oracle ip 2>)(PORT=1521)))(CONNECT_DATA=SERVICE_NAME=)(SERVER=DEDICATED)))"
#     debezium.source.database.user=${jsondecode(data.google_secret_manager_secret_version.database_configs.secret_data)["username"]}
#     debezium.source.database.password=${jsondecode(data.google_secret_manager_secret_version.database_configs.secret_data)["password"]}
#     debezium.source.schema.history.internal=io.debezium.storage.file.history.FileSchemaHistory
#     debezium.source.schema.history.internal.file.filename=data/schema.dat
#     debezium.source.offset.storage.file.filename=data/offsets.dat
#     debezium.source.offset.flush.interval.ms=0
#     debezium.source.topic.prefix=cdc_log
#     debezium.source.database.include.list=inventory
#     debezium.source.table.include.list=inventory.products

#     # debezium.source.database.dbname="ORCLCDB"
#     # debezium.source.database.pdb.name"="ORCLPDB1"

#     # Unwrapping message
#     debezium.source.transforms=unwrap
#     debezium.source.transforms.unwrap.type=io.debezium.transforms.ExtractNewRecordState
#     debezium.source.transforms.unwrap.add.fields=op,table,source.ts_ms
#     debezium.source.transforms.unwrap.delete.handling.mode=rewrite

#     # Removing schema from message - can send schema to another topic maybe
#     debezium.source.key.converter.schemas.enable=false
#     debezium.source.value.converter.schemas.enable=false

#   EOF
#   content_type = "text/vnd.yaml"
#   depends_on = [google_storage_bucket.configs]
# }

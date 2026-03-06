output "bucket" {
  description = "Details of the created Object Storage bucket"
  value = {
    id           = oci_objectstorage_bucket.this.id
    name         = oci_objectstorage_bucket.this.name
    namespace    = oci_objectstorage_bucket.this.namespace
    storage_tier = oci_objectstorage_bucket.this.storage_tier
  }
}


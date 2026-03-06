resource "oci_objectstorage_bucket" "this" {
  namespace      = var.namespace
  compartment_id = var.compartment_id
  name           = var.bucket_name
  storage_tier   = var.storage_tier

  freeform_tags = var.tags
}


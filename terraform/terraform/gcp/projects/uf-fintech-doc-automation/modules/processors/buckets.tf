resource "google_storage_bucket" "carrier_invoice_docs" {
  name     = var.bucket_name_override != null ? var.bucket_name_override : "${var.project_id}_docs"
  location = "us"
  labels = {
    "team" : "fintech"
  }
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_binding" "binding" {
  bucket = google_storage_bucket.carrier_invoice_docs.name
  role   = "roles/storage.admin"
  members = [
    "group:fintech_doc_ai_gcp@uberfreight.com",
    "group:financerpagcp@uberfreight.com",
    "serviceAccount:fintech-doc-ai-sa@uf-fintech-doc-automation-d.iam.gserviceaccount.com",
  ]
}

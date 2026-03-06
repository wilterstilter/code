resource "google_document_ai_processor" "finops_processor" {
  for_each     = toset(["finops_ce_processor", "finops_pod_processor", "finops_lumper_processor", "finops_scale_ticket_processor", "finops_bol_processor", "finops_stamp_processor", "finops_mx_processor", "finops_international_processor"])
  location     = "us"
  display_name = each.key
  type         = "CUSTOM_EXTRACTION_PROCESSOR"
}

resource "google_document_ai_processor" "finops_classifier" {
  for_each     = toset(["finops_doc_classifier"])
  location     = "us"
  display_name = each.key
  type         = "CUSTOM_CLASSIFICATION_PROCESSOR"
}

resource "google_document_ai_processor" "finops_splitter" {
  for_each     = toset(["finops_doc_splitter"])
  location     = "us"
  display_name = each.key
  type         = "CUSTOM_SPLITTING_PROCESSOR"
}

import {
  id = "861593224322"
  to = google_access_context_manager_access_policy.default
}

resource "google_access_context_manager_access_policy" "default" {
  parent = "organizations/223503570424"
  title  = "Default policy"
}

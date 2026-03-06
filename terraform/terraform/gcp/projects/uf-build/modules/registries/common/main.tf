data "google_project" "current" {
  project_id = var.project_id
}

data "google_organization" "org" {
  domain = "uberfreight.com"
}

data "google_tags_tag_key" "locations_tag_key" {
  parent     = "organizations/${data.google_organization.org.org_id}"
  short_name = "resourceLocations"
}

data "google_tags_tag_value" "locations_us_tag_value" {
  parent     = data.google_tags_tag_key.locations_tag_key.id
  short_name = "us-locations"
}

resource "google_tags_tag_binding" "binding" {
  parent    = "//cloudresourcemanager.googleapis.com/projects/${data.google_project.current.number}"
  tag_value = "tagValues/${data.google_tags_tag_value.locations_us_tag_value.name}"
}

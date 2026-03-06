data "google_organization" "org" {
  domain = "uberfreight.com"
}

data "google_project" "current" {
  project_id = var.project_id
}

# cost center
data "google_tags_tag_key" "cost_center_tag" {
  parent     = "organizations/${data.google_organization.org.org_id}"
  short_name = "cost-center"
}

data "google_tags_tag_value" "cost_center_value" {
  parent     = data.google_tags_tag_key.cost_center_tag.id
  short_name = "cc14512"
}

resource "google_tags_tag_binding" "cost_center_binding" {
  parent    = "//cloudresourcemanager.googleapis.com/projects/${data.google_project.current.number}"
  tag_value = "tagValues/${data.google_tags_tag_value.cost_center_value.name}"
}

# environment
data "google_tags_tag_key" "environment_values_tag" {
  parent     = "organizations/${data.google_organization.org.org_id}"
  short_name = "environment"
}

data "google_tags_tag_value" "environment_values_value" {
  parent     = data.google_tags_tag_key.environment_values_tag.id
  short_name = "dev"
}

resource "google_tags_tag_binding" "environment_binding" {
  parent    = "//cloudresourcemanager.googleapis.com/projects/${data.google_project.current.number}"
  tag_value = "tagValues/${data.google_tags_tag_value.environment_values_value.name}"
}

# team
data "google_tags_tag_key" "team_name_tag" {
  parent     = "organizations/${data.google_organization.org.org_id}"
  short_name = "team"
}

data "google_tags_tag_value" "team_value" {
  parent     = data.google_tags_tag_key.team_name_tag.id
  short_name = "freight-data"
}

resource "google_tags_tag_binding" "team_binding" {
  parent    = "//cloudresourcemanager.googleapis.com/projects/${data.google_project.current.number}"
  tag_value = "tagValues/${data.google_tags_tag_value.team_value.name}"
}
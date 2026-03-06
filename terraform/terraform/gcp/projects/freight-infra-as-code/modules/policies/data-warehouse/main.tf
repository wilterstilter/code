resource "google_access_context_manager_access_policy" "default" {
  parent = "organizations/223503570424"
  title  = var.access_policy_name
  scopes = [
    "projects/${var.project_id}"
  ]
}

module "access_level" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/access_level"
  version = "~> 6.0"

  for_each = {
    for item in var.access_level :
    item.access_level_name => item
  }
  policy      = google_access_context_manager_access_policy.default.name
  name        = each.value.access_level_name
  description = each.value.access_level_description

  combining_function     = each.value.combining_function
  ip_subnetworks         = each.value.ip_subnetworks
  required_access_levels = each.value.required_access_levels
  members                = each.value.members
  regions                = each.value.regions
  vpc_network_sources    = lookup(each.value, "vpc_network_sources", null)
}

module "service_perimeter" {
  source  = "terraform-google-modules/vpc-service-controls/google//modules/regular_service_perimeter"
  version = "~> 6.0"

  policy         = google_access_context_manager_access_policy.default.name
  perimeter_name = var.perimeter.perimeter_name
  description    = var.perimeter.perimeter_description

  # Enforced mode
  resources               = var.perimeter.resources
  restricted_services     = var.perimeter.restricted_services
  access_levels           = var.perimeter.access_levels
  vpc_accessible_services = var.perimeter.vpc_accessible_services
  ingress_policies        = var.perimeter.ingress_policies
  egress_policies         = var.perimeter.egress_policies

  # Dry run mode
  resources_dry_run               = var.perimeter.resources_dry_run
  restricted_services_dry_run     = var.perimeter.restricted_services_dry_run
  access_levels_dry_run           = var.perimeter.access_levels_dry_run
  vpc_accessible_services_dry_run = var.perimeter.vpc_accessible_services_dry_run
  ingress_policies_dry_run        = var.perimeter.ingress_policies_dry_run
  egress_policies_dry_run         = var.perimeter.egress_policies_dry_run

  depends_on = [module.access_level]
}

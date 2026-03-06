# Data center IP subnets
locals {
  dal_subnet = "65.64.216.0/24"
  aus_subnet = "208.191.62.0/24"
}

# Create the bucket
resource "google_storage_bucket" "bucket" {
  name     = "uf-net-edl"
  location = "US"

  uniform_bucket_level_access = true

  labels = {
    "team" : "network"
  }

  versioning {
    enabled = true
  }
}

# Retrieve tag key and value and assign the tag to the bucket so
# we can enable public access.
data "google_organization" "org" {
  domain = "uberfreight.com"
}

data "google_tags_tag_key" "public_access_bucket_tag_key" {
  parent     = "organizations/${data.google_organization.org.org_id}"
  short_name = "publicAccessBucket"
}

data "google_tags_tag_value" "public_access_bucket_tag_value" {
  parent     = data.google_tags_tag_key.public_access_bucket_tag_key.id
  short_name = "allowed"
}

resource "google_tags_location_tag_binding" "binding" {
  parent    = "//storage.googleapis.com/projects/_/buckets/${google_storage_bucket.bucket.name}"
  tag_value = "tagValues/${data.google_tags_tag_value.public_access_bucket_tag_value.name}"
  location  = "us"
}

# Enable bucket public access.
#tfsec:ignore:google-storage-no-public-access
data "google_iam_policy" "policy" {
  binding {
    # The legacy roles does not allow file list
    role = "roles/storage.legacyObjectReader"
    members = [
      "allUsers",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "policy" {
  bucket      = google_storage_bucket.bucket.name
  policy_data = data.google_iam_policy.policy.policy_data
}

# Cloud Armor security policy to restrict IP
module "security_policy" {
  source  = "GoogleCloudPlatform/cloud-armor/google"
  version = "~> 2.0"

  project_id                           = data.google_project.current.project_id
  name                                 = google_storage_bucket.bucket.name
  default_rule_action                  = "deny(403)"
  type                                 = "CLOUD_ARMOR_EDGE"
  layer_7_ddos_defense_enable          = true
  layer_7_ddos_defense_rule_visibility = "STANDARD"

  security_rules = {

    "deny_project_bad_actor1" = {
      action      = "allow"
      priority    = 10
      description = "Only allow Uber Freight data center IPs"

      # IMPORTANT This might make you believe the files are not public. That's not the case.
      # The bucket has public access but the Load Balancer does not so if somebody knows
      # https://storage.googleapis.com/uf-net-edl/edi-ip-allow-list.txt they would be able to
      # access from anywhere but https://pa-edl.ufinternal.com/edi-ip-allow-list.txt is IP
      # restricted.
      src_ip_ranges = [local.dal_subnet, local.aus_subnet]
    }
  }
}

# Reserve IP address for load balancer.
resource "google_compute_global_address" "default" {
  name = google_storage_bucket.bucket.name
}

# Create LB backend for bucket
resource "google_compute_backend_bucket" "bucket" {
  name                 = google_storage_bucket.bucket.name
  bucket_name          = google_storage_bucket.bucket.name
  edge_security_policy = module.security_policy.policy.self_link
}

# Create url map
resource "google_compute_url_map" "default" {
  name            = google_storage_bucket.bucket.name
  default_service = google_compute_backend_bucket.bucket.id
}

# Self-signed regional SSL certificate
resource "google_compute_managed_ssl_certificate" "default" {
  name = google_storage_bucket.bucket.name
  managed {
    domains = ["pa-edl.ufinternal.com"]
  }
}

# Create a SSL policy to prevent use of outdated versions of TLS
resource "google_compute_ssl_policy" "default" {
  name            = "production-ssl-policy"
  profile         = "MODERN"
  min_tls_version = "TLS_1_2"
}

# Create HTTPS target proxy
resource "google_compute_target_https_proxy" "default" {
  name             = google_storage_bucket.bucket.name
  url_map          = google_compute_url_map.default.id
  ssl_certificates = [google_compute_managed_ssl_certificate.default.id]
  ssl_policy       = google_compute_ssl_policy.default.id
}

# Create forwarding rule
resource "google_compute_global_forwarding_rule" "default" {
  name                  = google_storage_bucket.bucket.name
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range            = "443"
  target                = google_compute_target_https_proxy.default.id
  ip_address            = google_compute_global_address.default.id

  labels = {
    "team" : "network"
  }
}


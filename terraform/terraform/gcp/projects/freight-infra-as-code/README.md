Bucket public access

The bucket needs to be tagged before public access can be enabled. 

```
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
resource "google_storage_bucket_iam_policy" "policy" {
  bucket      = google_storage_bucket.bucket.name
  policy_data = data.google_iam_policy.policy.policy_data
}
```

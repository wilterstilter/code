output "policy_ids" {
  description = "Map of policy names to OCIDs"
  value       = { for k, v in oci_identity_policy.this : k => v.id }
}


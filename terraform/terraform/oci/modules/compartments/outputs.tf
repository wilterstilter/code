output "environment_compartments" {
  description = "Map of environment keys to created compartment OCIDs."
  value       = { for key, compartment in oci_identity_compartment.environment : key => compartment.id }
}

output "child_compartments" {
  description = "Map of child keys (env/child) to created compartment OCIDs."
  value       = { for key, compartment in oci_identity_compartment.child : key => compartment.id }
}


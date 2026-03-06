
output "security_policy_self_link" {
  description = "The self link of the security policy (global or regional) associated with the GLB or ILB backend"
  value = var.region == null ? (
    length(google_compute_security_policy.global_policy) > 0 ?
    google_compute_security_policy.global_policy[0].id :
    null # Or a default value if no global policy exists
    ) : (
    length(google_compute_region_security_policy.regional_policy) > 0 ?
    google_compute_region_security_policy.regional_policy[0].id :
    null # Or a default value if no regional policy exists
  )
}

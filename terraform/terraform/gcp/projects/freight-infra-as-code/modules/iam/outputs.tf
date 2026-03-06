output "role_global_reader_id" {
  value = "organizations/${var.organization_id}/roles/${module.role_global_reader.custom_role_id}"
}

output "role_network_reader_id" {
  value = "organizations/${var.organization_id}/roles/${module.role_network_reader.custom_role_id}"
}

output "role_global_secret_viewer_id" {
  value = "organizations/${var.organization_id}/roles/${module.role_global_secret_viewer.custom_role_id}"
}

output "role_tf_state_unlock_id" {
  value = google_project_iam_custom_role.state_force_unlock.id
}

output "role_interconnect_admin_id" {
  value = "organizations/${var.organization_id}/roles/${module.role_interconnect_admin.custom_role_id}"
}

output "role_billing_admin_id" {
  value = "organizations/${var.organization_id}/roles/${module.role_billing_admin.custom_role_id}"
}

output "role_devops_os_login_id" {
  value = "organizations/${var.organization_id}/roles/${module.role_devops_os_login.custom_role_id}"
}

output "role_gemini_user_id" {
  value = "organizations/${var.organization_id}/roles/${module.role_gemini_user.custom_role_id}"
}

output "role_bq_usage_viewer" {
  value = "organizations/${var.organization_id}/roles/${module.role_bq_usage_viewer.custom_role_id}"
}

resource "google_privileged_access_manager_entitlement" "pam_entitlement" {
  provider             = google-beta
  entitlement_id       = var.entitlement_id
  location             = "global"
  max_request_duration = var.max_request_duration
  parent               = "${var.parent_type}s/${var.parent_id}"

  requester_justification_config {
    unstructured {}
  }

  eligible_users {
    principals = var.eligible_requesters
  }

  privileged_access {
    gcp_iam_access {
      dynamic "role_bindings" {
        for_each = var.role_bindings
        content {
          role = role_bindings.value
        }
      }
      resource      = "//cloudresourcemanager.googleapis.com/${var.parent_type}s/${var.parent_id}"
      resource_type = "cloudresourcemanager.googleapis.com/${title(var.parent_type)}"
    }
  }

  # Conditionally include approval workflow based on auto_approval
  dynamic "approval_workflow" {
    for_each = var.auto_approval ? [] : [1] # Include approval workflow only if auto_approval is false
    content {
      manual_approvals {
        require_approver_justification = false
        steps {
          approvals_needed          = 1
          approver_email_recipients = [for approver in var.approvers : split(":", approver)[1]]
          approvers {
            principals = var.approvers
          }
        }
      }
    }
  }
}

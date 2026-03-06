resource "google_secret_manager_secret" "secrets" {
  for_each  = var.secrets
  project   = var.project_id
  secret_id = each.key

  labels = merge(var.base_labels, each.value.labels)

  replication {
    auto {}
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_secret_manager_secret_version" "secret_versions" {
  for_each = {
    for k, v in var.secrets : k => v
    if v.secret_data != null
  }

  secret      = google_secret_manager_secret.secrets[each.key].id
  secret_data = each.value.secret_data

  lifecycle {
    ignore_changes = [secret_data]
  }
}

resource "google_secret_manager_secret_iam_member" "secret_accessor_sa" {
  for_each = {
    for pair in flatten([
      for secret_id, secret_conf in var.secrets : [
        for accessor in secret_conf.accessor_service_accounts : {
          secret_id = secret_id
          member    = "serviceAccount:${accessor}"
          key       = "${secret_id}-${accessor}"
        }
      ]
    ]) : pair.key => pair
  }

  project   = var.project_id
  secret_id = google_secret_manager_secret.secrets[each.value.secret_id].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = each.value.member
}

resource "google_secret_manager_secret_iam_member" "secret_accessor_group" {
  for_each = {
    for pair in flatten([
      for secret_id, secret_conf in var.secrets : [
        for group in secret_conf.accessor_groups : {
          secret_id = secret_id
          member    = "group:${group}"
          key       = "${secret_id}-${group}"
        }
      ]
    ]) : pair.key => pair
  }

  project   = var.project_id
  secret_id = google_secret_manager_secret.secrets[each.value.secret_id].secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = each.value.member
}

resource "google_secret_manager_secret_iam_member" "secret_admin" {
  for_each = {
    for pair in flatten([
      for secret_id, secret_conf in var.secrets : [
        for admin in secret_conf.admin_groups : {
          secret_id = secret_id
          member    = "group:${admin}"
          key       = "${secret_id}-${admin}"
        }
      ] if length(secret_conf.admin_groups) > 0
    ]) : pair.key => pair
  }

  project   = var.project_id
  secret_id = google_secret_manager_secret.secrets[each.value.secret_id].secret_id
  role      = "roles/secretmanager.secretAdmin"
  member    = each.value.member
}

resource "google_secret_manager_secret_iam_member" "secret_editor" {
  for_each = {
    for pair in flatten([
      for secret_id, secret_conf in var.secrets : [
        for editor in lookup(secret_conf, "editor_groups", []) : {
          secret_id = secret_id
          member    = "group:${editor}"
          key       = "${secret_id}-editor-${editor}"
        }
      ]
    ]) : pair.key => pair
  }

  project   = var.project_id
  secret_id = google_secret_manager_secret.secrets[each.value.secret_id].secret_id
  role      = "roles/secretmanager.secretEditor"
  member    = each.value.member
}

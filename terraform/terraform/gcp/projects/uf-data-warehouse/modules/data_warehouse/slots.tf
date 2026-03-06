resource "google_bigquery_reservation" "create_reservations" {
  for_each = {
    for reservation in var.reservations : reservation.name => reservation
  }

  project           = var.project_id
  name              = each.value.name
  location          = var.region
  slot_capacity     = each.value.slot_capacity
  edition           = each.value.edition
  ignore_idle_slots = false
  concurrency       = 0

  autoscale {
    max_slots = each.value.max_slots
  }
}

locals {
  assignment_intermediate = flatten([
    for res in var.reservations : [
      for assignment in res.assignments : {
        reservation_name = res.name
        assignee         = assignment.assignee
        job_type         = assignment.job_type
        reservation      = google_bigquery_reservation.create_reservations[res.name].id
      }
    ]
  ])
}

resource "google_bigquery_reservation_assignment" "primary" {
  for_each = {
    for p in local.assignment_intermediate : "${p.reservation_name}-${p.assignee}-${p.job_type}" => p
  }
  project     = var.project_id
  assignee    = each.value.assignee
  job_type    = each.value.job_type
  reservation = each.value.reservation
}

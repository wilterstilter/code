resource "google_compute_subnetwork_iam_member" "member" {
  for_each = merge(flatten([
    for project in local.projects_final : [
      for subnet in project.shared_vpc_subnets : {
        for user in project.shared_vpc_users :
        "${user}-${subnet}" => {
          user : "${user}@${module.projects[project.id].project_id}.iam.gserviceaccount.com"
          subnet : subnet
        }
      }
    ]
  ])...)

  region     = element(split("/", each.value.subnet), 3)
  subnetwork = each.value.subnet

  role   = "roles/compute.networkUser"
  member = "serviceAccount:${each.value.user}"
}

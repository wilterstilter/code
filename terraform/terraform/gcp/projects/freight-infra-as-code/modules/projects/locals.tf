locals {
  teams = try(
    yamldecode(file(abspath(joinpath(path.module, "..", "..", "..", "..", "..", "..", "..", "teams.yaml")))).teams,
    yamldecode(file("/home/runner/work/code/code/teams.yaml")).teams,
    yamldecode(file("/home/runner/_work/code/code/teams.yaml")).teams
  )

  projects_intermediate = flatten([
    for project in var.gcp_projects : [
      for env in project.environments : merge(project, {
        id                   = env.overrides.project_id != null ? env.overrides.project_id : "${project.id}-${substr(lower(env.name), 0, 1)}",
        name                 = env.overrides.project_name != null ? env.overrides.project_name : env.overrides.project_id != null ? env.overrides.project_id : "${project.id}-${substr(lower(env.name), 0, 1)}",
        env                  = env.name,
        monthly_budget       = env.monthly_budget
        shared_vpc_subnets   = env.shared_vpc_subnets
        shared_vpc_users     = env.shared_vpc_users
        shared_vpc_no_subnet = env.shared_vpc_no_subnet
      })
    ]
  ])

  # Final is a clean map/object where we avoid copying over fields without explicitly calling them out.
  projects_final = [
    for project in local.projects_intermediate : {

      id              = project.id
      name            = project.name
      folder_key      = project.env
      layer           = project.layer
      org_id          = var.organization_id
      billing_account = var.billing_account
      monthly_budget  = project.monthly_budget
      activate_apis   = project.activate_apis

      grant_network_role   = length(project.shared_vpc_subnets) != 0
      svpc_host_project_id = length(project.shared_vpc_subnets) == 0 && !project.shared_vpc_no_subnet ? "" : project.env == "prod" ? "freight-network-host-p" : project.env == "nonprod" ? "freight-network-host-n" : "freight-network-host-d"
      shared_vpc_subnets   = project.shared_vpc_subnets
      shared_vpc_users     = project.shared_vpc_users

      // Bucket Creation for reference: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google/latest
      bucket_name = "uf-iac-${project.id}"

      // Labels passed down to all resources in the project
      // [Labels are never overriden with import project name - so that when projects are migrated over the analystics on the projects are kept]
      labels = merge(
        project.additional_labels,
        {
          "env" : project.env,
          "team" : lower(project.team),
          "layer" : project.layer,
          "project_id" : project.id,
        }
      )

      // Bucket labels passed down to all resources in the project
      bucket_labels = {
        "env" : project.env,
        "team" : lower(project.team),
        "layer" : project.layer,
        "project_id" : project.id,
      }

      entitlements = [
        for entitlement in var.entitlements : {
          project_id     = project.id
          entitlement_id = entitlement.entitlement_id
          role_bindings  = entitlement.role_bindings
          team           = project.team
        }
      ]
    }
  ]
}

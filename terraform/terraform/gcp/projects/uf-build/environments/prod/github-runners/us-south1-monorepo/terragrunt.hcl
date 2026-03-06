# Adds all terraform + provider blocks
include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-build/modules/github-runners/mig-docker"
}

include "runners" {
    path = find_in_parent_folders("runners.hcl")
    expose = true
}

dependency "vpc" {
  config_path = "../../../../../freight-network-host/environments/prod/vpc"
}

inputs = {
    project_id          = include.gcp.locals.project_id
    name                = include.runners.locals.name
    region              = "us-south1"
    min_replicas        = 2
    dind                = true
    machine_type        = "n2-standard-4"
    cos_source_image    = "cos-117-18613-263-19"
    gh_token            = "${get_env("GH_RUNNER_REGISTRATION_PAT")}"
    gh_url              = "https://github.com/uber-freight-internal"
    gh_pool             = "Monorepo"
    image               = "ghcr.io/actions/actions-runner:2.325.0"
    network             = dependency.vpc.outputs.network_id
    subnetwork          = "projects/freight-network-host-p/regions/us-south1/subnetworks/us-south1-github-runners"
}

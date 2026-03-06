include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/uf-cloud-workstations/modules/workstations"
}

inputs = {
    project_id    = include.gcp.locals.project_id
    name          = "devpod"
    region        = "us-east4"
    replica_zones = ["us-east4-a", "us-east4-b"]
    network_id    = "projects/freight-network-host-p/global/networks/prod",
    subnet_id     = "projects/freight-network-host-p/regions/us-east4/subnetworks/us-east4-cloud-workstations-s1",
    psc_ip        = "10.245.0.5"
    labels        = {
        "env": "production",
        "team": "network",
        "layer": "platform",
        "managed_by": "infra-as-code",
    }
}

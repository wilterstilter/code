include "gcp" {
    path = find_in_parent_folders()
    expose = true
}

dependency "iam" {
    config_path = "../../iam"
}

terraform {
    source = "${dirname(find_in_parent_folders())}//projects/freight-infra-as-code/modules/pam"
}

include "entitlements" {
    path = find_in_parent_folders("entitlements.hcl")
    expose = true
}

inputs = {
    organization_id      = include.gcp.locals.organization_id
    entitlement_id       = include.entitlements.locals.entitlement
    parent_type          = "organization"
    parent_id            = include.gcp.locals.organization_id
    max_request_duration = "28800s"  # 8 hours
    role_bindings        = [
        dependency.iam.outputs.role_network_reader_id
    ]
    eligible_requesters  = [
        "group:val-marchevsky-all-staff@uberfreight.com"
    ]
    approvers            = [] # No approvers needed for auto-approval
    auto_approval        = true
}

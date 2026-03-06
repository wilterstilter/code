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
    max_request_duration = "7200s"  # 120 mnts
    role_bindings        = [
        "roles/billing.admin",
        "roles/compute.admin",
        "roles/compute.xpnAdmin",
        "roles/iam.serviceAccountAdmin",
        "roles/iam.organizationRoleAdmin",
        "roles/resourcemanager.organizationAdmin",
        "roles/storage.admin",
        "roles/pubsub.admin",
        "roles/logging.admin",
        "roles/monitoring.admin",
        "roles/cloudfunctions.admin",
        "roles/bigquery.admin",
        "roles/compute.networkAdmin",
        "roles/iam.securityAdmin",
        "roles/serviceusage.serviceUsageAdmin",
        "roles/cloudsql.admin",
        "roles/container.admin",
        "roles/dataproc.admin",
        "roles/dataflow.admin",
        "roles/cloudfunctions.developer",
        "roles/run.admin", 
        "roles/orgpolicy.policyAdmin",
        "roles/privilegedaccessmanager.admin"
    ]
    eligible_requesters  = [
        "group:sg-az-gcp-organization-admins@uberfreight.com"
    ]
    approvers            = [
        "user:bijoy.babu@uberfreight.com",
        "user:sreekanth.gottigadla@uberfreight.com",
        "user:gregory.plevak@uberfreight.com",
        "user:robert.butler@uberfreight.com",
        "user:thiyagarajana@uberfreight.com",
        "user:abhinav.jajala@uberfreight.com",
    ]
}

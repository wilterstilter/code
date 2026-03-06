locals {
    region          = "us-south1"
    bucket_location = "US"

    base_labels = {
        "team"       = "data-platform",
        "layer"      = "platform",
        "managed_by" = "infra-as-code",
    }

    bq_labels = {
        "cost_center"           = "cc14512",
        "service_name"          = "bigquery",
        "cost_of_business"      = "opex",
        "can_shutdown_offhours" = "false",
        "point_of_contact"      = "data-platform",
        "disaster_recovery"     = "critical",
    }
}
locals {
    # region = "us-west-8"
    bucket_location = "US"

    base_labels = {
        # "env"      = "nonprod", added at project level
        "team"       = "data-platform",
        "layer"      = "platform",
        "managed_by" = "infra-as-code",
    }

    debezium_resource_labels = {
        "cost_center"           = "cc14512",
        "service_name"          = "debezium-server",
        "cdc_map"               = "oracle-to-pubsub"
        "cost_of_business"      = "opex",
        "can_shutdown_offhours" = "false",
        "point_of_contact"      = "data-platform",
        "disaster_recovery"     = "critical",
    }
}

include "cisco" {
    path = find_in_parent_folders()
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//modules/nxos/base"
}

inputs = {
    interface_description = "jake"
}

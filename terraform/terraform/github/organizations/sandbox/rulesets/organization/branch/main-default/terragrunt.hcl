include "github" {
    path = find_in_parent_folders()
    expose = true
}

include "rulesets" {
    path = find_in_parent_folders("rulesets.hcl")
    expose = true
}

terraform {
    source = "${dirname(find_in_parent_folders())}//modules/rulesets/organization/branch/main"
}

inputs = {
    name = include.rulesets.locals.rule_name
    include_repositories = [
        "*"
    ]
    # If you exclude it here make sure you add it under a different rule.
    exclude_repositories = [
        "ThreeBranchDemo"
    ]
}

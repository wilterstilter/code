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
    # Squash commit policy creates a new commit which causes reverse merge failures.
    required_linear_history = false
    # Read more at https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/creating-rulesets-for-a-repository#using-fnmatch-syntax
    include_repositories = [
        "tms"
    ]
}

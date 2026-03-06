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
    # Read more at https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/creating-rulesets-for-a-repository#using-fnmatch-syntax
    include_repositories = [
        "*"
    ]
    # If you exclude it here make sure you add it under a different rule.
    exclude_repositories = [
        "tms",
		"ai-thon-2025"
    ]
}

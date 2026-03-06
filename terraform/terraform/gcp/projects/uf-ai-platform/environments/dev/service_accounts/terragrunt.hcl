include "gcp" {
  path   = find_in_parent_folders()
  expose = true
}

include "common" {
  path   = find_in_parent_folders("common.hcl")
  expose = true
}

terraform {
  source = "${dirname(find_in_parent_folders())}//projects/uf-ai-platform/modules/service_account"
}

inputs = {
  service_accounts = {
    llm-caller = {
      account_id   = "llm-caller"
      display_name = "LLM Caller service account"
      generate_key = true
    }
  }
  base_labels = merge(include.common.locals.base_labels, { "env" : include.gcp.locals.env })
  project_id = include.gcp.locals.project_id
}

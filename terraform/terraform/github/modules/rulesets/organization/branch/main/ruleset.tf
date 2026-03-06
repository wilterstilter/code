resource "github_organization_ruleset" "default" {
  name        = var.name
  enforcement = "active"

  target = "branch"

  bypass_actors {
    actor_id    = 0
    actor_type  = "OrganizationAdmin"
    bypass_mode = "pull_request"
  }

  conditions {
    ref_name {
      include = [
        "~DEFAULT_BRANCH",
        "refs/heads/main",
        "refs/heads/master",
        "refs/heads/preprod",
        "refs/heads/prod",
      ]
      exclude = []
    }
    repository_name {
      include = var.include_repositories
      exclude = var.exclude_repositories
    }
  }

  rules {
    creation                = false
    update                  = false
    deletion                = true
    required_linear_history = var.required_linear_history
    required_signatures     = false
    non_fast_forward        = true

    #    commit_author_email_pattern {
    #      operator = "regex"
    #      pattern  = ".*@(ext\\.)?uberfreight.com"
    #      name     = "Uber Freight email required"
    #    }

    pull_request {
      require_code_owner_review         = true
      require_last_push_approval        = true
      required_review_thread_resolution = true
      required_approving_review_count   = 1
      # Enabling code reviews from Copilot is not available yet
      # https://github.com/integrations/terraform-provider-github/issues/2583
      #automatic_copilot_code_review_enabled = true
    }
  }
}

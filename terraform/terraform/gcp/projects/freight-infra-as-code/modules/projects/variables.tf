variable "iac_project_id" {
  type        = string
  description = "Infra as Code project ID"
}

variable "organization_id" {
  type        = string
  description = "GCP Organization ID for Uber Freight"
}

variable "environment_folders" {
  type        = map(string)
  description = "A map with the environment as key and folder id as value"
}

variable "billing_account" {
  description = "ID of the billing account to associate projects with"
  type        = string
  default     = "01056D-45723E-4DA5CF"

  validation {
    condition     = var.billing_account == "01056D-45723E-4DA5CF" # we only have one billing account
    error_message = "You cannot specify any other GCP billing account for Uber Freight"
  }
}

variable "gcp_projects" {
  type = list(object({
    id    = string
    layer = string
    team  = string
    environments = list(object({
      name                 = string
      monthly_budget       = optional(number, 0)
      shared_vpc_subnets   = optional(list(string), [])
      shared_vpc_users     = optional(list(string), [])
      shared_vpc_no_subnet = optional(bool, false)
      overrides = optional(object({
        project_id   = optional(string)
        project_name = optional(string)
      }), {})
    }))
    additional_labels = optional(map(string), {})
    activate_apis     = optional(list(string), [])
  }))

  default = []

  description = "This is where all project for the org will be created"
  nullable    = false

  validation {
    condition = alltrue([
      for p in var.gcp_projects :
      contains(
        keys(
          yamldecode(
            file("../../../../../../../../../../../../../../../teams.yaml")
        )["teams"]),
        p.team
      )
    ])
    error_message = "Team is a mandatory field and needs to be a team from the list in teams.yaml"
  }

  validation {
    condition     = alltrue([for p in var.gcp_projects : length(regexall("^[a-z][a-z0-9-]+$", p.id)) > 0])
    error_message = "Project IDs must be slugified (lowercase letters and dashes only)"
  }

  validation {
    condition = alltrue([for p in var.gcp_projects : length(regexall("^.*(prod|dev|test|uat|staging).*$", p.id)) == 0 || contains(
      [
        "tms-mobile-app-dev",
      ],
      p.id
    )])
    error_message = "Environment name should not be part of the ID."
  }

  validation {
    condition = alltrue([for p in var.gcp_projects : length(regexall("^(uf-|freight-).*$", p.id)) > 0 || contains(
      [
        "harding-sandbox",
        "api-7454232358621519384",
        "ardent-girder-245515",
        "gam-project-oam-v9x-wlk",
        "tms-mobile-306015",
        "tms-mobile-app-a1f87",
        "tp-sidekick-gtsoki",
        "smart-bloom-294513",
        "tms-mobile-app-dev",
      ],
      p.id
    )])
    error_message = "Project ID needs to be unique across GCP. To increase the chances of project creation success we prefix all ptojects with 'uf-' or 'freight-'."
  }

  validation {
    condition     = length(var.gcp_projects) == length(distinct([for p in var.gcp_projects : p.id]))
    error_message = "All project IDs must be unique."
  }

  validation {
    condition     = alltrue([for p in var.gcp_projects : length(p.id) <= 25])
    error_message = "All project IDs must be under 25 characters (GCP project/bucket requirement)"
  }

  # Layers can only be ["core", "platform", "product"] (can only be in one layer at time)
  validation {
    condition     = alltrue([for p in var.gcp_projects : contains(["core", "platform", "product"], p.layer)])
    error_message = "Layer can only be core, platform, product."
  }

  # Environment should be which environments to create the project for
  validation {
    condition     = alltrue([for p in var.gcp_projects : length(p.environments) >= 1 && length(p.environments) <= 3])
    error_message = "Environment cannot be empty and can contain at most all three environments"
  }

  # Environment should be only dev, nonprod and/or prod
  validation {
    condition     = alltrue(flatten([for p in var.gcp_projects : [for e in p.environments : contains(["dev", "nonprod", "prod"], e.name)]]))
    error_message = "Environments can only be [dev and/or nonprod and/or prod]"
  }

  # Budget must be specified (>= 0 and <= 100k) for any core layer projects
  validation {
    condition     = alltrue(flatten([for p in var.gcp_projects : [for e in p.environments : e.monthly_budget >= 0 && e.monthly_budget <= 100000 if p.layer == "platform"]]))
    error_message = "Budget amount must be a non-negative number (but better to have a value to get auto-alerts)"
  }

  # Budget must be specified (>= 0 and <= 10k) for any product layer
  validation {
    condition     = alltrue(flatten([for p in var.gcp_projects : [for e in p.environments : e.monthly_budget >= 0 && e.monthly_budget <= 100000 if p.layer == "product"]]))
    error_message = "Budget amount must be a non-negative number and smaller than 100k for product layer."
  }

  # We only allow project ID overrides for imports. DO NOT edit this.
  validation {
    condition = alltrue(
      flatten(
        [
          for p in var.gcp_projects : [
            for e in p.environments : e.overrides.project_id == null ? true : contains(
              [
                "freight-interconnects",
                "freight-byoip",
                "harding-sandbox",
                "api-7454232358621519384",
                "ardent-girder-245515",
                "freight-workspace-logs",
                "gam-project-oam-v9x-wlk",
                "tms-mobile-306015",
                "tms-mobile-app-a1f87",
                "tp-sidekick-gtsoki",
                "smart-bloom-294513",
                "tms-mobile-app-dev",
                "freight-infra-as-code",
                "uf-data-analysis"
              ],
              p.id
            )
          ]
        ]
      )
    )
    error_message = "We only allow project ID overrides for imported projects. The project id is standardized for new projects."
  }

  validation {
    condition = alltrue(
      flatten(
        [
          for p in var.gcp_projects : [
            for e in p.environments : e.overrides.project_id == null ? true : length(e.overrides.project_id) <= 30
          ]
        ]
      )
    )
    error_message = "Override Project IDs cannot be longer than 30 characters."
  }

  validation {
    condition = alltrue(
      flatten(
        [
          for p in var.gcp_projects : [
            for e in p.environments : e.overrides.project_id == null ? true : length(regexall("^[a-z][a-z0-9-]+$", e.overrides.project_id)) > 0
          ]
        ]
      )
    )
    error_message = "Override Project IDs must be slugified (lowercase letters and dashes only)."
  }

  # We only allow project name overrides for imports. DO NOT edit this.
  validation {
    condition = alltrue(
      flatten(
        [
          for p in var.gcp_projects : [
            for e in p.environments : e.overrides.project_name == null ? true : contains(
              [
                "api-7454232358621519384",
                "ardent-girder-245515",
                "gam-project-oam-v9x-wlk",
                "tms-mobile-306015",
                "tms-mobile-app-a1f87",
                "tp-sidekick-gtsoki",
                "smart-bloom-294513",
                "tms-mobile-app-dev",
              ],
              p.id
            )
          ]
        ]
      )
    )
    error_message = "We only allow project name overrides for imported projects. The project name is standardized for new projects."
  }

  validation {
    condition = alltrue(
      flatten(
        [
          for p in var.gcp_projects : [
            for e in p.environments : e.overrides.project_name == null ? true : length(e.overrides.project_name) <= 30
          ]
        ]
      )
    )
    error_message = "Override Project Name cannot be longer than 30 characters"
  }

  validation {
    condition = alltrue(
      flatten(
        [
          for p in var.gcp_projects : [
            for e in p.environments : e.overrides.project_name == null ? true : length(regexall("^[a-zA-Z' !0-9-]+$", e.overrides.project_name)) > 0
          ]
        ]
      )
    )
    error_message = "Override Project Name can contain only letters, numbers, single quotes, hyphens, spaces, or exclamation points,."
  }
}

variable "entitlements" {
  type = list(object({
    entitlement_id = string
    role_bindings  = list(string)
  }))
  description = "List of entitlements with their IDs and role bindings"
}


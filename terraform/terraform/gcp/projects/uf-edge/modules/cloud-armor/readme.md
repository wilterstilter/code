# Google Cloud Armor Security Policy Module

This Terraform module creates a Google Cloud Armor security policy with a flexible set of rules. It can be used to create either a global or a regional security policy, depending on whether a region is specified.

## Architecture

This module creates the following resources:

- **Cloud Armor Security Policy**: The core resource is a Cloud Armor security policy, which can be either global or regional.
    - If a `region` is not provided, a global security policy is created. This is typically used with global external HTTPS load balancers.
    - If a `region` is provided, a regional security policy is created. This is used with regional load balancers.
- **Security Policy Rules**: The module creates a set of rules within the security policy based on the `rules` variable. Each rule can have a priority, an action (e.g., `allow`, `deny`), a match expression, and other options like rate limiting.

## Usage

### Global Security Policy with a Simple Rule

This example creates a global security policy that denies traffic from a specific IP range.

```hcl
module "cloud_armor_global" {
  source = "./path-to-this-module"

  name = "my-global-policy"
  rules = [
    {
      priority    = 1000
      action      = "deny(403)"
      expression  = "origin.ip == '192.0.2.0/24'"
      description = "Block traffic from a specific IP range."
      preview     = false
    }
  ]
}
```

### Regional Security Policy with Rate Limiting

This example creates a regional security policy in `us-central1` that rate-limits requests based on the client's IP address.

```hcl
module "cloud_armor_regional" {
  source = "./path-to-this-module"

  name   = "my-regional-policy"
  region = "us-central1"
  rules = [
    {
      priority = 1000
      action   = "throttle"
      expression = "true"
      rate_limit_options = {
        rate_limit_threshold = {
          count        = 100
          interval_sec = 60
        }
        conform_action = "allow"
        exceed_action  = "deny(429)"
        enforce_on_key = "IP"
      }
      description = "Rate-limit requests to 100 per minute per IP."
      preview     = false
    }
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| `name` | The name of the security policy. | `string` | n/a | yes |
| `region` | The region for the Cloud Armor policy. If null, a global policy will be created. | `string` | `null` | no |
| `rules` | A list of security policy rules. See the examples for more details. | `list(object({...}))` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| `global_policy_self_link` | The self-link of the global security policy. |
| `regional_policy_self_link` | The self-link of the regional security policy. |
| `global_rules` | A list of the global security policy rules. |
| `regional_rules` | A list of the regional security policy rules. | 

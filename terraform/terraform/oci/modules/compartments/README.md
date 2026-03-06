# OCI Compartments Module

Creates an opinionated hierarchy of OCI compartments underneath a specified parent.

## Inputs

- `parent_compartment_id`: OCID of the tenancy root or parent compartment.
- `default_freeform_tags`: Baseline tags applied to every compartment (optional).
- `environments`: Map describing environment compartments (dev, nonprod, prod, etc.) with optional child compartments.

Each environment entry supports:

```hcl
environments = {
  dev = {
    display_name             = "uf-dev"
    description              = "Development environment"
    enable_delete_protection = false
    freeform_tags            = { Environment = "dev" }
    defined_tags             = {}
    children = {
      network = {
        display_name = "uf-dev-network"
      }
    }
  }
}
```

## Outputs

- `environment_compartments`: Map of environment keys to created compartment OCIDs.
- `child_compartments`: Map of `env/child` keys to created child compartment OCIDs.


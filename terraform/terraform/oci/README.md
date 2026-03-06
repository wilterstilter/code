# OCI Terraform Infrastructure - POC

This directory contains Terraform configurations for Oracle Cloud Infrastructure (OCI).

## Current Setup: IAM-Only POC

For initial POC testing, we're only deploying IAM policies to validate:
- ✅ GitHub Actions → OCI authentication
- ✅ Terraform/Terragrunt execution
- ✅ OCI provider configuration
- ✅ GCS backend for state management

## Structure

```
oci/
├── poc/                        # POC compartment (Terafarm_POC)
│   ├── common.hcl             # Shared configuration (compartment OCID, region, namespace)
│   ├── iam/                   # IAM policies for testing
│   │   └── terragrunt.hcl
│   └── object_storage/        # Object Storage bucket for testing
│       └── terragrunt.hcl
├── modules/
│   ├── iam/                   # IAM module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── object_storage/        # Object Storage module
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tf
└── terragrunt.hcl             # Root configuration (GCS backend, provider)
```

## Prerequisites

### 1. GitHub Secrets (Required)

The following secrets must be configured in your GitHub repository:

- `OCI_CLI_USER` - User OCID
- `OCI_CLI_FINGERPRINT` - API key fingerprint
- `OCI_CLI_TENANCY` - Tenancy OCID
- `OCI_CLI_REGION` - Region (e.g., us-ashburn-1)
- `OCI_CLI_KEY_CONTENT` - Private API key (entire PEM file contents)

See the main README for instructions on generating these values.

### 2. Compartment OCID

Get your compartment OCID:
1. OCI Console → **Identity & Security** → **Compartments**
2. Click on **Terafarm_POC**
3. Copy the **OCID** (starts with `ocid1.compartment.oc1..`)
4. Update `poc/common.hcl` with this value

## Getting Started

### Step 1: Update compartment OCID

Edit `src/terraform/oci/poc/common.hcl`:

```hcl
compartment_id = "ocid1.compartment.oc1..aaaaaaaaXXXXXXXX"  # Your actual OCID
```

### Step 2: Test via GitHub Actions

1. **Push your changes** to branch `oci-poc-github-actions-auth`
2. **Create a Pull Request** to `main`
3. **Comment on the PR**: `digger plan`
4. **Check the workflow** runs successfully and shows IAM policy plan
5. **Apply if successful**: `digger apply`

### Step 3: Verify in OCI Console

After apply:
1. OCI Console → **Identity & Security** → **Policies**
2. Navigate to **Terafarm_POC** compartment
3. Verify `poc-github-actions-test-policy` exists

## Local Testing (Optional)

If you have OCI CLI configured locally:

```bash
cd src/terraform/oci/poc/iam
terragrunt init
terragrunt plan
```

## What's Next?

After validating IAM/Object Storage works:
- Add VCN module for networking
- Add compute module for instances

## Troubleshooting

### Error: "Service error:NotAuthenticated"
- Check GitHub secrets are set correctly
- Verify API key fingerprint matches the key content
- Ensure user OCID is correct

### Error: "Authorization failed"
- Verify the `gh-actions-ci` group exists in your OCI domain
- Check the user is a member of the group
- Verify the group has the policy attached

### Error: "compartment not found"
- Double-check the compartment OCID in `common.hcl`
- Ensure you have access to the Terafarm_POC compartment

## Resources

- [OCI Terraform Provider Docs](https://registry.terraform.io/providers/oracle/oci/latest/docs)
- [OCI IAM Policies](https://docs.oracle.com/en-us/iaas/Content/Identity/Concepts/policies.htm)
- [Terragrunt Documentation](https://terragrunt.gruntwork.io/docs/)


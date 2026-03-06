# Cert Manager Module

This module is designed to manage **self-managed SSL/TLS certificates** in Google Cloud Platform (GCP) using the **Google Certificate Manager**. It allows you to securely provision and manage certificates for your applications.

---

## Overview

The Cert Manager module provisions **self-managed certificates** in GCP. These certificates are stored securely in **GitHub Secrets** and loaded into the Terraform workflow via the `digger.yaml` configuration. The module supports the following features:

1. **Self-Managed Certificates**:
   - Certificates are provided as PEM-encoded files (certificate and private key).
   - These certificates are securely stored in GitHub Secrets.

2. **Integration with GitHub Actions**:
   - Certificates are loaded into the GitHub Runner during the Terraform workflow using `digger.yaml`.

3. **Google Certificate Manager**:
   - Certificates are deployed to GCP using the `google_certificate_manager_certificate` resource.

---

## Features

1. **Self-Managed Certificates**:
   - Supports PEM-encoded certificates and private keys.
   - Ideal for scenarios where certificates are managed outside of GCP (e.g., issued by a third-party CA).

2. **Secure Storage**:
   - Certificates and private keys are stored securely in GitHub Secrets to ensure confidentiality.

3. **Dynamic Deployment**:
   - Certificates are dynamically deployed to GCP using Terraform.

---

## Inputs

This module requires the following input variables:

### **1. `name`**
   - The name of the certificate in GCP.
   - Example: `"my-self-managed-cert"`

### **2. `description`**
   - A description of the certificate.
   - Example: `"Self-managed certificate for example.com"`

### **3. `location`**
   - The location where the certificate will be deployed.
   - Example: `"global"`

### **4. `cert_pem`**
   - The PEM-encoded certificate content.
   - This is loaded from a GitHub Secret during the Terraform workflow.
   - Example: `"-----BEGIN CERTIFICATE-----\n...certificate content...\n-----END CERTIFICATE-----"`

### **5. `key_pem`**
   - The PEM-encoded private key content.
   - This is loaded from a GitHub Secret during the Terraform workflow.
   - Example: `"-----BEGIN PRIVATE KEY-----\n...private key content...\n-----END PRIVATE KEY-----"`

---

## Outputs

This module provides the following outputs:

1. **`certificate_id`**:
   - The ID of the created certificate in GCP.

2. **`certificate_self_link`**:
   - The self-link of the created certificate in GCP.

---

## Example Configuration

Here’s an example of how to use this module to create a self-managed certificate:

### **Input Variables**

```hcl
module "cert_manager" {
  source = "./modules/cert-manager"

  name        = "my-self-managed-cert"
  description = "Self-managed certificate for example.com"
  location    = "global"

  # These variables are loaded from GitHub Secrets via [digger.yaml](http://_vscodecontentref_/2)
  cert_pem = var.cert_pem
  key_pem  = var.key_pem
}

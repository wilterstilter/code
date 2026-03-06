terraform {
  required_version = ">=1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.43, < 6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.1, < 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.32, < 3.0"
    }
  }
}

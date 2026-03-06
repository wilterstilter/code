terraform {
  required_version = ">=1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.40.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 6.30.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.1.0"
    }
  }
}

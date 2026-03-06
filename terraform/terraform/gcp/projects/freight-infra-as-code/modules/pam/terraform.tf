terraform {
  required_version = ">=1.5"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.23.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.11.1"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 5.45.1"
    }
  }
}

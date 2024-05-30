terraform {
  required_version = "1.5.5"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.42.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.9.1"
    }
  }
}
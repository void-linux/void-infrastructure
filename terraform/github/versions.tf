terraform {
  required_version = ">= 0.12"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "4.4.0"
    }
  }
}

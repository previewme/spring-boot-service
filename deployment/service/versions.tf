terraform {
  required_version = ">= 1.0.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "= 2.1.0"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "= 3.63.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "= 3.1.0"
    }
  }
}
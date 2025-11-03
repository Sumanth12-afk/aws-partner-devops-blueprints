terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# AWS provider configuration. Region is parameterized for portability across accounts.
provider "aws" {
  region = var.region
}



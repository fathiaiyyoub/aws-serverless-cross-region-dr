terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Primary Region (Sydney)
provider "aws" {
  alias  = "primary"
  region = var.primary_region
}

# Secondary Region (Singapore)
provider "aws" {
  alias  = "secondary"
  region = var.secondary_region
}
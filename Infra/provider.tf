terraform {
  required_version = ">= 1.15.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Store the main infrastructure state in the bootstrap S3 bucket
  backend "s3" {
    bucket = "gatus-bootstrap-terraform-state"
    key    = "infra/terraform.tfstate"
    region = "eu-central-1"

    encrypt      = true
    use_lockfile = true
  }
}

# Main provider for the infrastructure
provider "aws" {
  region = var.aws_region
}

# Used by the Route 53 registered-domain resource
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
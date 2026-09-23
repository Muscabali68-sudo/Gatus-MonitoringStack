terraform {
  required_version = ">= 1.15.6"


  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Store the bootstrap Terraform state remotely in S3
terraform {
  backend "s3" {
    bucket = "gatus-bootstrap-terraform-state"

    # Keep the bootstrap state separate from the infrastructure state
    key = "bootstrap/terraform.tfstate"

    # Use the same region where the S3 bucket was created
    region = "eu-central-1"

    # Encrypt the state file inside S3
    encrypt = true

    # Prevent two Terraform operations from changing state simultaneously
    use_lockfile = true
  }
}


provider "aws" {
  region = "eu-central-1"
}
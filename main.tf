# Define your AWS provider configuration
terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.20.0"
    }
  }

  backend "s3" {
    key     = "state"
    encrypt = true
    region  = "eu-central-1"
  }
}

provider "aws" {
  region = var.aws_region
}

# Configure AWS Provider
# This file configures the AWS provider for Terraform.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider and select the appropirate region.
provider "aws" {
  region = "us-east-1" # Change this to your desired region
}


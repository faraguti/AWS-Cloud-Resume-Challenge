# Terraform Configuration for AWS Resources

# Define the required providers and their versions
terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # Any 6.x release, but not a breaking 7.0
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.8"
    }
  }
}

# Configure the AWS provider with the desired region
provider "aws" {
  region = "us-west-2" # Set the desired AWS region
}

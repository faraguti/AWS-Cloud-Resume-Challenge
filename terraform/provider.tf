# Terraform Configuration for AWS Resources

# Define the required provider and its version
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 5" # Use a version greater than 5
    }
  }
}

# Configure the AWS provider with the desired region
provider "aws" {
  region = "us-west-2" # Set the desired AWS region
}
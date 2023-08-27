# Configure Terraform backend to store state in an S3 bucket
terraform {
  backend "s3" {
    bucket = "terraform-state-cloud-resume-faraguti"
    key = "global/s3/terraform.tfstate"
    dynamodb_table = "terraform-state"
    region = "us-west-2"
    encrypt = true
    
    # Use the "terraform" AWS profile for credentials
    # profile = "terraform"
  }
}
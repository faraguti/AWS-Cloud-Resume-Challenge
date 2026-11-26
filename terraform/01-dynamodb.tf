# Terraform Configuration for DynamoDB

# Define a DynamoDB table for storing the visit counter
resource "aws_dynamodb_table" "dynamodb_table_cloud_resume" {
  name         = "cloud-resume-challenge"
  billing_mode = "PAY_PER_REQUEST"

  # Composite primary key. Only key attributes are declared here;
  # "visits" is a regular attribute and does not need a definition.
  hash_key  = "pk"
  range_key = "sk"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  # The table holds the live visit count: fail the plan rather than
  # replace or delete it by accident.
  lifecycle {
    prevent_destroy = true
  }

  # Define tags for the DynamoDB table
  tags = {
    Name        = "Cloud-Resume-Challenge"
    Environment = "Project"
  }
}

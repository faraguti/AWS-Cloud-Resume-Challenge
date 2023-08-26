# Terraform Configuration for AWS DynamoDB Table and Item

# Define a DynamoDB table for storing data
resource "aws_dynamodb_table" "dynamodb_table_cloud_resume" {
  name         = "cloud-resume-challenge2"  # Unique name for the table
  billing_mode = "PAY_PER_REQUEST"  # Pay-per-request billing mode

  # Define the hash key attribute
  hash_key = "Id"

  attribute {
    name = "Id"
    type = "S"  # String type for the hash key
  }

  # Define tags for the DynamoDB table
  tags = {
    Name        = "Cloud-Resume-Challenge"  # Name tag
    Environment = "Project"  # Environment tag
  }
}

# Define an item to be stored in the DynamoDB table
resource "aws_dynamodb_table_item" "dynamodb-item-visits" {
  count = var.first_deploy ? 1 : 0  # Conditionally create or skip the resource
  table_name = aws_dynamodb_table.dynamodb_table_cloud_resume.name
  hash_key   = aws_dynamodb_table.dynamodb_table_cloud_resume.hash_key

  # Define the item data using JSON syntax
  item = <<ITEM
{
  "Id": {"S": "1"},
  "visits": {"N": "1"}
}
ITEM
}

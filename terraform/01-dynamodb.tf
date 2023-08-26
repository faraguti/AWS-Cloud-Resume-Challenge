# Define a DynamoDB table for storing data
resource "aws_dynamodb_table" "dynamodb_table_cloud_resume" {
  name         = "cloud-resume-challenge"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  attribute {
    name = "visits"
    type = "N"
  }
  
  hash_key  = "pk"
  range_key = "sk"
  
  global_secondary_index {
  name            = "visit_count_index"
  hash_key        = "visits"
  range_key       = "sk"
  projection_type = "ALL"
  }

  tags = {
    Name        = "Cloud-Resume-Challenge"
    Environment = "Project"
  }
}


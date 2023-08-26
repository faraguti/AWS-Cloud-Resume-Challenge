# Terraform Configuration for AWS Lambda Function and IAM Role

# Define an IAM role for the Lambda function
resource "aws_iam_role" "lambda_exec" {
  name = "lambda-exec-role"

  # Define the trust relationship policy for the role
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Attach policies to the Lambda execution role
resource "aws_iam_role_policy_attachment" "lambda_policy_basic_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_dynamodb_full_access" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

# Create a Lambda deployment package from source code
data "archive_file" "lambda" {
  type        = "zip"
  source_dir = "../${path.module}/lambda-function"  # Specify the source code dir
  output_path = "../${path.module}/lambda-function/visit_counter.zip"
}

# Define the Lambda function
resource "aws_lambda_function" "cloud_resume_function" {
  filename      = "../${path.module}/lambda-function/visit_counter.zip"  # Lambda deployment package
  function_name = "cloud-resume-function2"
  role          = aws_iam_role.lambda_exec.arn  # IAM role for execution
  handler       = "visit_counter.lambda_handler"  # Lambda handler function

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.11"
}

# Define a CloudWatch Log Group for Lambda function logs
resource "aws_cloudwatch_log_group" "log_group_lambda" {
  name = "/aws/lambda/${aws_lambda_function.cloud_resume_function.function_name}"

  retention_in_days = 14
}

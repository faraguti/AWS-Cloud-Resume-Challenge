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

# Allow the function to write its logs to CloudWatch
resource "aws_iam_role_policy_attachment" "lambda_policy_basic_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Least privilege: the function only updates the counter item in its own table
resource "aws_iam_role_policy" "lambda_dynamodb_counter" {
  name = "visit-counter-dynamodb"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["dynamodb:UpdateItem"],
        Resource = aws_dynamodb_table.dynamodb_table_cloud_resume.arn
      }
    ]
  })
}

# Package only the handler, not tests, caches or old build output
data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/../lambda-function/visit_counter.py"
  output_path = "${path.module}/build/visit_counter.zip"
}

# Define the Lambda function
resource "aws_lambda_function" "cloud_resume_function" {
  filename      = data.archive_file.lambda.output_path # Lambda deployment package
  function_name = "cloud-resume-function"
  role          = aws_iam_role.lambda_exec.arn   # IAM role for execution
  handler       = "visit_counter.lambda_handler" # Lambda handler function

  source_code_hash = data.archive_file.lambda.output_base64sha256

  # python3.12+ needs a newer AWS provider than the locked 5.14.0; bump the
  # runtime after the provider lock is upgraded.
  runtime = "python3.11"

  # Lambda's CPU scales with memory; 128 MB (the default) is too slow for
  # boto3. 10 s leaves headroom over the 3 s default so a slow cold start
  # degrades instead of failing.
  memory_size = 256
  timeout     = 10

  environment {
    variables = {
      TABLE_NAME = aws_dynamodb_table.dynamodb_table_cloud_resume.name
    }
  }
}

# Define a CloudWatch Log Group for Lambda function logs
resource "aws_cloudwatch_log_group" "log_group_lambda" {
  name = "/aws/lambda/${aws_lambda_function.cloud_resume_function.function_name}"

  retention_in_days = 14
}

# Flag any function error or timeout (visible in the CloudWatch console).
# To get notified, add an SNS topic ARN to alarm_actions.
resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "${aws_lambda_function.cloud_resume_function.function_name}-errors"
  alarm_description   = "Visit counter Lambda returned errors or timed out"
  namespace           = "AWS/Lambda"
  metric_name         = "Errors"
  statistic           = "Sum"
  period              = 300
  evaluation_periods  = 1
  threshold           = 1
  comparison_operator = "GreaterThanOrEqualToThreshold"
  treat_missing_data  = "notBreaching"

  dimensions = {
    FunctionName = aws_lambda_function.cloud_resume_function.function_name
  }
}

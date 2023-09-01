# Terraform Configuration for AWS API Gateway and Integration

# Define an HTTP API in API Gateway for cloud resume function
resource "aws_apigatewayv2_api" "api_gateway_cloud_resume" {
  name          = "API-Gateway-Cloud-Resume"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["https://resume.faraguti.cloud", "https://resume.faraguti.com", "https://faraguti.com/"]
  }

  # Specify dependency on the Lambda function
  depends_on = [ aws_lambda_function.cloud_resume_function ]
}

# Configure an integration with AWS Lambda for the API
resource "aws_apigatewayv2_integration" "lambda_function_integration" {
  api_id           = aws_apigatewayv2_api.api_gateway_cloud_resume.id
  integration_type = "AWS_PROXY"

  connection_type     = "INTERNET"
  description         = "Lambda function integration"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.cloud_resume_function.invoke_arn

  passthrough_behavior     = "WHEN_NO_MATCH"
  payload_format_version   = "2.0"
}

# Define a route in the API to connect to the Lambda integration
resource "aws_apigatewayv2_route" "api_route" {
  api_id    = aws_apigatewayv2_api.api_gateway_cloud_resume.id
  route_key = "GET /cloud-resume-function"

  target = "integrations/${aws_apigatewayv2_integration.lambda_function_integration.id}"
}

# Grant necessary permissions for API Gateway to invoke the Lambda function
resource "aws_lambda_permission" "api_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloud_resume_function.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.api_gateway_cloud_resume.execution_arn}/*/*/cloud-resume-function"
}

# Define a CloudWatch Log Group for API Gateway logs
resource "aws_cloudwatch_log_group" "log_group_api" {
  name = "/aws/api-gw/${aws_apigatewayv2_api.api_gateway_cloud_resume.name}"

  retention_in_days = 14
}

# Define a stage for the API to automatically deploy changes
resource "aws_apigatewayv2_stage" "api_stage" {
  api_id      = aws_apigatewayv2_api.api_gateway_cloud_resume.id
  name        = "$default"
  auto_deploy = true

  # Configure access log settings for the stage
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.log_group_api.arn

    # Define log format using context variables
    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
    })
  }
}

# =========================================================
# PRIMARY REGION API — SYDNEY
# =========================================================

resource "aws_api_gateway_rest_api" "primary" {
  provider = aws.primary

  name        = "HighAvailabilityAPI"
  description = "Serverless API in the primary AWS Region"
}

resource "aws_api_gateway_resource" "read_primary" {
  provider = aws.primary

  rest_api_id = aws_api_gateway_rest_api.primary.id
  parent_id   = aws_api_gateway_rest_api.primary.root_resource_id
  path_part   = "read"
}

resource "aws_api_gateway_method" "read_primary" {
  provider = aws.primary

  rest_api_id   = aws_api_gateway_rest_api.primary.id
  resource_id   = aws_api_gateway_resource.read_primary.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "read_primary" {
  provider = aws.primary

  rest_api_id             = aws_api_gateway_rest_api.primary.id
  resource_id             = aws_api_gateway_resource.read_primary.id
  http_method             = aws_api_gateway_method.read_primary.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.read_primary.invoke_arn
}

resource "aws_api_gateway_resource" "write_primary" {
  provider = aws.primary

  rest_api_id = aws_api_gateway_rest_api.primary.id
  parent_id   = aws_api_gateway_rest_api.primary.root_resource_id
  path_part   = "write"
}

resource "aws_api_gateway_method" "write_primary" {
  provider = aws.primary

  rest_api_id   = aws_api_gateway_rest_api.primary.id
  resource_id   = aws_api_gateway_resource.write_primary.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "write_primary" {
  provider = aws.primary

  rest_api_id             = aws_api_gateway_rest_api.primary.id
  resource_id             = aws_api_gateway_resource.write_primary.id
  http_method             = aws_api_gateway_method.write_primary.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.write_primary.invoke_arn
}

resource "aws_lambda_permission" "read_primary" {
  provider = aws.primary

  statement_id  = "AllowAPIGatewayReadInvocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.read_primary.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.primary.execution_arn}/*/GET/read"
}

resource "aws_lambda_permission" "write_primary" {
  provider = aws.primary

  statement_id  = "AllowAPIGatewayWriteInvocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.write_primary.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.primary.execution_arn}/*/POST/write"
}

resource "aws_api_gateway_deployment" "primary" {
  provider = aws.primary

  rest_api_id = aws_api_gateway_rest_api.primary.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.read_primary.id,
      aws_api_gateway_method.read_primary.id,
      aws_api_gateway_integration.read_primary.id,
      aws_api_gateway_resource.write_primary.id,
      aws_api_gateway_method.write_primary.id,
      aws_api_gateway_integration.write_primary.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.read_primary,
    aws_api_gateway_integration.write_primary
  ]
}

resource "aws_api_gateway_stage" "primary" {
  provider = aws.primary

  deployment_id = aws_api_gateway_deployment.primary.id
  rest_api_id   = aws_api_gateway_rest_api.primary.id
  stage_name    = "prod"
}


# =========================================================
# SECONDARY REGION API — SINGAPORE
# =========================================================

resource "aws_api_gateway_rest_api" "secondary" {
  provider = aws.secondary

  name        = "HighAvailabilityAPI"
  description = "Serverless API in the secondary AWS Region"
}

resource "aws_api_gateway_resource" "read_secondary" {
  provider = aws.secondary

  rest_api_id = aws_api_gateway_rest_api.secondary.id
  parent_id   = aws_api_gateway_rest_api.secondary.root_resource_id
  path_part   = "read"
}

resource "aws_api_gateway_method" "read_secondary" {
  provider = aws.secondary

  rest_api_id   = aws_api_gateway_rest_api.secondary.id
  resource_id   = aws_api_gateway_resource.read_secondary.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "read_secondary" {
  provider = aws.secondary

  rest_api_id             = aws_api_gateway_rest_api.secondary.id
  resource_id             = aws_api_gateway_resource.read_secondary.id
  http_method             = aws_api_gateway_method.read_secondary.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.read_secondary.invoke_arn
}

resource "aws_api_gateway_resource" "write_secondary" {
  provider = aws.secondary

  rest_api_id = aws_api_gateway_rest_api.secondary.id
  parent_id   = aws_api_gateway_rest_api.secondary.root_resource_id
  path_part   = "write"
}

resource "aws_api_gateway_method" "write_secondary" {
  provider = aws.secondary

  rest_api_id   = aws_api_gateway_rest_api.secondary.id
  resource_id   = aws_api_gateway_resource.write_secondary.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "write_secondary" {
  provider = aws.secondary

  rest_api_id             = aws_api_gateway_rest_api.secondary.id
  resource_id             = aws_api_gateway_resource.write_secondary.id
  http_method             = aws_api_gateway_method.write_secondary.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.write_secondary.invoke_arn
}

resource "aws_lambda_permission" "read_secondary" {
  provider = aws.secondary

  statement_id  = "AllowAPIGatewayReadInvocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.read_secondary.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.secondary.execution_arn}/*/GET/read"
}

resource "aws_lambda_permission" "write_secondary" {
  provider = aws.secondary

  statement_id  = "AllowAPIGatewayWriteInvocation"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.write_secondary.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.secondary.execution_arn}/*/POST/write"
}

resource "aws_api_gateway_deployment" "secondary" {
  provider = aws.secondary

  rest_api_id = aws_api_gateway_rest_api.secondary.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.read_secondary.id,
      aws_api_gateway_method.read_secondary.id,
      aws_api_gateway_integration.read_secondary.id,
      aws_api_gateway_resource.write_secondary.id,
      aws_api_gateway_method.write_secondary.id,
      aws_api_gateway_integration.write_secondary.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.read_secondary,
    aws_api_gateway_integration.write_secondary
  ]
}

resource "aws_api_gateway_stage" "secondary" {
  provider = aws.secondary

  deployment_id = aws_api_gateway_deployment.secondary.id
  rest_api_id   = aws_api_gateway_rest_api.secondary.id
  stage_name    = "prod"
}
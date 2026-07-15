output "primary_api_invoke_url" {
  description = "Invoke URL for the primary API Gateway deployment"
  value       = "https://${aws_api_gateway_rest_api.primary.id}.execute-api.${var.primary_region}.amazonaws.com/${aws_api_gateway_stage.primary.stage_name}"
}

output "secondary_api_invoke_url" {
  description = "Invoke URL for the secondary API Gateway deployment"
  value       = "https://${aws_api_gateway_rest_api.secondary.id}.execute-api.${var.secondary_region}.amazonaws.com/${aws_api_gateway_stage.secondary.stage_name}"
}

output "custom_api_url" {
  description = "Custom HTTPS endpoint managed through Route 53 failover"
  value       = "https://${var.api_subdomain}"
}

output "primary_health_check_id" {
  description = "Route 53 health check ID for the primary API"
  value       = aws_route53_health_check.primary.id
}

output "secondary_health_check_id" {
  description = "Route 53 health check ID for the secondary API"
  value       = aws_route53_health_check.secondary.id
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB Global Table"
  value       = aws_dynamodb_table.high_availability_table.name
}
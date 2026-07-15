# =========================================================
# API GATEWAY CUSTOM DOMAINS
# =========================================================

resource "aws_api_gateway_domain_name" "primary" {
  provider = aws.primary

  domain_name              = var.api_subdomain
  regional_certificate_arn = aws_acm_certificate_validation.primary.certificate_arn
  security_policy          = "TLS_1_2"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_domain_name" "secondary" {
  provider = aws.secondary

  domain_name              = var.api_subdomain
  regional_certificate_arn = aws_acm_certificate_validation.secondary.certificate_arn
  security_policy          = "TLS_1_2"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


# =========================================================
# API MAPPINGS
# =========================================================

resource "aws_api_gateway_base_path_mapping" "primary" {
  provider = aws.primary

  api_id      = aws_api_gateway_rest_api.primary.id
  stage_name  = aws_api_gateway_stage.primary.stage_name
  domain_name = aws_api_gateway_domain_name.primary.domain_name
}

resource "aws_api_gateway_base_path_mapping" "secondary" {
  provider = aws.secondary

  api_id      = aws_api_gateway_rest_api.secondary.id
  stage_name  = aws_api_gateway_stage.secondary.stage_name
  domain_name = aws_api_gateway_domain_name.secondary.domain_name
}


# =========================================================
# ROUTE 53 HEALTH CHECKS
# =========================================================

resource "aws_route53_health_check" "primary" {
  provider = aws.primary

  fqdn = "${aws_api_gateway_rest_api.primary.id}.execute-api.${var.primary_region}.amazonaws.com"

  port              = 443
  type              = "HTTPS"
  resource_path     = "/prod/read"
  request_interval  = 30
  failure_threshold = 3
  enable_sni        = true

  tags = {
    Name    = "Primary-API-Health-Check"
    Project = "Serverless Cross-Region DR"
  }
}

resource "aws_route53_health_check" "secondary" {
  provider = aws.primary

  fqdn = "${aws_api_gateway_rest_api.secondary.id}.execute-api.${var.secondary_region}.amazonaws.com"

  port              = 443
  type              = "HTTPS"
  resource_path     = "/prod/read"
  request_interval  = 30
  failure_threshold = 3
  enable_sni        = true

  tags = {
    Name    = "Secondary-API-Health-Check"
    Project = "Serverless Cross-Region DR"
  }
}


# =========================================================
# ROUTE 53 FAILOVER RECORDS
# =========================================================

resource "aws_route53_record" "primary" {
  provider = aws.primary

  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.api_subdomain
  type    = "A"

  set_identifier  = "Primary-Sydney"
  health_check_id = aws_route53_health_check.primary.id

  failover_routing_policy {
    type = "PRIMARY"
  }

  alias {
    name                   = aws_api_gateway_domain_name.primary.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.primary.regional_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "secondary" {
  provider = aws.primary

  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.api_subdomain
  type    = "A"

  set_identifier  = "Secondary-Singapore"
  health_check_id = aws_route53_health_check.secondary.id

  failover_routing_policy {
    type = "SECONDARY"
  }

  alias {
    name                   = aws_api_gateway_domain_name.secondary.regional_domain_name
    zone_id                = aws_api_gateway_domain_name.secondary.regional_zone_id
    evaluate_target_health = false
  }
}
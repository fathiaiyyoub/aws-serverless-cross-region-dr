resource "aws_dynamodb_table" "high_availability_table" {
  provider = aws.primary

  name         = "HighAvailabilityTable"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ItemId"

  attribute {
    name = "ItemId"
    type = "S"
  }

  replica {
    region_name = var.secondary_region
  }

  tags = {
    Name    = "HighAvailabilityTable"
    Project = "Serverless Cross-Region DR"
  }
}
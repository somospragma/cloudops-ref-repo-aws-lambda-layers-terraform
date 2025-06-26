# Lambda Layers Sample - Data Sources

# Current AWS region
data "aws_region" "current" {}

# Current AWS caller identity
data "aws_caller_identity" "current" {}

# Available AWS availability zones
data "aws_availability_zones" "available" {
  state = "available"
}
# Lambda Layers Sample - Provider Configuration
# Configure AWS Provider
provider "aws" {
  alias   = "principal"
  region = var.aws_region
  profile = var.profile
   
  default_tags {
    tags = var.common_tags
  }
}


terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.31.0"
    }
  }
}

